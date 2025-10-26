package com.example.wildtrails.service;

import com.example.wildtrails.module.Vehicle;
import com.example.wildtrails.repository.VehicleRepository;
import com.example.wildtrails.util.PasswordUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@Service
public class VehicleService {

    @Autowired
    private VehicleRepository vehicleRepository;

    public List<Vehicle> getAllActiveVehicles() {
        return vehicleRepository.findByStatusOrderByVehicleNameAsc("active");
    }

    public Optional<Vehicle> getVehicleById(String vehicleId) {
        return vehicleRepository.findByVehicleId(vehicleId);
    }

    public Vehicle saveVehicle(Vehicle vehicle, MultipartFile driverPhotoFile, MultipartFile vehiclePhotoFile) throws IOException {
        // Generate vehicle ID if not provided
        if (vehicle.getVehicleId() == null || vehicle.getVehicleId().isEmpty()) {
            vehicle.setVehicleId(generateVehicleId());
        }

        // Encrypt password
        if (vehicle.getPlainPassword() != null && !vehicle.getPlainPassword().isEmpty()) {
            vehicle.setDriverPassword(PasswordUtil.encrypt(vehicle.getPlainPassword()));
        }

        // Handle driver photo upload
        if (driverPhotoFile != null && !driverPhotoFile.isEmpty()) {
            vehicle.setDriverPhotoName(driverPhotoFile.getOriginalFilename());
            vehicle.setDriverPhotoData(driverPhotoFile.getBytes());
        }

        // Handle vehicle photo upload
        if (vehiclePhotoFile != null && !vehiclePhotoFile.isEmpty()) {
            vehicle.setVehiclePhotoName(vehiclePhotoFile.getOriginalFilename());
            vehicle.setVehiclePhotoData(vehiclePhotoFile.getBytes());
        }

        return vehicleRepository.save(vehicle);
    }

    public void deleteVehicle(String vehicleId) {
        Optional<Vehicle> vehicleOptional = vehicleRepository.findByVehicleId(vehicleId);
        vehicleOptional.ifPresent(vehicle -> {
            vehicle.setStatus("inactive");
            vehicleRepository.save(vehicle);
        });
    }

    private String generateVehicleId() {
        String maxVehicleId = vehicleRepository.findMaxVehicleId();
        if (maxVehicleId != null) {
            try {
                int lastNumber = Integer.parseInt(maxVehicleId.replace("dri-", ""));
                return "dri-" + (lastNumber + 1);
            } catch (NumberFormatException e) {
                return "dri-1";
            }
        }
        return "dri-1";
    }

    public byte[] getDriverPhoto(String vehicleId) {
        Optional<Vehicle> vehicle = vehicleRepository.findByVehicleId(vehicleId);
        return vehicle.map(Vehicle::getDriverPhotoData).orElse(null);
    }

    public byte[] getVehiclePhoto(String vehicleId) {
        Optional<Vehicle> vehicle = vehicleRepository.findByVehicleId(vehicleId);
        return vehicle.map(Vehicle::getVehiclePhotoData).orElse(null);
    }

    public boolean validateVehiclePassword(String vehicleId, String password) {
        Optional<Vehicle> vehicle = vehicleRepository.findByVehicleId(vehicleId);
        return vehicle.map(v -> PasswordUtil.checkPassword(password, v.getDriverPassword()))
                .orElse(false);
    }

    public boolean deleteVehiclePermanently(String vehicleId) {
        Optional<Vehicle> vehicleOptional = vehicleRepository.findByVehicleId(vehicleId);
        if (vehicleOptional.isPresent()) {
            vehicleRepository.delete(vehicleOptional.get());
            return true;
        }
        return false;
    }

    public void toggleVehicleStatus(String vehicleId) {
        Optional<Vehicle> vehicleOptional = vehicleRepository.findByVehicleId(vehicleId);
        vehicleOptional.ifPresent(vehicle -> {
            vehicle.setVehicleReady(!vehicle.getVehicleReady());
            vehicleRepository.save(vehicle);
        });
    }

    // New method to check if email already exists
    public boolean isEmailAlreadyRegistered(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        List<Vehicle> activeVehicles = getAllActiveVehicles();
        return activeVehicles.stream()
                .anyMatch(vehicle -> email.equalsIgnoreCase(vehicle.getDriverEmail()));
    }
}