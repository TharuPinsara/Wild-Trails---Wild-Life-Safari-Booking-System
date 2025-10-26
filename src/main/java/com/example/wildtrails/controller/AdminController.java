package com.example.wildtrails.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AdminController {

    @GetMapping("/admin/dashboard")
    public String showAdminDashboard(Model model) {
        // Add statistics data to the model
        // You can replace these with actual service calls to get real data
        model.addAttribute("activeDriversCount", 24);
        model.addAttribute("availableGuidesCount", 18);
        model.addAttribute("activeBookingsCount", 156);
        model.addAttribute("safariToursCount", 42);

        return "admin/dashboard";
    }
}