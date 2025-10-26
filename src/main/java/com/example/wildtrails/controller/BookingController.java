package com.example.wildtrails.controller;

import com.example.wildtrails.module.*;
import com.example.wildtrails.repository.*;
import com.example.wildtrails.service.BookingService;
import com.example.wildtrails.service.TourService;
import com.example.wildtrails.service.InsuranceService;
import com.example.wildtrails.service.ReportService;
import com.example.wildtrails.service.DiscountService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.ArrayList;

@Controller
@RequestMapping("/bookings")
public class BookingController {

    @Autowired
    private BookingService bookingService;

    @Autowired
    private TourService tourService;

    @Autowired
    private InsuranceService insuranceService;

    @Autowired
    private GuideRepository guideRepository;

    @Autowired
    private TourRepository tourRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private VehicleRepository vehicleRepository;

    @Autowired
    private ReportService reportService;

    @Autowired
    private GuideScheduleRepository guideScheduleRepository;

    @Autowired
    private DiscountService discountService;

    // Show booking form with all available options
    @GetMapping("/new")
    public String showBookingForm(@RequestParam String tourId, HttpSession session, Model model) {
        // Check if user is logged in
        if (session.getAttribute("userLoggedIn") == null) {
            return "redirect:/userlogin/login";
        }

        Optional<Tour> tourOptional = tourService.getTourById(tourId);
        if (tourOptional.isEmpty()) {
            return "redirect:/tours";
        }

        Tour tour = tourOptional.get();
        model.addAttribute("tour", tour);

        // Get all active insurance plans
        List<Insurance> insurancePlans = insuranceService.getAllActiveInsurance();
        model.addAttribute("insurancePlans", insurancePlans);

        // Get all active vehicles and guides to preload in the form
        List<Vehicle> vehicles = bookingService.getAllActiveVehicles();
        List<Guide> guides = bookingService.getAllActiveGuides();

        model.addAttribute("vehicles", vehicles);
        model.addAttribute("guides", guides);

        return "bookings/booking";
    }

    @PostMapping("/create")
    public String createBooking(
            @RequestParam String tourId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate tripDate,
            @RequestParam Integer durationDays,
            @RequestParam Integer numberOfPersons,
            @RequestParam Integer numberOfAdults, // NEW: Number of adults
            @RequestParam Integer numberOfChildren, // NEW: Number of children
            @RequestParam Integer numberOfStudents, // NEW: Number of students
            @RequestParam(required = false) String selectedVehicles,
            @RequestParam(required = false) String selectedGuideId,
            @RequestParam(required = false) String insurancePlanId,
            @RequestParam(required = false) String specialRequirements,
            @RequestParam Double totalAmount,
            HttpSession session,
            Model model) {

        // Check if user is logged in
        if (session.getAttribute("userLoggedIn") == null) {
            return "redirect:/userlogin/login";
        }

        try {
            Long userId = (Long) session.getAttribute("userId");
            Optional<Tour> tourOptional = tourService.getTourById(tourId);

            if (tourOptional.isEmpty()) {
                model.addAttribute("error", "Tour not found");
                return "redirect:/tours";
            }

            Tour tour = tourOptional.get();

            // DEBUG LOGGING - Check what parameters are received
            System.out.println("=== BOOKING CONTROLLER - RECEIVED PARAMETERS ===");
            System.out.println("Tour ID: " + tourId);
            System.out.println("Trip Date: " + tripDate);
            System.out.println("Duration Days: " + durationDays);
            System.out.println("Number of Persons: " + numberOfPersons);
            System.out.println("Number of Adults: " + numberOfAdults);
            System.out.println("Number of Children: " + numberOfChildren);
            System.out.println("Number of Students: " + numberOfStudents);
            System.out.println("Selected Vehicles: " + selectedVehicles);
            System.out.println("Selected Guide ID: " + selectedGuideId);
            System.out.println("Insurance Plan ID: " + insurancePlanId);
            System.out.println("Special Requirements: " + specialRequirements);
            System.out.println("Total Amount: " + totalAmount);
            System.out.println("User ID: " + userId);

            // Validate person counts
            if (numberOfAdults + numberOfChildren + numberOfStudents != numberOfPersons) {
                model.addAttribute("error", "Total persons count doesn't match the sum of adults, children, and students");

                // Reload the form with existing data
                model.addAttribute("tour", tour);
                model.addAttribute("insurancePlans", insuranceService.getAllActiveInsurance());
                model.addAttribute("vehicles", bookingService.getAllActiveVehicles());
                model.addAttribute("guides", bookingService.getAllActiveGuides());

                // Keep form values for re-population
                model.addAttribute("tripDate", tripDate);
                model.addAttribute("durationDays", durationDays);
                model.addAttribute("numberOfPersons", numberOfPersons);
                model.addAttribute("numberOfAdults", numberOfAdults);
                model.addAttribute("numberOfChildren", numberOfChildren);
                model.addAttribute("numberOfStudents", numberOfStudents);
                model.addAttribute("selectedVehicles", selectedVehicles);
                model.addAttribute("selectedGuideId", selectedGuideId);
                model.addAttribute("insurancePlanId", insurancePlanId);
                model.addAttribute("specialRequirements", specialRequirements);
                model.addAttribute("totalAmount", totalAmount);

                return "bookings/booking";
            }

            // Create booking
            Booking booking = new Booking();
            booking.setUserId(userId);
            booking.setTourId(tourId);
            booking.setTripDate(tripDate);
            booking.setDurationDays(durationDays);
            booking.setNumberOfPersons(numberOfPersons);
            booking.setNumberOfAdults(numberOfAdults); // NEW: Store number of adults
            booking.setNumberOfChildren(numberOfChildren); // NEW: Store number of children
            booking.setNumberOfStudents(numberOfStudents); // NEW: Store number of students

            // FIXED: Clean and set selected vehicles (remove duplicates)
            if (selectedVehicles != null && !selectedVehicles.trim().isEmpty()) {
                String cleanVehicles = Arrays.stream(selectedVehicles.split(","))
                        .map(String::trim)
                        .filter(v -> !v.isEmpty())
                        .distinct()
                        .reduce((v1, v2) -> v1 + "," + v2)
                        .orElse(null);
                booking.setSelectedVehicles(cleanVehicles);
                System.out.println("Cleaned vehicles: " + cleanVehicles);
            } else {
                booking.setSelectedVehicles(null);
                System.out.println("No vehicles selected");
            }

            // FIXED: Clean and set selected guide - IMPROVED LOGIC
            if (selectedGuideId != null && !selectedGuideId.trim().isEmpty() && !selectedGuideId.equals("null")) {
                String cleanGuideId = selectedGuideId.trim();
                booking.setSelectedGuideId(cleanGuideId);
                System.out.println("Cleaned guide ID: " + cleanGuideId);

                // Verify guide exists
                Optional<Guide> guideCheck = guideRepository.findByGuideId(cleanGuideId);
                if (guideCheck.isPresent()) {
                    System.out.println("Guide exists: " + guideCheck.get().getName());
                } else {
                    System.out.println("WARNING: Guide ID " + cleanGuideId + " not found in database!");
                }
            } else {
                booking.setSelectedGuideId(null);
                System.out.println("No guide selected or guide ID is null/empty");
            }

            // FIXED: Clean and set insurance plan (remove duplicates)
            if (insurancePlanId != null && !insurancePlanId.trim().isEmpty() && !insurancePlanId.equals("null")) {
                String cleanInsurancePlanId = Arrays.stream(insurancePlanId.split(","))
                        .map(String::trim)
                        .filter(id -> !id.isEmpty())
                        .distinct()
                        .findFirst()
                        .orElse(null);
                booking.setInsurancePlan(cleanInsurancePlanId);
                System.out.println("Cleaned insurance: " + cleanInsurancePlanId);
            } else {
                booking.setInsurancePlan(null);
                System.out.println("No insurance selected");
            }

            booking.setSpecialRequirements(specialRequirements);
            booking.setTotalAmount(totalAmount);

            // Convert comma-separated vehicles to list for service method
            List<String> vehicleList = null;
            if (selectedVehicles != null && !selectedVehicles.trim().isEmpty()) {
                vehicleList = Arrays.stream(selectedVehicles.split(","))
                        .map(String::trim)
                        .filter(v -> !v.isEmpty())
                        .distinct()
                        .toList();
                System.out.println("Vehicle list for service: " + vehicleList);
            }

            // FIXED: Use the cleaned guide ID directly
            String cleanSelectedGuideForService = booking.getSelectedGuideId();
            System.out.println("Guide for service: " + cleanSelectedGuideForService);

            // FIXED: Clean insurancePlanId for service method
            String cleanInsurancePlanIdForService = booking.getInsurancePlan();
            System.out.println("Insurance for service: " + cleanInsurancePlanIdForService);

            // DEBUG: Check booking object before saving
            System.out.println("=== BOOKING OBJECT BEFORE SERVICE CALL ===");
            System.out.println("Booking Guide ID: " + booking.getSelectedGuideId());
            System.out.println("Booking Vehicles: " + booking.getSelectedVehicles());
            System.out.println("Booking Insurance: " + booking.getInsurancePlan());
            System.out.println("Booking Adults: " + booking.getNumberOfAdults());
            System.out.println("Booking Children: " + booking.getNumberOfChildren());
            System.out.println("Booking Students: " + booking.getNumberOfStudents());

            // Pass cleaned data to service method
            Booking savedBooking = bookingService.createBooking(booking, vehicleList, cleanSelectedGuideForService, cleanInsurancePlanIdForService);

            // DEBUG: Check saved booking
            System.out.println("=== SAVED BOOKING ===");
            System.out.println("Saved Booking ID: " + savedBooking.getBookingId());
            System.out.println("Saved Guide ID: " + savedBooking.getSelectedGuideId());
            System.out.println("Saved Vehicles: " + savedBooking.getSelectedVehicles());
            System.out.println("Saved Adults: " + savedBooking.getNumberOfAdults());
            System.out.println("Saved Children: " + savedBooking.getNumberOfChildren());
            System.out.println("Saved Students: " + savedBooking.getNumberOfStudents());

            // Redirect to payment page instead of directly to booking details
            return "redirect:/bookings/payment?bookingId=" + savedBooking.getBookingId();

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Error creating booking: " + e.getMessage());

            // Reload the form with existing data
            Optional<Tour> tourOptional = tourService.getTourById(tourId);
            if (tourOptional.isPresent()) {
                model.addAttribute("tour", tourOptional.get());
                model.addAttribute("insurancePlans", insuranceService.getAllActiveInsurance());
                model.addAttribute("vehicles", bookingService.getAllActiveVehicles());
                model.addAttribute("guides", bookingService.getAllActiveGuides());

                // Keep form values for re-population
                model.addAttribute("tripDate", tripDate);
                model.addAttribute("durationDays", durationDays);
                model.addAttribute("numberOfPersons", numberOfPersons);
                model.addAttribute("numberOfAdults", numberOfAdults);
                model.addAttribute("numberOfChildren", numberOfChildren);
                model.addAttribute("numberOfStudents", numberOfStudents);
                model.addAttribute("selectedVehicles", selectedVehicles);
                model.addAttribute("selectedGuideId", selectedGuideId);
                model.addAttribute("insurancePlanId", insurancePlanId);
                model.addAttribute("specialRequirements", specialRequirements);
                model.addAttribute("totalAmount", totalAmount);
            }
            return "bookings/booking";
        }
    }

    // Show payment page
    @GetMapping("/payment")
    public String showPaymentPage(@RequestParam String bookingId, HttpSession session, Model model) {
        // Check if user is logged in
        if (session.getAttribute("userLoggedIn") == null) {
            return "redirect:/userlogin/login";
        }

        Optional<Booking> bookingOptional = bookingService.getBookingById(bookingId);
        if (bookingOptional.isEmpty()) {
            return "redirect:/bookings/mybookings";
        }

        Booking booking = bookingOptional.get();
        Long userId = (Long) session.getAttribute("userId");

        // Ensure user can only view their own bookings
        if (!booking.getUserId().equals(userId)) {
            return "redirect:/bookings/mybookings";
        }

        // Load tour details
        Optional<Tour> tourOptional = tourRepository.findByTourId(booking.getTourId());
        if (tourOptional.isPresent()) {
            Tour tour = tourOptional.get();
            model.addAttribute("tour", tour);
            model.addAttribute("booking", booking);

            // Calculate costs for display
            double vehicleCost = 0.0;
            double guideCost = 0.0;
            double insuranceCost = 0.0;

            // You can add proper calculation logic here based on your business rules
            model.addAttribute("vehicleCost", vehicleCost);
            model.addAttribute("guideCost", guideCost);
            model.addAttribute("insuranceCost", insuranceCost);
        }

        return "bookings/payment";
    }

    // Process payment (simulated)
    @PostMapping("/process-payment")
    public String processPayment(@RequestParam String bookingId,
                                 @RequestParam String paymentMethod,
                                 @RequestParam(required = false) String cardNumber,
                                 @RequestParam(required = false) String cardHolder,
                                 HttpSession session,
                                 Model model) {

        // Check if user is logged in
        if (session.getAttribute("userLoggedIn") == null) {
            return "redirect:/userlogin/login";
        }

        Optional<Booking> bookingOptional = bookingService.getBookingById(bookingId);
        if (bookingOptional.isEmpty()) {
            model.addAttribute("error", "Booking not found");
            return "redirect:/bookings/mybookings";
        }

        Booking booking = bookingOptional.get();
        Long userId = (Long) session.getAttribute("userId");

        // Ensure user can only process payment for their own bookings
        if (!booking.getUserId().equals(userId)) {
            return "redirect:/bookings/mybookings";
        }

        // Simulate payment processing - in real application, integrate with payment gateway
        System.out.println("=== PAYMENT PROCESSING ===");
        System.out.println("Booking ID: " + bookingId);
        System.out.println("Payment Method: " + paymentMethod);
        System.out.println("Amount: " + booking.getTotalAmount());

        if ("card".equals(paymentMethod)) {
            System.out.println("Card Payment - Last 4 digits: " +
                    (cardNumber != null && cardNumber.length() >= 4 ?
                            cardNumber.substring(cardNumber.length() - 4) : "N/A"));
        } else {
            System.out.println("Cash on Delivery selected");
        }

        System.out.println("Payment processed successfully (simulated)");

        // Redirect to booking details with success message
        return "redirect:/bookings/" + bookingId + "?success=Payment+processed+successfully";
    }

    @GetMapping("/{bookingId}")
    public String showBookingDetails(@PathVariable String bookingId,
                                     @RequestParam(required = false) String success,
                                     HttpSession session,
                                     Model model) {

        // Check if user is logged in
        if (session.getAttribute("userLoggedIn") == null) {
            return "redirect:/userlogin/login";
        }

        Optional<Booking> bookingOptional = bookingService.getBookingById(bookingId);
        if (bookingOptional.isEmpty()) {
            return "redirect:/bookings/mybookings";
        }

        Booking booking = bookingOptional.get();
        Long userId = (Long) session.getAttribute("userId");

        // Ensure user can only view their own bookings
        if (!booking.getUserId().equals(userId)) {
            return "redirect:/bookings/mybookings";
        }

        // Add success message if present
        if (success != null && !success.isEmpty()) {
            model.addAttribute("success", "Booking confirmed successfully! Your booking ID: " + booking.getBookingId());
        }

        // Load tour details
        Optional<Tour> tourOptional = tourRepository.findByTourId(booking.getTourId());
        tourOptional.ifPresent(tour -> booking.setTour(tour));

        // Load user details
        Optional<User> userOptional = userRepository.findById(booking.getUserId());
        userOptional.ifPresent(user -> booking.setUser(user));

        // Load guide details if guide was selected
        if (booking.getSelectedGuideId() != null && !booking.getSelectedGuideId().isEmpty()) {
            Optional<Guide> guideOptional = guideRepository.findByGuideId(booking.getSelectedGuideId());
            guideOptional.ifPresent(guide -> {
                booking.setGuide(guide);
                model.addAttribute("guide", guide);
            });
        }

        // Load vehicle details if vehicles were selected - FIXED
        if (booking.getSelectedVehicles() != null && !booking.getSelectedVehicles().isEmpty()) {
            List<Vehicle> vehicles = new ArrayList<>();
            String[] vehicleIds = booking.getSelectedVehicles().split(",");

            for (String vehicleId : vehicleIds) {
                Optional<Vehicle> vehicleOptional = vehicleRepository.findByVehicleId(vehicleId.trim());
                if (vehicleOptional.isPresent()) {
                    vehicles.add(vehicleOptional.get());
                    System.out.println("Loaded vehicle: " + vehicleId);
                } else {
                    System.out.println("Vehicle not found: " + vehicleId);
                }
            }

            model.addAttribute("vehicles", vehicles);
            System.out.println("Loaded " + vehicles.size() + " vehicles for booking: " + bookingId);
        } else {
            System.out.println("No vehicles selected for booking: " + bookingId);
        }

        // Load insurance booking details
        if (booking.getInsurancePlan() != null && !booking.getInsurancePlan().isEmpty()) {
            InsuranceBooking insuranceBooking = bookingService.getInsuranceBookingByBookingId(bookingId);
            model.addAttribute("insuranceBooking", insuranceBooking);
        }

        model.addAttribute("booking", booking);

        return "bookings/booking-details";
    }

    @GetMapping("/mybookings")
    public String showMyBookings(HttpSession session, Model model) {
        // Check if user is logged in
        if (session.getAttribute("userLoggedIn") == null) {
            return "redirect:/userlogin/login";
        }

        Long userId = (Long) session.getAttribute("userId");
        List<Booking> bookings = bookingService.getUserBookings(userId);

        // Load additional details for each booking
        for (Booking booking : bookings) {
            // Load tour details
            Optional<Tour> tourOptional = tourRepository.findByTourId(booking.getTourId());
            tourOptional.ifPresent(booking::setTour);

            // Load guide details if available
            if (booking.getSelectedGuideId() != null && !booking.getSelectedGuideId().isEmpty()) {
                Optional<Guide> guideOptional = guideRepository.findByGuideId(booking.getSelectedGuideId());
                guideOptional.ifPresent(booking::setGuide);
            }

            // Load vehicle details if available
            if (booking.getSelectedVehicles() != null && !booking.getSelectedVehicles().isEmpty()) {
                List<Vehicle> vehicles = new ArrayList<>();
                String[] vehicleIds = booking.getSelectedVehicles().split(",");

                for (String vehicleId : vehicleIds) {
                    Optional<Vehicle> vehicleOptional = vehicleRepository.findByVehicleId(vehicleId.trim());
                    vehicleOptional.ifPresent(vehicles::add);
                }

                model.addAttribute("vehicles_" + booking.getBookingId(), vehicles);
            }

            // Load insurance details if available
            if (booking.getInsurancePlan() != null && !booking.getInsurancePlan().isEmpty()) {
                InsuranceBooking insuranceBooking = bookingService.getInsuranceBookingByBookingId(booking.getBookingId());
                model.addAttribute("insuranceBooking_" + booking.getBookingId(), insuranceBooking);
            }
        }

        model.addAttribute("bookings", bookings);

        return "bookings/mybookings";
    }

    @PostMapping("/{bookingId}/cancel")
    @ResponseBody
    public ResponseEntity<?> cancelBooking(@PathVariable String bookingId, HttpSession session) {
        // Check if user is logged in
        if (session.getAttribute("userLoggedIn") == null) {
            return ResponseEntity.status(401).body("Unauthorized");
        }

        Optional<Booking> bookingOptional = bookingService.getBookingById(bookingId);
        if (bookingOptional.isEmpty()) {
            return ResponseEntity.status(404).body("Booking not found");
        }

        Booking booking = bookingOptional.get();
        Long userId = (Long) session.getAttribute("userId");

        // Ensure user can only cancel their own bookings
        if (!booking.getUserId().equals(userId)) {
            return ResponseEntity.status(403).body("Forbidden");
        }

        boolean cancelled = bookingService.cancelBooking(bookingId);
        if (cancelled) {
            return ResponseEntity.ok().body("Booking cancelled successfully");
        } else {
            return ResponseEntity.status(500).body("Failed to cancel booking");
        }
    }

    // NEW: DELETE BOOKING ENDPOINT
    @DeleteMapping("/{bookingId}/delete")
    @ResponseBody
    public ResponseEntity<?> deleteBooking(@PathVariable String bookingId, HttpSession session) {
        // Check if user is logged in
        if (session.getAttribute("userLoggedIn") == null) {
            return ResponseEntity.status(401).body("Unauthorized");
        }

        Optional<Booking> bookingOptional = bookingService.getBookingById(bookingId);
        if (bookingOptional.isEmpty()) {
            return ResponseEntity.status(404).body("Booking not found");
        }

        Booking booking = bookingOptional.get();
        Long userId = (Long) session.getAttribute("userId");

        // Ensure user can only delete their own bookings
        if (!booking.getUserId().equals(userId)) {
            return ResponseEntity.status(403).body("Forbidden");
        }

        try {
            boolean deleted = bookingService.deleteBooking(bookingId);
            if (deleted) {
                return ResponseEntity.ok().body("Booking deleted successfully");
            } else {
                return ResponseEntity.status(500).body("Failed to delete booking");
            }
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Error deleting booking: " + e.getMessage());
        }
    }

    // Report request endpoint
    @PostMapping("/{bookingId}/request-report")
    @ResponseBody
    public ResponseEntity<?> requestBookingReport(@PathVariable String bookingId, HttpSession session) {
        // Check if user is logged in
        if (session.getAttribute("userLoggedIn") == null) {
            return ResponseEntity.status(401).body("Unauthorized");
        }

        Optional<Booking> bookingOptional = bookingService.getBookingById(bookingId);
        if (bookingOptional.isEmpty()) {
            return ResponseEntity.status(404).body("Booking not found");
        }

        Booking booking = bookingOptional.get();
        Long userId = (Long) session.getAttribute("userId");

        // Ensure user can only request reports for their own bookings
        if (!booking.getUserId().equals(userId)) {
            return ResponseEntity.status(403).body("Forbidden");
        }

        try {
            // Use the booking's internal ID (Long) for the report
            SMSReport report = reportService.requestReport(booking.getId(), userId, "FULL_FINANCIAL");
            return ResponseEntity.ok().body("Report requested successfully! Reference: " + report.getReportId());
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Error requesting report: " + e.getMessage());
        }
    }

    // AJAX endpoints for date-specific availability
    @GetMapping("/available-vehicles")
    @ResponseBody
    public List<Vehicle> getAvailableVehicles(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate tripDate,
            @RequestParam Integer duration,
            @RequestParam Integer persons) {
        return bookingService.getAvailableVehicles(tripDate, duration, persons);
    }

    @GetMapping("/available-guides")
    @ResponseBody
    public List<Guide> getAvailableGuides(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate tripDate,
            @RequestParam Integer duration) {
        return bookingService.getAvailableGuides(tripDate, duration);
    }

    // AJAX endpoint to get ALL vehicles (without date filtering)
    @GetMapping("/all-vehicles")
    @ResponseBody
    public List<Vehicle> getAllVehicles() {
        System.out.println("=== GETTING ALL VEHICLES ===");
        List<Vehicle> vehicles = bookingService.getAllActiveVehicles();
        System.out.println("Returning " + vehicles.size() + " vehicles");
        return vehicles;
    }

    // AJAX endpoint to get ALL guides (without date filtering)
    @GetMapping("/all-guides")
    @ResponseBody
    public List<Guide> getAllGuides() {
        System.out.println("=== GETTING ALL GUIDES ===");
        List<Guide> guides = bookingService.getAllActiveGuides();
        System.out.println("Returning " + guides.size() + " guides");
        return guides;
    }

    // Debug endpoint to check vehicle data
    @GetMapping("/debug/vehicles")
    @ResponseBody
    public String debugVehicles() {
        bookingService.checkVehicleData();
        return "Check console for vehicle data";
    }

    // Debug endpoint to check guide data
    @GetMapping("/debug/guides")
    @ResponseBody
    public String debugGuides() {
        bookingService.checkGuideData();
        return "Check console for guide data";
    }

    // Debug endpoint to test guide scheduling directly
    @PostMapping("/test-guide-scheduling")
    @ResponseBody
    public String testGuideScheduling(@RequestParam String guideId,
                                      @RequestParam String bookingId,
                                      @RequestParam LocalDate tripDate,
                                      @RequestParam Integer durationDays) {
        try {
            System.out.println("=== TEST GUIDE SCHEDULING ===");
            System.out.println("Guide ID: " + guideId);
            System.out.println("Booking ID: " + bookingId);
            System.out.println("Trip Date: " + tripDate);
            System.out.println("Duration Days: " + durationDays);

            // Test if guide exists
            Optional<Guide> guide = guideRepository.findByGuideId(guideId);
            if (guide.isPresent()) {
                System.out.println("Guide found: " + guide.get().getName());

                // Test scheduling
                LocalDate endDate = tripDate.plusDays(durationDays - 1);
                LocalDate currentDate = tripDate;

                while (!currentDate.isAfter(endDate)) {
                    GuideSchedule schedule = new GuideSchedule();
                    schedule.setGuideId(guideId);
                    schedule.setScheduleDate(currentDate);
                    schedule.setStatus("booked");
                    schedule.setBookingId(bookingId);

                    GuideSchedule saved = guideScheduleRepository.save(schedule);
                    System.out.println("Schedule saved for " + currentDate + " with ID: " + saved.getId());

                    currentDate = currentDate.plusDays(1);
                }

                return "Guide scheduling test completed successfully!";
            } else {
                return "Guide not found with ID: " + guideId;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        }
    }
}
