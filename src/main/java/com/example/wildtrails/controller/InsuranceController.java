package com.example.wildtrails.controller;

import com.example.wildtrails.module.Insurance;
import com.example.wildtrails.module.InsuranceBooking;
import com.example.wildtrails.service.InsuranceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/insurance")
public class InsuranceController {

    @Autowired
    private InsuranceService insuranceService;

    // Public insurance page
    @GetMapping
    public String showInsurancePlans(Model model) {
        List<Insurance> foreignPlans = insuranceService.getInsuranceByType("foreign");
        List<Insurance> localPlans = insuranceService.getInsuranceByType("local");

        model.addAttribute("foreignPlans", foreignPlans);
        model.addAttribute("localPlans", localPlans);
        return "insurance/insurance";
    }

    // Admin login page
    @GetMapping("/admin")
    public String showAdminLogin(HttpSession session, Model model) {
        if (session.getAttribute("insuranceAdminLoggedIn") != null) {
            return "redirect:/insurance/admin/dashboard";
        }
        return "insurance/admininsurance";
    }

    // Process admin login
    @PostMapping("/admin")
    public String processAdminLogin(
            @RequestParam String username,
            @RequestParam String password,
            HttpSession session,
            Model model) {

        if (insuranceService.authenticateAdmin(username, password)) {
            session.setAttribute("insuranceAdminLoggedIn", true);
            session.setAttribute("adminUsername", username);
            return "redirect:/insurance/admin/dashboard";
        } else {
            model.addAttribute("error", "Invalid admin credentials");
            return "insurance/admininsurance";
        }
    }

    // Admin dashboard
    @GetMapping("/admin/dashboard")
    public String showAdminDashboard(HttpSession session, Model model) {
        if (session.getAttribute("insuranceAdminLoggedIn") == null) {
            return "redirect:/insurance/admin";
        }

        List<Insurance> allInsurance = insuranceService.getAllActiveInsurance();
        List<InsuranceBooking> insuranceBookings = insuranceService.getAllInsuranceBookings();

        model.addAttribute("insurancePlans", allInsurance);
        model.addAttribute("insuranceBookings", insuranceBookings);
        return "insurance/admininsurance";
    }

    // Add new insurance plan
    @PostMapping("/admin/add")
    public String addInsurancePlan(
            @RequestParam String companyName,
            @RequestParam String insuranceType,
            @RequestParam String coverageType,
            @RequestParam Double pricePerDayPerPerson,
            @RequestParam Integer maxDays,
            @RequestParam(required = false) String description,
            @RequestParam(required = false) String specialFeatures,
            HttpSession session,
            Model model) {

        if (session.getAttribute("insuranceAdminLoggedIn") == null) {
            return "redirect:/insurance/admin";
        }

        try {
            Insurance insurance = new Insurance();
            insurance.setCompanyName(companyName);
            insurance.setInsuranceType(insuranceType);
            insurance.setCoverageType(coverageType);
            insurance.setPricePerDayPerPerson(pricePerDayPerPerson);
            insurance.setMaxDays(maxDays);
            insurance.setDescription(description);
            insurance.setSpecialFeatures(specialFeatures);
            insurance.setStatus("active");

            Insurance savedInsurance = insuranceService.saveInsurance(insurance);
            model.addAttribute("success", "Insurance plan added successfully with ID: " + savedInsurance.getInsuranceId());

        } catch (Exception e) {
            model.addAttribute("error", "Error adding insurance plan: " + e.getMessage());
        }

        return "redirect:/insurance/admin/dashboard";
    }

    // Edit insurance plan - show form
    @GetMapping("/admin/edit/{insuranceId}")
    public String showEditInsuranceForm(@PathVariable String insuranceId, HttpSession session, Model model) {
        if (session.getAttribute("insuranceAdminLoggedIn") == null) {
            return "redirect:/insurance/admin";
        }

        Optional<Insurance> insuranceOptional = insuranceService.getInsuranceById(insuranceId);
        if (insuranceOptional.isEmpty()) {
            model.addAttribute("error", "Insurance plan not found");
            return "redirect:/insurance/admin/dashboard";
        }

        model.addAttribute("insurance", insuranceOptional.get());
        return "insurance/editinsurance";
    }

    // Update insurance plan
    @PostMapping("/admin/update/{insuranceId}")
    public String updateInsurancePlan(
            @PathVariable String insuranceId,
            @RequestParam String companyName,
            @RequestParam String insuranceType,
            @RequestParam String coverageType,
            @RequestParam Double pricePerDayPerPerson,
            @RequestParam Integer maxDays,
            @RequestParam(required = false) String description,
            @RequestParam(required = false) String specialFeatures,
            HttpSession session,
            Model model) {

        if (session.getAttribute("insuranceAdminLoggedIn") == null) {
            return "redirect:/insurance/admin";
        }

        try {
            Optional<Insurance> insuranceOptional = insuranceService.getInsuranceById(insuranceId);
            if (insuranceOptional.isEmpty()) {
                model.addAttribute("error", "Insurance plan not found");
                return "redirect:/insurance/admin/dashboard";
            }

            Insurance insurance = insuranceOptional.get();
            insurance.setCompanyName(companyName);
            insurance.setInsuranceType(insuranceType);
            insurance.setCoverageType(coverageType);
            insurance.setPricePerDayPerPerson(pricePerDayPerPerson);
            insurance.setMaxDays(maxDays);
            insurance.setDescription(description);
            insurance.setSpecialFeatures(specialFeatures);

            insuranceService.saveInsurance(insurance);
            model.addAttribute("success", "Insurance plan updated successfully!");

        } catch (Exception e) {
            model.addAttribute("error", "Error updating insurance plan: " + e.getMessage());
        }

        return "redirect:/insurance/admin/dashboard";
    }

    // Delete insurance plan
    @PostMapping("/admin/delete/{insuranceId}")
    public String deleteInsurancePlan(@PathVariable String insuranceId, HttpSession session, Model model) {
        if (session.getAttribute("insuranceAdminLoggedIn") == null) {
            return "redirect:/insurance/admin";
        }

        try {
            insuranceService.deleteInsurance(insuranceId);
            model.addAttribute("success", "Insurance plan deleted successfully");
        } catch (Exception e) {
            model.addAttribute("error", "Error deleting insurance plan: " + e.getMessage());
        }

        return "redirect:/insurance/admin/dashboard";
    }

    // Logout
    @GetMapping("/logout")
    public String adminLogout(HttpSession session) {
        session.removeAttribute("insuranceAdminLoggedIn");
        session.removeAttribute("adminUsername");
        return "redirect:/insurance";
    }
}