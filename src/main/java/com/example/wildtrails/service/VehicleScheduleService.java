package com.example.wildtrails.service;

import com.example.wildtrails.module.Vehicle;
import com.example.wildtrails.module.VehicleSchedule;
import com.example.wildtrails.repository.VehicleRepository;
import com.example.wildtrails.repository.VehicleScheduleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class VehicleScheduleService {

    @Autowired
    private VehicleScheduleRepository vehicleScheduleRepository;

    @Autowired
    private VehicleRepository vehicleRepository;

    public boolean bookVehicle(String vehicleId, LocalDate startDate, LocalDate endDate, String bookingId, String tourId) {
        try {
            System.out.println("=== VEHICLE SCHEDULING ===");
            System.out.println("Vehicle ID: " + vehicleId);
            System.out.println("Start Date: " + startDate);
            System.out.println("End Date: " + endDate);
            System.out.println("Booking ID: " + bookingId);
            System.out.println("Tour ID: " + tourId);

            LocalDate currentDate = startDate;
            while (!currentDate.isAfter(endDate)) {
                // Check if schedule already exists
                List<VehicleSchedule> existingSchedules = vehicleScheduleRepository.findByVehicleIdAndScheduleDate(vehicleId, currentDate);

                VehicleSchedule schedule;
                if (!existingSchedules.isEmpty()) {
                    // Update existing schedule
                    schedule = existingSchedules.get(0);
                    schedule.setStatus("booked");
                    schedule.setBookingId(bookingId);
                    schedule.setTourId(tourId);
                    schedule.setUpdatedAt(LocalDateTime.now());
                    System.out.println("Updated existing schedule for " + vehicleId + " on " + currentDate);
                } else {
                    // Create new schedule
                    schedule = new VehicleSchedule();
                    schedule.setVehicleId(vehicleId);
                    schedule.setScheduleDate(currentDate);
                    schedule.setStatus("booked");
                    schedule.setBookingId(bookingId);
                    schedule.setTourId(tourId);
                    schedule.setCreatedAt(LocalDateTime.now());
                    schedule.setUpdatedAt(LocalDateTime.now());
                    System.out.println("Created new schedule for " + vehicleId + " on " + currentDate);
                }

                vehicleScheduleRepository.save(schedule);
                currentDate = currentDate.plusDays(1);
            }

            System.out.println("Vehicle " + vehicleId + " booked successfully for tour " + tourId);
            return true;
        } catch (Exception e) {
            System.err.println("Error booking vehicle " + vehicleId + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public void releaseVehicleBooking(String bookingId) {
        try {
            List<VehicleSchedule> schedules = vehicleScheduleRepository.findByBookingId(bookingId);
            for (VehicleSchedule schedule : schedules) {
                schedule.setStatus("available");
                schedule.setBookingId(null);
                schedule.setTourId(null);
                schedule.setUpdatedAt(LocalDateTime.now());
                vehicleScheduleRepository.save(schedule);
            }
            System.out.println("Released vehicle schedules for booking: " + bookingId);
        } catch (Exception e) {
            System.err.println("Error releasing vehicle booking: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public List<Vehicle> getAvailableVehicles(LocalDate startDate, LocalDate endDate, Integer requiredCapacity) {
        try {
            System.out.println("=== GETTING AVAILABLE VEHICLES ===");
            System.out.println("Start Date: " + startDate + ", End Date: " + endDate + ", Capacity: " + requiredCapacity);

            // Get all active vehicles
            List<Vehicle> allActiveVehicles = vehicleRepository.findByStatus("active");
            System.out.println("Total active vehicles: " + allActiveVehicles.size());

            List<Vehicle> availableVehicles = new ArrayList<>();

            for (Vehicle vehicle : allActiveVehicles) {
                if (isVehicleAvailable(vehicle.getVehicleId(), startDate, endDate)) {
                    if (requiredCapacity == null || vehicle.getCapacity() >= requiredCapacity) {
                        availableVehicles.add(vehicle);
                    }
                }
            }

            System.out.println("Available vehicles found: " + availableVehicles.size());
            return availableVehicles;
        } catch (Exception e) {
            System.err.println("Error getting available vehicles: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    private boolean isVehicleAvailable(String vehicleId, LocalDate startDate, LocalDate endDate) {
        try {
            // Check for any booked schedules in the date range
            List<VehicleSchedule> conflictingSchedules = vehicleScheduleRepository.findOverlappingSchedules(
                    vehicleId, startDate, endDate);

            boolean available = conflictingSchedules.isEmpty();
            System.out.println("Vehicle " + vehicleId + " available from " + startDate + " to " + endDate + ": " + available);

            return available;
        } catch (Exception e) {
            System.err.println("Error checking vehicle availability: " + e.getMessage());
            return false;
        }
    }

    public List<LocalDate> getBookedDatesForVehicle(String vehicleId, LocalDate startDate, LocalDate endDate) {
        try {
            return vehicleScheduleRepository.findBookedDatesForVehicle(vehicleId, startDate, endDate);
        } catch (Exception e) {
            System.err.println("Error getting booked dates for vehicle: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    public boolean isVehicleBookedBetweenDates(String vehicleId, LocalDate startDate, LocalDate endDate) {
        try {
            return vehicleScheduleRepository.isVehicleBookedBetweenDates(vehicleId, startDate, endDate);
        } catch (Exception e) {
            System.err.println("Error checking if vehicle is booked: " + e.getMessage());
            return false;
        }
    }
}