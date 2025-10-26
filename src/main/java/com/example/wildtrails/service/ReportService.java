// File: ReportService.java
package com.example.wildtrails.service;

import com.example.wildtrails.module.*;
import com.example.wildtrails.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

@Service
public class ReportService {

    @Autowired
    private SMSReportRepository smsReportRepository;

    @Autowired
    private BookingRepository bookingRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private TourRepository tourRepository;

    @Autowired
    private GuideRepository guideRepository;

    @Autowired
    private VehicleRepository vehicleRepository;

    @Autowired
    private InsuranceRepository insuranceRepository;

    @Autowired
    private SMSService smsService;

    @Autowired
    private SMSLogRepository smsLogRepository;

    public SMSReport requestReport(Long bookingId, Long userId, String reportType) {
        // Generate report ID
        String reportId = generateReportId();

        SMSReport report = new SMSReport(reportId, bookingId, userId, reportType);
        report.setStatus("PENDING");
        report.setRequestDate(LocalDateTime.now());

        return smsReportRepository.save(report);
    }

    @Transactional
    public SMSReport generateFullReport(String reportId, Long financeOfficerId, String messageToUser) {
        Optional<SMSReport> reportOptional = smsReportRepository.findByReportId(reportId);

        if (reportOptional.isEmpty()) {
            throw new RuntimeException("Report not found: " + reportId);
        }

        SMSReport report = reportOptional.get();

        // Get booking details
        Optional<Booking> bookingOptional = bookingRepository.findById(report.getBookingId());
        if (bookingOptional.isEmpty()) {
            throw new RuntimeException("Booking not found: " + report.getBookingId());
        }

        Booking booking = bookingOptional.get();

        // Generate report content
        String reportContent = generateReportContent(booking, report);
        Double totalCost = calculateTotalCost(booking);

        // Update report
        report.setReportContent(reportContent);
        report.setTotalCost(totalCost);
        report.setFinanceOfficerId(financeOfficerId);
        report.setGeneratedDate(LocalDateTime.now());
        report.setStatus("GENERATED");
        report.setMessageToUser(messageToUser);

        SMSReport savedReport = smsReportRepository.save(report);

        // Send notification to user
        sendReportNotification(savedReport);

        return savedReport;
    }

    @Transactional
    public SMSReport updateReport(String reportId, String messageToUser, Double totalCost, String reportContent) {
        Optional<SMSReport> reportOptional = smsReportRepository.findByReportId(reportId);

        if (reportOptional.isEmpty()) {
            throw new RuntimeException("Report not found: " + reportId);
        }

        SMSReport report = reportOptional.get();
        report.setMessageToUser(messageToUser);
        report.setTotalCost(totalCost);

        // Update report content if provided
        if (reportContent != null && !reportContent.trim().isEmpty()) {
            report.setReportContent(reportContent);
        }

        report.setUpdatedAt(LocalDateTime.now());

        return smsReportRepository.save(report);
    }

    @Transactional
    public void deleteReport(String reportId) {
        Optional<SMSReport> reportOptional = smsReportRepository.findByReportId(reportId);

        if (reportOptional.isEmpty()) {
            throw new RuntimeException("Report not found: " + reportId);
        }

        smsReportRepository.deleteByReportId(reportId);
    }

    public List<SMSReport> getPendingReports() {
        return smsReportRepository.findByStatusOrderByRequestDateAsc("PENDING");
    }

    public List<SMSReport> getAllReports() {
        return smsReportRepository.findAllByOrderByCreatedAtDesc();
    }

    public List<SMSReport> getUserReports(Long userId) {
        return smsReportRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }

    public Optional<SMSReport> getReportById(String reportId) {
        return smsReportRepository.findByReportId(reportId);
    }

    public Long getPendingReportsCount() {
        return smsReportRepository.countByStatus("PENDING");
    }

    public Long getGeneratedReportsCount() {
        return smsReportRepository.countGeneratedReports();
    }

    private String generateReportId() {
        String maxReportId = smsReportRepository.findMaxReportId();
        if (maxReportId != null) {
            try {
                int lastNumber = Integer.parseInt(maxReportId.replace("rep-", ""));
                return "rep-" + (lastNumber + 1);
            } catch (NumberFormatException e) {
                return "rep-1";
            }
        }
        return "rep-1";
    }

    private String generateReportContent(Booking booking, SMSReport report) {
        StringBuilder content = new StringBuilder();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

        // Header
        content.append("=== WILDTRAILS FINANCIAL REPORT ===\n");
        content.append("Report ID: ").append(report.getReportId()).append("\n");
        content.append("Generated Date: ").append(LocalDateTime.now().format(formatter)).append("\n\n");

        // Booking Details
        content.append("BOOKING DETAILS:\n");
        content.append("---------------\n");
        content.append("Booking ID: ").append(booking.getBookingId()).append("\n");
        content.append("Trip Date: ").append(booking.getTripDate()).append("\n");
        content.append("Duration: ").append(booking.getDurationDays()).append(" days\n");
        content.append("Number of Persons: ").append(booking.getNumberOfPersons()).append("\n\n");

        // Tour Details
        Optional<Tour> tourOptional = tourRepository.findByTourId(booking.getTourId());
        if (tourOptional.isPresent()) {
            Tour tour = tourOptional.get();
            content.append("TOUR DETAILS:\n");
            content.append("-------------\n");
            content.append("Tour Name: ").append(tour.getTourName()).append("\n");
        }

        // Cost Breakdown
        content.append("COST BREAKDOWN:\n");
        content.append("---------------\n");

        Double totalCost = calculateTotalCost(booking);
        content.append(String.format("Total Amount: Rs.%.2f\n\n", totalCost));

        // Additional Information
        if (booking.getSpecialRequirements() != null && !booking.getSpecialRequirements().isEmpty()) {
            content.append("SPECIAL REQUIREMENTS:\n");
            content.append("---------------------\n");
            content.append(booking.getSpecialRequirements()).append("\n\n");
        }

        // Guide Information if available
        if (booking.getSelectedGuideId() != null && !booking.getSelectedGuideId().isEmpty()) {
            Optional<Guide> guideOptional = guideRepository.findByGuideId(booking.getSelectedGuideId());
            if (guideOptional.isPresent()) {
                Guide guide = guideOptional.get();
                content.append("ASSIGNED GUIDE:\n");
                content.append("---------------\n");
                content.append("Name: ").append(guide.getName()).append("\n");
                content.append("Contact: ").append(guide.getPhoneNumber()).append("\n");
                content.append("Experience: ").append(guide.getExperienceYears()).append(" years\n\n");
            }
        }

        content.append("Thank you for choosing WildTrails!\n");
        content.append("For any queries, contact our support team.\n");

        return content.toString();
    }

    private Double calculateTotalCost(Booking booking) {
        // Start with the base booking amount
        Double totalCost = booking.getTotalAmount();

        // Add guide cost if selected
        if (booking.getSelectedGuideId() != null && !booking.getSelectedGuideId().isEmpty()) {
            Optional<Guide> guideOptional = guideRepository.findByGuideId(booking.getSelectedGuideId());
            if (guideOptional.isPresent()) {
                Guide guide = guideOptional.get();
                totalCost += guide.getDailyRate() * booking.getDurationDays();
            }
        }

        // Add insurance cost if selected
        if (booking.getInsurancePlan() != null && !booking.getInsurancePlan().isEmpty()) {
            Optional<Insurance> insuranceOptional = insuranceRepository.findByInsuranceId(booking.getInsurancePlan());
            if (insuranceOptional.isPresent()) {
                Insurance insurance = insuranceOptional.get();
                totalCost += insurance.getPricePerDayPerPerson() * booking.getDurationDays() * booking.getNumberOfPersons();
            }
        }

        return totalCost;
    }

    private void sendReportNotification(SMSReport report) {
        try {
            Optional<User> userOptional = userRepository.findById(report.getUserId());
            Optional<Booking> bookingOptional = bookingRepository.findById(report.getBookingId());

            if (userOptional.isPresent() && bookingOptional.isPresent()) {
                User user = userOptional.get();
                Booking booking = bookingOptional.get();

                String message = String.format(
                        "Dear %s, your financial report for booking %s is ready. Total Cost: Rs.%.2f. %s",
                        user.getFirstName(),
                        booking.getBookingId(),
                        report.getTotalCost(),
                        report.getMessageToUser() != null ? report.getMessageToUser() : "Thank you for choosing WildTrails!"
                );

                // Save to SMS log
                SMSLog smsLog = new SMSLog();
                smsLog.setBookingId(booking.getBookingId());
                smsLog.setRecipientType("user");
                smsLog.setRecipientPhone(user.getPhoneNumber());
                smsLog.setMessage(message);
                smsLog.setStatus("sent");
                smsLogRepository.save(smsLog);

                System.out.println("Report notification sent to user: " + user.getPhoneNumber());
            }
        } catch (Exception e) {
            System.err.println("Error sending report notification: " + e.getMessage());
        }
    }
}