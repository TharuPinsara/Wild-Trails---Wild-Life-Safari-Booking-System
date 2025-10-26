package com.example.wildtrails.controller;

import com.example.wildtrails.module.Vehicle;
import com.example.wildtrails.module.VehicleSchedule;
import com.example.wildtrails.repository.VehicleRepository;
import com.example.wildtrails.repository.VehicleScheduleRepository;
import com.example.wildtrails.service.VehicleScheduleService;
import com.example.wildtrails.service.VehicleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/vehicles")
public class VehicleController {

    @Autowired
    private VehicleService vehicleService;

    @Autowired
    private VehicleScheduleRepository vehicleScheduleRepository;

    @GetMapping
    public String showVehiclesList(Model model) {
        List<Vehicle> vehicles = vehicleService.getAllActiveVehicles();
        model.addAttribute("vehicles", vehicles);
        return "vehicles/vehicles";
    }

    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        model.addAttribute("vehicle", new Vehicle());
        return "vehicles/registervehicles";
    }

    @PostMapping("/register")
    public String registerVehicle(
            @RequestParam String driverName,
            @RequestParam String driverPhone,
            @RequestParam(required = false) String driverEmail,
            @RequestParam String password,
            @RequestParam String vehicleName,
            @RequestParam String vehicleType,
            @RequestParam Integer capacity,
            @RequestParam Boolean vehicleReady,
            @RequestParam(required = false) String[] inclusions,
            @RequestParam Double dailyRate,
            @RequestParam(required = false) String specialFeatures,
            @RequestParam(required = false) MultipartFile driverPhotoFile,
            @RequestParam(required = false) MultipartFile vehiclePhotoFile,
            Model model) {

        try {
            // Password length validation
            if (password.length() < 8) {
                model.addAttribute("error", "Password must be at least 8 characters long");
                model.addAttribute("vehicle", new Vehicle());
                return "vehicles/registervehicles";
            }

            // Email uniqueness validation (only if email is provided)
            if (driverEmail != null && !driverEmail.trim().isEmpty()) {
                if (vehicleService.isEmailAlreadyRegistered(driverEmail)) {
                    model.addAttribute("error", "This email is already registered. Please use a different email address.");
                    model.addAttribute("vehicle", new Vehicle());
                    return "vehicles/registervehicles";
                }
            }

            Vehicle vehicle = new Vehicle();
            vehicle.setDriverName(driverName);
            vehicle.setDriverPhone(driverPhone);
            vehicle.setDriverEmail(driverEmail);
            vehicle.setPlainPassword(password);
            vehicle.setVehicleName(vehicleName);
            vehicle.setVehicleType(vehicleType);
            vehicle.setCapacity(capacity);
            vehicle.setVehicleReady(vehicleReady);

            // Convert inclusions array to comma-separated string
            if (inclusions != null && inclusions.length > 0) {
                vehicle.setInclusions(String.join(",", inclusions));
            }

            vehicle.setDailyRate(dailyRate);
            vehicle.setSpecialFeatures(specialFeatures);
            vehicle.setStatus("active");

            Vehicle savedVehicle = vehicleService.saveVehicle(vehicle, driverPhotoFile, vehiclePhotoFile);
            model.addAttribute("success", "Vehicle registered successfully with ID: " + savedVehicle.getVehicleId());

        } catch (Exception e) {
            model.addAttribute("error", "Error registering vehicle: " + e.getMessage());
            return "vehicles/registervehicles";
        }

        return "redirect:/vehicles?success";
    }

    @GetMapping("/driver-photo/{vehicleId}")
    public ResponseEntity<byte[]> getDriverPhoto(@PathVariable String vehicleId) {
        byte[] photoData = vehicleService.getDriverPhoto(vehicleId);
        if (photoData != null) {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.IMAGE_JPEG);
            return new ResponseEntity<>(photoData, headers, HttpStatus.OK);
        }
        return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }

    @GetMapping("/vehicle-photo/{vehicleId}")
    public ResponseEntity<byte[]> getVehiclePhoto(@PathVariable String vehicleId) {
        byte[] photoData = vehicleService.getVehiclePhoto(vehicleId);
        if (photoData != null) {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.IMAGE_JPEG);
            return new ResponseEntity<>(photoData, headers, HttpStatus.OK);
        }
        return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }

    @GetMapping("/admin")
    public String showAdminLogin(HttpSession session, Model model) {
        if (session.getAttribute("driverLoggedIn") != null) {
            String vehicleId = (String) session.getAttribute("driverVehicleId");
            return "redirect:/vehicles/admin/dashboard";
        }
        return "vehicles/adminvehicle";
    }

    @PostMapping("/admin")
    public String processAdminLogin(
            @RequestParam String driverEmail,
            @RequestParam String password,
            @RequestParam String login,
            HttpSession session,
            Model model) {

        try {
            // Find vehicle by driver email (only active vehicles)
            List<Vehicle> vehicles = vehicleService.getAllActiveVehicles();
            Vehicle driverVehicle = null;

            for (Vehicle vehicle : vehicles) {
                if (driverEmail.equals(vehicle.getDriverEmail())) {
                    driverVehicle = vehicle;
                    break;
                }
            }

            if (driverVehicle == null) {
                model.addAttribute("error", "No active vehicle found with this email address");
                return "vehicles/adminvehicle";
            }

            // Validate password
            if (vehicleService.validateVehiclePassword(driverVehicle.getVehicleId(), password)) {
                session.setAttribute("driverLoggedIn", true);
                session.setAttribute("driverVehicleId", driverVehicle.getVehicleId());
                session.setAttribute("driverName", driverVehicle.getDriverName());
                return "redirect:/vehicles/admin/dashboard";
            } else {
                model.addAttribute("error", "Invalid password");
                return "vehicles/adminvehicle";
            }

        } catch (Exception e) {
            model.addAttribute("error", "Login failed: " + e.getMessage());
            return "vehicles/adminvehicle";
        }
    }

    @GetMapping("/admin/dashboard")
    public String showAdminDashboard(HttpSession session, Model model) {
        if (session.getAttribute("driverLoggedIn") == null) {
            return "redirect:/vehicles/admin";
        }

        String vehicleId = (String) session.getAttribute("driverVehicleId");
        Optional<Vehicle> vehicleOptional = vehicleService.getVehicleById(vehicleId);

        if (vehicleOptional.isEmpty()) {
            session.removeAttribute("driverLoggedIn");
            session.removeAttribute("driverVehicleId");
            model.addAttribute("error", "Vehicle not found");
            return "redirect:/vehicles/admin";
        }

        Vehicle vehicle = vehicleOptional.get();
        model.addAttribute("vehicle", vehicle);

        // Get schedules for this vehicle to show in dashboard
        List<VehicleSchedule> schedules = vehicleScheduleRepository.findByVehicleId(vehicleId);

        // Calculate statistics for dashboard
        long totalSchedules = schedules.size();
        long assignedSchedules = schedules.stream()
                .filter(s -> "booked".equals(s.getStatus()))
                .count();
        long availableSchedules = schedules.stream()
                .filter(s -> "available".equals(s.getStatus()))
                .count();
        double totalEarnings = schedules.stream()
                .filter(s -> "booked".equals(s.getStatus()) || "confirmed".equals(s.getStatus()))
                .count() * vehicle.getDailyRate();

        model.addAttribute("totalSchedules", totalSchedules);
        model.addAttribute("assignedSchedules", assignedSchedules);
        model.addAttribute("availableSchedules", availableSchedules);
        model.addAttribute("totalEarnings", totalEarnings);

        return "vehicles/adminvehicle";
    }

    @GetMapping("/update/{vehicleId}")
    public String showUpdateForm(@PathVariable String vehicleId, HttpSession session, Model model) {
        if (session.getAttribute("driverLoggedIn") == null) {
            return "redirect:/vehicles/admin";
        }

        // Verify that the logged-in driver owns this vehicle
        String loggedInVehicleId = (String) session.getAttribute("driverVehicleId");
        if (!vehicleId.equals(loggedInVehicleId)) {
            model.addAttribute("error", "Unauthorized access");
            return "redirect:/vehicles/admin/dashboard";
        }

        Optional<Vehicle> vehicleOptional = vehicleService.getVehicleById(vehicleId);
        if (vehicleOptional.isEmpty()) {
            model.addAttribute("error", "Vehicle not found");
            return "redirect:/vehicles/admin/dashboard";
        }

        model.addAttribute("vehicle", vehicleOptional.get());
        return "vehicles/updatevehicle";
    }

    @PostMapping("/update/{vehicleId}")
    public String updateVehicle(
            @PathVariable String vehicleId,
            @RequestParam String driverName,
            @RequestParam String driverPhone,
            @RequestParam(required = false) String driverEmail,
            @RequestParam(required = false) String password,
            @RequestParam String vehicleName,
            @RequestParam String vehicleType,
            @RequestParam Integer capacity,
            @RequestParam Boolean vehicleReady,
            @RequestParam(required = false) String[] inclusions,
            @RequestParam Double dailyRate,
            @RequestParam(required = false) String specialFeatures,
            @RequestParam(required = false) MultipartFile driverPhotoFile,
            @RequestParam(required = false) MultipartFile vehiclePhotoFile,
            HttpSession session,
            Model model) {

        if (session.getAttribute("driverLoggedIn") == null) {
            return "redirect:/vehicles/admin";
        }

        try {
            // Verify that the logged-in driver owns this vehicle
            String loggedInVehicleId = (String) session.getAttribute("driverVehicleId");
            if (!vehicleId.equals(loggedInVehicleId)) {
                model.addAttribute("error", "Unauthorized access");
                return "redirect:/vehicles/admin/dashboard";
            }

            Optional<Vehicle> vehicleOptional = vehicleService.getVehicleById(vehicleId);
            if (vehicleOptional.isEmpty()) {
                model.addAttribute("error", "Vehicle not found");
                return "redirect:/vehicles/admin/dashboard";
            }

            Vehicle vehicle = vehicleOptional.get();

            // Update vehicle details
            vehicle.setDriverName(driverName);
            vehicle.setDriverPhone(driverPhone);
            if (driverEmail != null && !driverEmail.trim().isEmpty()) {
                vehicle.setDriverEmail(driverEmail);
            }
            vehicle.setVehicleName(vehicleName);
            vehicle.setVehicleType(vehicleType);
            vehicle.setCapacity(capacity);
            vehicle.setVehicleReady(vehicleReady);

            // Convert inclusions array to comma-separated string
            if (inclusions != null && inclusions.length > 0) {
                vehicle.setInclusions(String.join(",", inclusions));
            } else {
                vehicle.setInclusions(null);
            }

            vehicle.setDailyRate(dailyRate);
            vehicle.setSpecialFeatures(specialFeatures);

            // Update password if provided
            if (password != null && !password.trim().isEmpty()) {
                if (password.length() < 8) {
                    model.addAttribute("error", "Password must be at least 8 characters long");
                    model.addAttribute("vehicle", vehicle);
                    return "vehicles/updatevehicle";
                }
                vehicle.setPlainPassword(password);
            }

            // Save updated vehicle
            Vehicle updatedVehicle = vehicleService.saveVehicle(vehicle, driverPhotoFile, vehiclePhotoFile);
            model.addAttribute("success", "Vehicle updated successfully");

            return "redirect:/vehicles/admin/dashboard?success";

        } catch (Exception e) {
            model.addAttribute("error", "Error updating vehicle: " + e.getMessage());
            return "redirect:/vehicles/update/" + vehicleId;
        }
    }

    @PostMapping("/delete/{vehicleId}")
    public String deleteVehicle(@PathVariable String vehicleId, HttpSession session, Model model) {
        if (session.getAttribute("driverLoggedIn") == null) {
            return "redirect:/vehicles/admin";
        }

        try {
            vehicleService.deleteVehicle(vehicleId);
            session.removeAttribute("driverLoggedIn");
            session.removeAttribute("driverVehicleId");
            model.addAttribute("success", "Vehicle deleted successfully");
            return "redirect:/vehicles";
        } catch (Exception e) {
            model.addAttribute("error", "Error deleting vehicle: " + e.getMessage());
            return "redirect:/vehicles/admin/dashboard";
        }
    }

    @GetMapping("/logout")
    public String driverLogout(HttpSession session) {
        session.removeAttribute("driverLoggedIn");
        session.removeAttribute("driverVehicleId");
        session.removeAttribute("driverName");
        return "redirect:/vehicles";
    }

    @PostMapping("/delete-permanent/{vehicleId}")
    public String deleteVehiclePermanent(@PathVariable String vehicleId, HttpSession session, Model model) {
        if (session.getAttribute("driverLoggedIn") == null) {
            return "redirect:/vehicles/admin";
        }

        try {
            boolean deleted = vehicleService.deleteVehiclePermanently(vehicleId);
            if (deleted) {
                session.removeAttribute("driverLoggedIn");
                session.removeAttribute("driverVehicleId");
                session.removeAttribute("driverName");
                model.addAttribute("success", "Vehicle permanently deleted successfully");
            } else {
                model.addAttribute("error", "Vehicle not found");
            }
            return "redirect:/vehicles";
        } catch (Exception e) {
            model.addAttribute("error", "Error deleting vehicle: " + e.getMessage());
            return "redirect:/vehicles/admin/dashboard";
        }
    }

    // Toggle active/inactive status endpoint
    @PostMapping("/toggle-status/{vehicleId}")
    public String toggleVehicleStatus(@PathVariable String vehicleId, HttpSession session, Model model) {
        if (session.getAttribute("driverLoggedIn") == null) {
            return "redirect:/vehicles/admin";
        }

        try {
            vehicleService.toggleVehicleStatus(vehicleId);
            model.addAttribute("success", "Vehicle status updated successfully");
        } catch (Exception e) {
            model.addAttribute("error", "Error updating vehicle status: " + e.getMessage());
        }

        return "redirect:/vehicles/admin/dashboard";
    }

    @GetMapping("/admin/schedule")
    public String showDriverSchedule(HttpSession session, Model model) {
        if (session.getAttribute("driverLoggedIn") == null) {
            return "redirect:/vehicles/admin";
        }

        String vehicleId = (String) session.getAttribute("driverVehicleId");
        Optional<Vehicle> vehicleOptional = vehicleService.getVehicleById(vehicleId);

        if (vehicleOptional.isEmpty()) {
            session.removeAttribute("driverLoggedIn");
            session.removeAttribute("driverVehicleId");
            model.addAttribute("error", "Vehicle not found");
            return "redirect:/vehicles/admin";
        }

        Vehicle vehicle = vehicleOptional.get();
        model.addAttribute("vehicle", vehicle);

        // Get schedules for this vehicle
        List<VehicleSchedule> schedules = vehicleScheduleRepository.findByVehicleId(vehicleId);
        model.addAttribute("schedules", schedules);

        // Calculate statistics
        long totalSchedules = schedules.size();
        long assignedSchedules = schedules.stream()
                .filter(s -> "booked".equals(s.getStatus()))
                .count();
        long availableSchedules = schedules.stream()
                .filter(s -> "available".equals(s.getStatus()))
                .count();

        // Calculate estimated earnings (daily rate * number of booked days)
        double totalEarnings = schedules.stream()
                .filter(s -> "booked".equals(s.getStatus()) || "confirmed".equals(s.getStatus()))
                .count() * vehicle.getDailyRate();

        model.addAttribute("totalSchedules", totalSchedules);
        model.addAttribute("assignedSchedules", assignedSchedules);
        model.addAttribute("availableSchedules", availableSchedules);
        model.addAttribute("totalEarnings", totalEarnings);

        return "vehicles/driverschedule";
    }

    @PostMapping("/schedules/add")
    public String addSchedule(
            @RequestParam String scheduleDate,
            @RequestParam(required = false) String notes,
            HttpSession session,
            Model model) {

        if (session.getAttribute("driverLoggedIn") == null) {
            return "redirect:/vehicles/admin";
        }

        try {
            String vehicleId = (String) session.getAttribute("driverVehicleId");

            // Validate that the logged-in driver owns this vehicle
            String loggedInVehicleId = (String) session.getAttribute("driverVehicleId");
            if (!vehicleId.equals(loggedInVehicleId)) {
                model.addAttribute("error", "Unauthorized access");
                return "redirect:/vehicles/admin/schedule";
            }

            // Parse the date
            LocalDate date = LocalDate.parse(scheduleDate);

            // Check if schedule already exists for this date
            List<VehicleSchedule> existingSchedules = vehicleScheduleRepository.findByVehicleIdAndScheduleDate(vehicleId, date);

            if (!existingSchedules.isEmpty()) {
                model.addAttribute("error", "Schedule already exists for " + scheduleDate);
                return "redirect:/vehicles/admin/schedule";
            }

            // Create new schedule
            VehicleSchedule schedule = new VehicleSchedule();
            schedule.setVehicleId(vehicleId);
            schedule.setScheduleDate(date);
            schedule.setStatus("available");
            schedule.setTourId(notes); // Using tourId field to store notes

            vehicleScheduleRepository.save(schedule);

            model.addAttribute("success", "Availability added successfully for " + scheduleDate);

        } catch (Exception e) {
            model.addAttribute("error", "Error adding schedule: " + e.getMessage());
        }

        return "redirect:/vehicles/admin/schedule";
    }

    @PostMapping("/schedules/delete/{scheduleId}")
    public String deleteSchedule(@PathVariable Long scheduleId, HttpSession session, Model model) {
        if (session.getAttribute("driverLoggedIn") == null) {
            return "redirect:/vehicles/admin";
        }

        try {
            // Get the schedule and verify ownership
            Optional<VehicleSchedule> scheduleOpt = vehicleScheduleRepository.findById(scheduleId);
            if (scheduleOpt.isPresent()) {
                VehicleSchedule schedule = scheduleOpt.get();
                String loggedInVehicleId = (String) session.getAttribute("driverVehicleId");

                if (!schedule.getVehicleId().equals(loggedInVehicleId)) {
                    model.addAttribute("error", "Unauthorized access");
                    return "redirect:/vehicles/admin/schedule";
                }

                // Only allow deletion of available schedules
                if ("available".equals(schedule.getStatus())) {
                    vehicleScheduleRepository.deleteById(scheduleId);
                    model.addAttribute("success", "Schedule removed successfully");
                } else {
                    model.addAttribute("error", "Cannot remove booked schedule");
                }
            } else {
                model.addAttribute("error", "Schedule not found");
            }

        } catch (Exception e) {
            model.addAttribute("error", "Error removing schedule: " + e.getMessage());
        }

        return "redirect:/vehicles/admin/schedule";
    }

    @GetMapping("/schedules/confirm/{scheduleId}")
    public String confirmBooking(@PathVariable Long scheduleId, HttpSession session, Model model) {
        if (session.getAttribute("driverLoggedIn") == null) {
            return "redirect:/vehicles/admin";
        }

        try {
            // Get the schedule and verify ownership
            Optional<VehicleSchedule> scheduleOpt = vehicleScheduleRepository.findById(scheduleId);
            if (scheduleOpt.isPresent()) {
                VehicleSchedule schedule = scheduleOpt.get();
                String loggedInVehicleId = (String) session.getAttribute("driverVehicleId");

                if (!schedule.getVehicleId().equals(loggedInVehicleId)) {
                    model.addAttribute("error", "Unauthorized access");
                    return "redirect:/vehicles/admin/schedule";
                }

                if ("booked".equals(schedule.getStatus())) {
                    schedule.setStatus("confirmed");
                    vehicleScheduleRepository.save(schedule);
                    model.addAttribute("success", "Booking confirmed successfully");
                } else {
                    model.addAttribute("error", "Only booked schedules can be confirmed");
                }
            } else {
                model.addAttribute("error", "Schedule not found");
            }

        } catch (Exception e) {
            model.addAttribute("error", "Error confirming booking: " + e.getMessage());
        }

        return "redirect:/vehicles/admin/schedule";
    }

    @GetMapping("/schedules/reject/{scheduleId}")
    public String rejectBooking(@PathVariable Long scheduleId, HttpSession session, Model model) {
        if (session.getAttribute("driverLoggedIn") == null) {
            return "redirect:/vehicles/admin";
        }

        try {
            // Get the schedule and verify ownership
            Optional<VehicleSchedule> scheduleOpt = vehicleScheduleRepository.findById(scheduleId);
            if (scheduleOpt.isPresent()) {
                VehicleSchedule schedule = scheduleOpt.get();
                String loggedInVehicleId = (String) session.getAttribute("driverVehicleId");

                if (!schedule.getVehicleId().equals(loggedInVehicleId)) {
                    model.addAttribute("error", "Unauthorized access");
                    return "redirect:/vehicles/admin/schedule";
                }

                if ("booked".equals(schedule.getStatus())) {
                    // Reject booking by making it available again
                    schedule.setStatus("available");
                    schedule.setBookingId(null);
                    schedule.setTourId(null);
                    vehicleScheduleRepository.save(schedule);
                    model.addAttribute("success", "Booking rejected successfully");
                } else {
                    model.addAttribute("error", "Only booked schedules can be rejected");
                }
            } else {
                model.addAttribute("error", "Schedule not found");
            }

        } catch (Exception e) {
            model.addAttribute("error", "Error rejecting booking: " + e.getMessage());
        }

        return "redirect:/vehicles/admin/schedule";
    }
}