package com.example.wildtrails.controller;

import com.example.wildtrails.module.SMSReport;
import com.example.wildtrails.service.ReportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/reports")
public class ReportController {

    @Autowired
    private ReportService reportService;

    // Show admin login page
    @GetMapping("/admin/login")
    public String showAdminLogin(HttpSession session) {
        // If already logged in as admin, redirect to finance panel
        if (session.getAttribute("financeAdminLoggedIn") != null) {
            return "redirect:/reports/admin/finance";
        }
        return "reports/admin-login";
    }

    // Process admin login
    @PostMapping("/admin/login")
    public String processAdminLogin(
            @RequestParam String username,
            @RequestParam String password,
            HttpSession session,
            Model model) {

        // Simple hardcoded credentials
        if ("admin123".equals(username) && "pass123".equals(password)) {
            // Login successful
            session.setAttribute("financeAdminLoggedIn", true);
            session.setAttribute("financeAdminUsername", username);
            return "redirect:/reports/admin/finance";
        } else {
            model.addAttribute("error", "Invalid username or password!");
            return "reports/admin-login";
        }
    }

    // Admin logout
    @GetMapping("/admin/logout")
    public String adminLogout(HttpSession session) {
        session.removeAttribute("financeAdminLoggedIn");
        session.removeAttribute("financeAdminUsername");
        session.invalidate();
        return "redirect:/reports/admin/login";
    }

    // Finance officer admin page
    @GetMapping("/admin/finance")
    public String showFinanceAdmin(HttpSession session, Model model) {
        // Check if admin is logged in
        if (session.getAttribute("financeAdminLoggedIn") == null) {
            return "redirect:/reports/admin/login";
        }

        List<SMSReport> pendingReports = reportService.getPendingReports();
        List<SMSReport> allReports = reportService.getAllReports();
        Long pendingCount = reportService.getPendingReportsCount();
        Long generatedCount = reportService.getGeneratedReportsCount();

        model.addAttribute("pendingReports", pendingReports);
        model.addAttribute("allReports", allReports);
        model.addAttribute("pendingCount", pendingCount);
        model.addAttribute("generatedCount", generatedCount);

        return "reports/adminfinance";
    }

    // User requests a report
    @PostMapping("/request")
    @ResponseBody
    public ResponseEntity<?> requestReport(
            @RequestParam Long bookingId,
            @RequestParam String reportType,
            HttpSession session) {

        // Check if user is logged in
        if (session.getAttribute("userLoggedIn") == null) {
            return ResponseEntity.status(401).body("Unauthorized");
        }

        Long userId = (Long) session.getAttribute("userId");

        try {
            SMSReport report = reportService.requestReport(bookingId, userId, reportType);
            return ResponseEntity.ok().body("Report requested successfully. Reference ID: " + report.getReportId());
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Error requesting report: " + e.getMessage());
        }
    }

    // Show user's reports
    @GetMapping("/myreports")
    public String showMyReports(HttpSession session, Model model) {
        // Check if user is logged in
        if (session.getAttribute("userLoggedIn") == null) {
            return "redirect:/userlogin/login";
        }

        Long userId = (Long) session.getAttribute("userId");
        List<SMSReport> reports = reportService.getUserReports(userId);

        model.addAttribute("reports", reports);
        return "reports/myreports";
    }

    // Show report details
    @GetMapping("/{reportId}")
    public String showReportDetails(@PathVariable String reportId, HttpSession session, Model model) {
        // Check if user is logged in
        if (session.getAttribute("userLoggedIn") == null) {
            return "redirect:/userlogin/login";
        }

        Long userId = (Long) session.getAttribute("userId");
        Optional<SMSReport> reportOptional = reportService.getReportById(reportId);

        if (reportOptional.isEmpty()) {
            return "redirect:/reports/myreports";
        }

        SMSReport report = reportOptional.get();

        // Ensure user can only view their own reports
        if (!report.getUserId().equals(userId)) {
            return "redirect:/reports/myreports";
        }

        model.addAttribute("report", report);
        return "reports/report-details";
    }

    // Generate report (Finance officer action)
    @PostMapping("/admin/generate")
    @ResponseBody
    public ResponseEntity<?> generateReport(
            @RequestParam String reportId,
            @RequestParam String messageToUser,
            HttpSession session) {

        // Check if admin is logged in
        if (session.getAttribute("financeAdminLoggedIn") == null) {
            return ResponseEntity.status(401).body("Unauthorized");
        }

        Long financeOfficerId = 1L; // Default admin ID

        try {
            SMSReport report = reportService.generateFullReport(reportId, financeOfficerId, messageToUser);
            return ResponseEntity.ok().body("Report generated successfully for: " + report.getReportId());
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Error generating report: " + e.getMessage());
        }
    }

    // Update report (Finance officer action) - Modified to include reportContent
    @PostMapping("/admin/update")
    @ResponseBody
    public ResponseEntity<?> updateReport(
            @RequestParam String reportId,
            @RequestParam String messageToUser,
            @RequestParam Double totalCost,
            @RequestParam(required = false) String reportContent,
            HttpSession session) {

        // Check if admin is logged in
        if (session.getAttribute("financeAdminLoggedIn") == null) {
            return ResponseEntity.status(401).body("Unauthorized");
        }

        try {
            SMSReport report = reportService.updateReport(reportId, messageToUser, totalCost, reportContent);
            return ResponseEntity.ok().body("Report updated successfully for: " + report.getReportId());
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Error updating report: " + e.getMessage());
        }
    }

    // Delete report (Finance officer action)
    @PostMapping("/admin/delete")
    @ResponseBody
    public ResponseEntity<?> deleteReport(
            @RequestParam String reportId,
            HttpSession session) {

        // Check if admin is logged in
        if (session.getAttribute("financeAdminLoggedIn") == null) {
            return ResponseEntity.status(401).body("Unauthorized");
        }

        try {
            reportService.deleteReport(reportId);
            return ResponseEntity.ok().body("Report deleted successfully: " + reportId);
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Error deleting report: " + e.getMessage());
        }
    }

    // Get report details for admin
    @GetMapping("/admin/details/{reportId}")
    @ResponseBody
    public ResponseEntity<?> getReportDetails(@PathVariable String reportId) {
        Optional<SMSReport> reportOptional = reportService.getReportById(reportId);

        if (reportOptional.isEmpty()) {
            return ResponseEntity.status(404).body("Report not found");
        }

        return ResponseEntity.ok().body(reportOptional.get());
    }
}