package com.example.wildtrails.service;

import com.example.wildtrails.module.*;
import com.example.wildtrails.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class BookingService {

    @Autowired
    private BookingRepository bookingRepository;

    @Autowired
    private VehicleRepository vehicleRepository;

    @Autowired
    private GuideRepository guideRepository;

    @Autowired
    private TourRepository tourRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private VehicleScheduleRepository vehicleScheduleRepository;

    @Autowired
    private GuideScheduleRepository guideScheduleRepository;

    @Autowired
    private InsuranceRepository insuranceRepository;

    @Autowired
    private SMSLogRepository smsLogRepository;

    @Autowired
    private SMSService smsService;

    @Autowired
    private VehicleScheduleService vehicleScheduleService;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Transactional
    public Booking createBooking(Booking booking, List<String> selectedVehicleIds, String selectedGuideId, String insurancePlanId) {
        try {
            // Generate booking ID
            String bookingId = generateBookingId();
            booking.setBookingId(bookingId);
            booking.setStatus("confirmed");
            booking.setCreatedAt(LocalDateTime.now());
            booking.setUpdatedAt(LocalDateTime.now());

            // Save selected vehicles and guide to booking - FIXED: Remove duplicates
            if (selectedVehicleIds != null && !selectedVehicleIds.isEmpty()) {
                // Remove duplicates from selected vehicles
                List<String> uniqueVehicleIds = selectedVehicleIds.stream()
                        .distinct()
                        .toList();
                booking.setSelectedVehicles(String.join(",", uniqueVehicleIds));
            }

            // FIXED: Set selected guide directly - Make sure this is not null
            if (selectedGuideId != null && !selectedGuideId.isEmpty() && !selectedGuideId.equals("null")) {
                booking.setSelectedGuideId(selectedGuideId);
                System.out.println("=== GUIDE ID SET IN BOOKING ===");
                System.out.println("Selected Guide ID: " + selectedGuideId);
            } else {
                booking.setSelectedGuideId(null);
                System.out.println("=== NO GUIDE SELECTED ===");
            }

            // FIXED: Set insurance plan only once
            if (insurancePlanId != null && !insurancePlanId.isEmpty() && !insurancePlanId.equals("null")) {
                booking.setInsurancePlan(insurancePlanId);
            } else {
                booking.setInsurancePlan(null);
            }

            // Save booking first to get the ID
            Booking savedBooking = bookingRepository.save(booking);
            System.out.println("=== BOOKING SAVED ===");
            System.out.println("Booking ID: " + savedBooking.getBookingId());
            System.out.println("Selected vehicles: " + savedBooking.getSelectedVehicles());
            System.out.println("Selected guide: " + savedBooking.getSelectedGuideId());
            System.out.println("Insurance plan: " + savedBooking.getInsurancePlan());
            System.out.println("Tour ID: " + savedBooking.getTourId());

            // Save insurance booking details if insurance was selected
            if (insurancePlanId != null && !insurancePlanId.isEmpty() && !insurancePlanId.equals("null")) {
                saveInsuranceBooking(savedBooking, insurancePlanId);
            }

            // Update vehicle schedules using the service - FIXED: Pass tourId
            if (selectedVehicleIds != null && !selectedVehicleIds.isEmpty()) {
                LocalDate endDate = savedBooking.getTripDate().plusDays(savedBooking.getDurationDays() - 1);
                for (String vehicleId : selectedVehicleIds) {
                    try {
                        // FIXED: Pass tourId to vehicle schedule
                        boolean scheduled = vehicleScheduleService.bookVehicle(
                                vehicleId,
                                savedBooking.getTripDate(),
                                endDate,
                                savedBooking.getBookingId(),
                                savedBooking.getTourId() // Pass tourId
                        );
                        System.out.println("Vehicle " + vehicleId + " scheduled: " + scheduled);
                    } catch (Exception e) {
                        System.err.println("Error scheduling vehicle " + vehicleId + ": " + e.getMessage());
                        // Continue with other vehicles even if one fails
                    }
                }
            }

            // FIXED: Update guide schedule - Completely rewritten to handle guide scheduling properly
            if (selectedGuideId != null && !selectedGuideId.isEmpty() && !selectedGuideId.equals("null")) {
                System.out.println("=== SCHEDULING GUIDE ===");
                System.out.println("Guide ID: " + selectedGuideId);
                System.out.println("Booking ID: " + savedBooking.getBookingId());
                System.out.println("Trip Date: " + savedBooking.getTripDate());
                System.out.println("Duration Days: " + savedBooking.getDurationDays());

                LocalDate endDate = savedBooking.getTripDate().plusDays(savedBooking.getDurationDays() - 1);
                LocalDate currentDate = savedBooking.getTripDate();

                int schedulesCreated = 0;
                while (!currentDate.isAfter(endDate)) {
                    try {
                        // Check if schedule already exists for this guide and date
                        List<GuideSchedule> existingSchedules = guideScheduleRepository.findByGuideIdAndScheduleDate(selectedGuideId, currentDate);

                        GuideSchedule scheduleToSave;

                        if (!existingSchedules.isEmpty()) {
                            // Update existing schedule
                            scheduleToSave = existingSchedules.get(0);
                            System.out.println("Updating existing guide schedule for " + selectedGuideId + " on " + currentDate);
                        } else {
                            // Create new schedule
                            scheduleToSave = new GuideSchedule();
                            scheduleToSave.setGuideId(selectedGuideId);
                            scheduleToSave.setScheduleDate(currentDate);
                            scheduleToSave.setCreatedAt(LocalDateTime.now());
                            System.out.println("Creating new guide schedule for " + selectedGuideId + " on " + currentDate);
                        }

                        // Set booking details
                        scheduleToSave.setStatus("booked");
                        scheduleToSave.setBookingId(savedBooking.getBookingId());
                        scheduleToSave.setUpdatedAt(LocalDateTime.now());

                        // Save the schedule
                        GuideSchedule savedSchedule = guideScheduleRepository.save(scheduleToSave);
                        schedulesCreated++;
                        System.out.println("Guide schedule saved: " + savedSchedule.getId() + " for date: " + currentDate);

                    } catch (Exception e) {
                        System.err.println("Error creating guide schedule for " + selectedGuideId + " on " + currentDate + ": " + e.getMessage());
                        e.printStackTrace();
                        // Don't fail the entire booking if one day fails
                    }

                    currentDate = currentDate.plusDays(1);
                }
                System.out.println("Guide scheduling completed for: " + selectedGuideId + ". Created " + schedulesCreated + " schedules.");
            } else {
                System.out.println("=== NO GUIDE TO SCHEDULE ===");
            }

            // Send SMS notifications
            sendBookingConfirmationSMS(savedBooking);

            return savedBooking;

        } catch (Exception e) {
            System.err.println("Error creating booking: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error creating booking: " + e.getMessage(), e);
        }
    }

// In your BookingService.java, update the deleteBooking method:

    @Transactional
    public boolean deleteBooking(String bookingId) {
        try {
            System.out.println("=== DELETING BOOKING ===");
            System.out.println("Booking ID: " + bookingId);

            Optional<Booking> bookingOptional = bookingRepository.findByBookingId(bookingId);
            if (!bookingOptional.isPresent()) {
                System.err.println("Booking not found: " + bookingId);
                return false;
            }

            Booking booking = bookingOptional.get();
            System.out.println("Found booking with internal ID: " + booking.getId());

            // 1. Delete insurance booking records
            deleteInsuranceBooking(bookingId);
            System.out.println("Deleted insurance booking records");

            // 2. Delete guide schedules - FIXED: Now returns int
            int guideSchedulesDeleted = guideScheduleRepository.deleteByBookingId(bookingId);
            System.out.println("Deleted " + guideSchedulesDeleted + " guide schedules");

            // 3. Delete vehicle schedules - FIXED: Now returns int
            int vehicleSchedulesDeleted = vehicleScheduleRepository.deleteByBookingId(bookingId);
            System.out.println("Deleted " + vehicleSchedulesDeleted + " vehicle schedules");

            // 4. Delete SMS logs - FIXED: Now returns int
            int smsLogsDeleted = smsLogRepository.deleteByBookingId(bookingId);
            System.out.println("Deleted " + smsLogsDeleted + " SMS logs");

            // 5. Finally delete the booking itself
            bookingRepository.delete(booking);
            System.out.println("Deleted booking record");

            System.out.println("=== BOOKING DELETION COMPLETED ===");
            return true;

        } catch (Exception e) {
            System.err.println("Error deleting booking " + bookingId + ": " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error deleting booking: " + e.getMessage(), e);
        }
    }

    private void saveInsuranceBooking(Booking booking, String insurancePlanId) {
        try {
            Optional<Insurance> insuranceOptional = insuranceRepository.findByInsuranceId(insurancePlanId);
            if (insuranceOptional.isPresent()) {
                Insurance insurance = insuranceOptional.get();

                double totalInsuranceCost = insurance.getPricePerDayPerPerson() * booking.getNumberOfPersons() * booking.getDurationDays();

                // Insert directly using JdbcTemplate
                String sql = "INSERT INTO insurance_booking (booking_id, insurance_id, company_name, insurance_type, coverage_type, " +
                        "price_per_day_per_person, total_insurance_cost, number_of_persons, duration_days, created_at) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

                int rowsAffected = jdbcTemplate.update(sql,
                        booking.getBookingId(),
                        insurance.getInsuranceId(),
                        insurance.getCompanyName(),
                        insurance.getInsuranceType(),
                        insurance.getCoverageType(),
                        insurance.getPricePerDayPerPerson(),
                        totalInsuranceCost,
                        booking.getNumberOfPersons(),
                        booking.getDurationDays(),
                        LocalDateTime.now()
                );

                if (rowsAffected > 0) {
                    System.out.println("Insurance booking saved for booking: " + booking.getBookingId());
                    System.out.println("Insurance ID: " + insurance.getInsuranceId());
                    System.out.println("Total cost: " + totalInsuranceCost);
                } else {
                    System.err.println("Failed to save insurance booking for: " + booking.getBookingId());
                }
            } else {
                System.err.println("Insurance plan not found: " + insurancePlanId);
            }
        } catch (Exception e) {
            System.err.println("Error saving insurance booking: " + e.getMessage());
            e.printStackTrace();
            // Don't fail the entire booking if insurance saving fails
        }
    }

    public InsuranceBooking getInsuranceBookingByBookingId(String bookingId) {
        try {
            String sql = "SELECT * FROM insurance_booking WHERE booking_id = ?";

            return jdbcTemplate.queryForObject(sql, (rs, rowNum) -> {
                InsuranceBooking insuranceBooking = new InsuranceBooking();
                insuranceBooking.setId(rs.getLong("id"));
                insuranceBooking.setBookingId(rs.getString("booking_id"));
                insuranceBooking.setInsuranceId(rs.getString("insurance_id"));
                insuranceBooking.setCompanyName(rs.getString("company_name"));
                insuranceBooking.setInsuranceType(rs.getString("insurance_type"));
                insuranceBooking.setCoverageType(rs.getString("coverage_type"));
                insuranceBooking.setPricePerDayPerPerson(rs.getDouble("price_per_day_per_person"));
                insuranceBooking.setTotalInsuranceCost(rs.getDouble("total_insurance_cost"));
                insuranceBooking.setNumberOfPersons(rs.getInt("number_of_persons"));
                insuranceBooking.setDurationDays(rs.getInt("duration_days"));
                insuranceBooking.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                return insuranceBooking;
            }, bookingId);
        } catch (Exception e) {
            System.err.println("Error getting insurance booking: " + e.getMessage());
            return null;
        }
    }

    public void deleteInsuranceBooking(String bookingId) {
        try {
            String sql = "DELETE FROM insurance_booking WHERE booking_id = ?";
            int rowsAffected = jdbcTemplate.update(sql, bookingId);
            System.out.println("Insurance booking deleted for booking: " + bookingId + ", rows affected: " + rowsAffected);
        } catch (Exception e) {
            System.err.println("Error deleting insurance booking: " + e.getMessage());
        }
    }

    public List<Booking> getUserBookings(Long userId) {
        return bookingRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }

    public Optional<Booking> getBookingById(String bookingId) {
        return bookingRepository.findByBookingId(bookingId);
    }

    public List<Vehicle> getAvailableVehicles(LocalDate tripDate, Integer duration, Integer persons) {
        try {
            System.out.println("=== VEHICLE AVAILABILITY CHECK ===");
            System.out.println("Trip Date: " + tripDate + ", Duration: " + duration + ", Persons: " + persons);

            if (tripDate == null || duration == null || persons == null) {
                System.err.println("Invalid parameters: tripDate, duration, or persons is null");
                return new ArrayList<>();
            }

            LocalDate endDate = tripDate.plusDays(duration - 1);
            System.out.println("Calculated end date: " + endDate);

            List<Vehicle> availableVehicles = vehicleScheduleService.getAvailableVehicles(tripDate, endDate, persons);

            System.out.println("Available vehicles count: " + (availableVehicles != null ? availableVehicles.size() : "null"));
            if (availableVehicles != null) {
                for (Vehicle vehicle : availableVehicles) {
                    System.out.println("Vehicle: " + vehicle.getVehicleId() + " - " + vehicle.getVehicleName() +
                            " - Capacity: " + vehicle.getCapacity() + " - Type: " + vehicle.getVehicleType());
                }
            } else {
                System.out.println("Available vehicles list is null");
            }

            return availableVehicles != null ? availableVehicles : new ArrayList<>();
        } catch (Exception e) {
            System.err.println("Error getting available vehicles: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<Guide> getAvailableGuides(LocalDate tripDate, Integer duration) {
        try {
            System.out.println("=== GUIDE AVAILABILITY CHECK ===");
            System.out.println("Trip Date: " + tripDate + ", Duration: " + duration);

            if (tripDate == null || duration == null) {
                System.err.println("Invalid parameters: tripDate or duration is null");
                return new ArrayList<>();
            }

            List<Guide> allGuides = guideRepository.findByStatusOrderByExperienceYearsDesc("active");
            System.out.println("Total active guides: " + allGuides.size());

            List<Guide> availableGuides = new ArrayList<>();

            for (Guide guide : allGuides) {
                boolean available = isGuideAvailable(guide.getGuideId(), tripDate, duration);
                System.out.println("Guide " + guide.getGuideId() + " - " + guide.getName() + " available: " + available);
                if (available) {
                    availableGuides.add(guide);
                }
            }

            System.out.println("Final available guides count: " + availableGuides.size());
            for (Guide guide : availableGuides) {
                System.out.println("Available Guide: " + guide.getGuideId() + " - " + guide.getName());
            }

            return availableGuides;
        } catch (Exception e) {
            System.err.println("Error getting available guides: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public Optional<Insurance> getInsuranceById(String insuranceId) {
        return insuranceRepository.findByInsuranceId(insuranceId);
    }

    public List<Insurance> getAllActiveInsurance() {
        return insuranceRepository.findByStatus("active");
    }

    private boolean isGuideAvailable(String guideId, LocalDate tripDate, Integer duration) {
        try {
            for (int i = 0; i < duration; i++) {
                LocalDate checkDate = tripDate.plusDays(i);
                List<GuideSchedule> schedules = guideScheduleRepository.findByGuideIdAndScheduleDateAndStatus(
                        guideId, checkDate, "booked");
                if (!schedules.isEmpty()) {
                    System.out.println("Guide " + guideId + " not available on " + checkDate + " - found " + schedules.size() + " bookings");
                    return false;
                }
            }
            System.out.println("Guide " + guideId + " is available for the entire period");
            return true;
        } catch (Exception e) {
            System.err.println("Error checking guide availability: " + e.getMessage());
            return false;
        }
    }

    private String generateBookingId() {
        try {
            String maxBookingId = bookingRepository.findMaxBookingId();
            if (maxBookingId != null) {
                try {
                    int lastNumber = Integer.parseInt(maxBookingId.replace("book-", ""));
                    return "book-" + (lastNumber + 1);
                } catch (NumberFormatException e) {
                    System.err.println("Error parsing booking ID: " + maxBookingId);
                    return "book-1";
                }
            }
            return "book-1";
        } catch (Exception e) {
            System.err.println("Error generating booking ID: " + e.getMessage());
            return "book-1";
        }
    }

    private void sendBookingConfirmationSMS(Booking booking) {
        try {
            // Get user details
            Optional<User> userOptional = userRepository.findById(booking.getUserId());
            Optional<Tour> tourOptional = tourRepository.findByTourId(booking.getTourId());

            if (userOptional.isPresent() && tourOptional.isPresent()) {
                User user = userOptional.get();
                Tour tour = tourOptional.get();

                // Send SMS to user
                String userMessage = String.format(
                        "Dear %s, your booking %s for %s on %s is confirmed. Total: Rs.%.2f. Thank you for choosing WildTrails!",
                        user.getFirstName(), booking.getBookingId(), tour.getTourName(),
                        booking.getTripDate(), booking.getTotalAmount()
                );

                SMSLog userSMS = new SMSLog();
                userSMS.setBookingId(booking.getBookingId());
                userSMS.setRecipientType("user");
                userSMS.setRecipientPhone(user.getPhoneNumber());
                userSMS.setMessage(userMessage);
                smsLogRepository.save(userSMS);

                System.out.println("SMS sent to user: " + user.getPhoneNumber());

                // Send SMS to guide if selected
                if (booking.getSelectedGuideId() != null && !booking.getSelectedGuideId().isEmpty()) {
                    Optional<Guide> guideOptional = guideRepository.findByGuideId(booking.getSelectedGuideId());
                    if (guideOptional.isPresent()) {
                        Guide guide = guideOptional.get();
                        String guideMessage = String.format(
                                "You have been assigned to booking %s for %s on %s. Duration: %d days. Contact: %s",
                                booking.getBookingId(), tour.getTourName(), booking.getTripDate(),
                                booking.getDurationDays(), user.getPhoneNumber()
                        );

                        SMSLog guideSMS = new SMSLog();
                        guideSMS.setBookingId(booking.getBookingId());
                        guideSMS.setRecipientType("guide");
                        guideSMS.setRecipientPhone(guide.getPhoneNumber());
                        guideSMS.setMessage(guideMessage);
                        smsLogRepository.save(guideSMS);

                        System.out.println("SMS sent to guide: " + guide.getPhoneNumber());
                    }
                }

                // Send SMS to drivers if vehicles selected
                if (booking.getSelectedVehicles() != null && !booking.getSelectedVehicles().isEmpty()) {
                    String[] vehicleIds = booking.getSelectedVehicles().split(",");
                    for (String vehicleId : vehicleIds) {
                        Optional<Vehicle> vehicleOptional = vehicleRepository.findByVehicleId(vehicleId.trim());
                        if (vehicleOptional.isPresent()) {
                            Vehicle vehicle = vehicleOptional.get();
                            String driverMessage = String.format(
                                    "Vehicle %s assigned to booking %s for %s on %s. Duration: %d days. Contact: %s",
                                    vehicle.getVehicleName(), booking.getBookingId(), tour.getTourName(),
                                    booking.getTripDate(), booking.getDurationDays(), user.getPhoneNumber()
                            );

                            SMSLog driverSMS = new SMSLog();
                            driverSMS.setBookingId(booking.getBookingId());
                            driverSMS.setRecipientType("driver");
                            driverSMS.setRecipientPhone(vehicle.getDriverPhone());
                            driverSMS.setMessage(driverMessage);
                            smsLogRepository.save(driverSMS);

                            System.out.println("SMS sent to driver: " + vehicle.getDriverPhone());
                        }
                    }
                }
            } else {
                System.err.println("User or Tour not found for booking: " + booking.getBookingId());
            }
        } catch (Exception e) {
            // Log error but don't fail the booking
            System.err.println("Error sending SMS: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Transactional
    public boolean cancelBooking(String bookingId) {
        try {
            Optional<Booking> bookingOptional = bookingRepository.findByBookingId(bookingId);
            if (bookingOptional.isPresent()) {
                Booking booking = bookingOptional.get();
                booking.setStatus("cancelled");
                booking.setUpdatedAt(LocalDateTime.now());
                bookingRepository.save(booking);

                // Free up vehicle schedules using service
                vehicleScheduleService.releaseVehicleBooking(bookingId);

                // Free up guide schedules
                guideScheduleRepository.updateStatusByBookingId(bookingId, "available");

                // Delete insurance booking
                deleteInsuranceBooking(bookingId);

                System.out.println("Booking cancelled successfully: " + bookingId);
                return true;
            } else {
                System.err.println("Booking not found for cancellation: " + bookingId);
                return false;
            }
        } catch (Exception e) {
            System.err.println("Error cancelling booking: " + bookingId + " - " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Additional helper methods for debugging
    public void checkVehicleData() {
        try {
            List<Vehicle> allVehicles = vehicleRepository.findAll();
            System.out.println("=== ALL VEHICLES IN DATABASE ===");
            System.out.println("Total vehicles: " + allVehicles.size());
            for (Vehicle vehicle : allVehicles) {
                System.out.println("Vehicle: " + vehicle.getVehicleId() + " - " + vehicle.getVehicleName() +
                        " - Capacity: " + vehicle.getCapacity() + " - Status: " + vehicle.getStatus());
            }
        } catch (Exception e) {
            System.err.println("Error checking vehicle data: " + e.getMessage());
        }
    }

    public void checkGuideData() {
        try {
            List<Guide> allGuides = guideRepository.findAll();
            System.out.println("=== ALL GUIDES IN DATABASE ===");
            System.out.println("Total guides: " + allGuides.size());
            for (Guide guide : allGuides) {
                System.out.println("Guide: " + guide.getGuideId() + " - " + guide.getName() +
                        " - Status: " + guide.getStatus() + " - Experience: " + guide.getExperienceYears() + " years");
            }
        } catch (Exception e) {
            System.err.println("Error checking guide data: " + e.getMessage());
        }
    }

    public List<Vehicle> getAllActiveVehicles() {
        try {
            List<Vehicle> allVehicles = vehicleRepository.findByStatus("active");
            System.out.println("=== ALL ACTIVE VEHICLES ===");
            System.out.println("Total active vehicles: " + allVehicles.size());
            for (Vehicle vehicle : allVehicles) {
                System.out.println("Vehicle: " + vehicle.getVehicleId() + " - " + vehicle.getVehicleName() +
                        " - Capacity: " + vehicle.getCapacity() + " - Daily Rate: " + vehicle.getDailyRate());
            }
            return allVehicles;
        } catch (Exception e) {
            System.err.println("Error getting all active vehicles: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<Guide> getAllActiveGuides() {
        try {
            List<Guide> allGuides = guideRepository.findByStatusOrderByExperienceYearsDesc("active");
            System.out.println("=== ALL ACTIVE GUIDES ===");
            System.out.println("Total active guides: " + allGuides.size());
            for (Guide guide : allGuides) {
                System.out.println("Guide: " + guide.getGuideId() + " - " + guide.getName() +
                        " - Experience: " + guide.getExperienceYears() + " years - Daily Rate: " + guide.getDailyRate());
            }
            return allGuides;
        } catch (Exception e) {
            System.err.println("Error getting all active guides: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
}