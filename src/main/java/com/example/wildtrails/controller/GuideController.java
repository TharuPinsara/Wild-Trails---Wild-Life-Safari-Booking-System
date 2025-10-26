package com.example.wildtrails.controller;

import com.example.wildtrails.module.Guide;
import com.example.wildtrails.module.Sighting;
import com.example.wildtrails.module.GuideSchedule;
import com.example.wildtrails.service.GuideService;
import com.example.wildtrails.service.SightingService;
import com.example.wildtrails.service.GuideScheduleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/guides")
public class GuideController {

    @Autowired
    private GuideService guideService;

    @Autowired
    private SightingService sightingService;

    @Autowired
    private GuideScheduleService guideScheduleService;

    @Autowired
    private HttpSession session;

    @GetMapping
    public String showGuidesList(Model model) {
        List<Guide> guides = guideService.getAllActiveGuides();
        model.addAttribute("guides", guides);
        return "guides/guides";
    }

    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        model.addAttribute("guide", new Guide());
        return "guides/registerguides";
    }

    @PostMapping("/register")
    public String registerGuide(
            @RequestParam String name,
            @RequestParam String phoneNumber,
            @RequestParam(required = false) String email,
            @RequestParam Integer experienceYears,
            @RequestParam(required = false) String specialization,
            @RequestParam(required = false) String languages,
            @RequestParam Double dailyRate,
            @RequestParam(required = false) String availableTrips,
            @RequestParam(required = false) String opportunities,
            @RequestParam String password,
            @RequestParam(required = false) MultipartFile photoFile,
            Model model) {

        try {
            Guide guide = new Guide();
            guide.setName(name);
            guide.setPhoneNumber(phoneNumber);
            guide.setEmail(email);
            guide.setExperienceYears(experienceYears);
            guide.setSpecialization(specialization);
            guide.setLanguages(languages);
            guide.setDailyRate(dailyRate);
            guide.setAvailableTrips(availableTrips);
            guide.setOpportunities(opportunities);
            guide.setPlainPassword(password);
            guide.setStatus("active");

            Guide savedGuide = guideService.saveGuide(guide, photoFile);
            model.addAttribute("success", "Guide registered successfully with ID: " + savedGuide.getGuideId());

        } catch (Exception e) {
            model.addAttribute("error", "Error registering guide: " + e.getMessage());
            return "guides/registerguides";
        }

        return "redirect:/guides?success";
    }

    @GetMapping("/photo/{guideId}")
    public ResponseEntity<byte[]> getGuidePhoto(@PathVariable String guideId) {
        byte[] photoData = guideService.getGuidePhoto(guideId);
        if (photoData != null) {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.IMAGE_JPEG);
            return new ResponseEntity<>(photoData, headers, HttpStatus.OK);
        }
        return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }

    @GetMapping("/login")
    public String showLoginForm() {
        return "guides/guidelogin";
    }

    @PostMapping("/login")
    public String loginGuide(@RequestParam String guideId,
                             @RequestParam String password,
                             Model model) {
        try {
            // Validate guide credentials
            boolean isValid = guideService.validateGuidePassword(guideId, password);
            if (isValid) {
                Optional<Guide> guideOpt = guideService.getGuideById(guideId);
                if (guideOpt.isPresent()) {
                    Guide guide = guideOpt.get();
                    // Store guide in session
                    session.setAttribute("guideId", guide.getGuideId());
                    session.setAttribute("guideName", guide.getName());
                    session.setAttribute("guide", guide);
                    return "redirect:/guides/dashboard";
                }
            }
            model.addAttribute("error", "Invalid Guide ID or password");
        } catch (Exception e) {
            model.addAttribute("error", "Login failed: " + e.getMessage());
        }
        return "guides/guidelogin";
    }

    @GetMapping("/dashboard")
    public String showDashboard(Model model) {
        String guideId = (String) session.getAttribute("guideId");
        if (guideId == null) {
            return "redirect:/guides/login";
        }

        try {
            Optional<Guide> guideOpt = guideService.getGuideById(guideId);
            if (guideOpt.isPresent()) {
                Guide guide = guideOpt.get();
                model.addAttribute("guide", guide);

                // Get sightings data using the injected sightingService
                List<Sighting> recentSightings = sightingService.getRecentSightingsByGuide(guideId, 5);
                int totalSightings = sightingService.getSightingsCountByGuide(guideId);
                int todaySightings = sightingService.getTodaySightingsCountByGuide(guideId);

                model.addAttribute("recentSightings", recentSightings);
                model.addAttribute("sightingsCount", totalSightings);
                model.addAttribute("todaySightingsCount", todaySightings);
            } else {
                model.addAttribute("error", "Guide not found");
                return "redirect:/guides/login";
            }
        } catch (Exception e) {
            model.addAttribute("error", "Failed to load dashboard: " + e.getMessage());
        }

        return "guides/guidedashboard";
    }

    @GetMapping("/schedule")
    public String showGuideSchedule(Model model) {
        String guideId = (String) session.getAttribute("guideId");
        if (guideId == null) {
            return "redirect:/guides/login";
        }

        try {
            Optional<Guide> guideOpt = guideService.getGuideById(guideId);
            if (guideOpt.isPresent()) {
                Guide guide = guideOpt.get();
                model.addAttribute("guide", guide);

                // Get schedule data
                List<GuideSchedule> schedules = guideScheduleService.getSchedulesByGuideId(guideId);
                int totalBookings = guideScheduleService.getBookedSchedulesCount(guideId);
                int upcomingBookings = guideScheduleService.getUpcomingBookingsCount(guideId);
                int monthBookings = guideScheduleService.getThisMonthBookingsCount(guideId);

                model.addAttribute("schedules", schedules);
                model.addAttribute("totalBookings", totalBookings);
                model.addAttribute("upcomingBookings", upcomingBookings);
                model.addAttribute("monthBookings", monthBookings);
            } else {
                model.addAttribute("error", "Guide not found");
                return "redirect:/guides/login";
            }
        } catch (Exception e) {
            model.addAttribute("error", "Failed to load schedule: " + e.getMessage());
        }

        return "guides/guideschedule";
    }

    // Show all sightings page with optional guide filter
    @GetMapping("/sightings")
    public String showAllSightings(@RequestParam(required = false) String guideId, Model model) {
        try {
            List<Sighting> sightings;
            String selectedGuideName = "All Guides";

            if (guideId != null && !guideId.isEmpty()) {
                // Filter by specific guide
                sightings = sightingService.getSightingsByGuideId(guideId);
                // Get guide name for display
                Optional<Guide> guideOpt = guideService.getGuideById(guideId);
                if (guideOpt.isPresent()) {
                    selectedGuideName = guideOpt.get().getName() + "'s";
                }
            } else {
                // Get all sightings
                sightings = sightingService.getAllSightings();
            }

            List<Guide> guides = guideService.getAllActiveGuides();

            // Get statistics
            int totalSightings = sightingService.getTotalSightingsCount();
            int todaySightings = sightingService.getTodaySightingsCount();
            int animalTypesCount = sightingService.getAnimalTypesCount();
            int activeGuidesCount = guides.size();
            List<String> animalTypes = sightingService.getDistinctAnimalTypes();

            model.addAttribute("sightings", sightings);
            model.addAttribute("guides", guides);
            model.addAttribute("totalSightings", totalSightings);
            model.addAttribute("todaySightings", todaySightings);
            model.addAttribute("animalTypesCount", animalTypesCount);
            model.addAttribute("activeGuidesCount", activeGuidesCount);
            model.addAttribute("animalTypes", animalTypes);
            model.addAttribute("selectedGuideName", selectedGuideName);
            model.addAttribute("selectedGuideId", guideId);

        } catch (Exception e) {
            model.addAttribute("error", "Failed to load sightings: " + e.getMessage());
        }

        return "guides/sightings";
    }

    // Edit Sighting - Show Form
    @GetMapping("/sightings/edit/{sightId}")
    public String showEditSightingForm(@PathVariable Long sightId, Model model) {
        String guideId = (String) session.getAttribute("guideId");
        if (guideId == null) {
            return "redirect:/guides/login";
        }

        try {
            Optional<Sighting> sightingOpt = sightingService.getSightingById(sightId);
            if (sightingOpt.isPresent()) {
                Sighting sighting = sightingOpt.get();
                // Check if the sighting belongs to the logged-in guide
                if (!sighting.getGuideId().equals(guideId)) {
                    model.addAttribute("error", "You can only edit your own sightings");
                    return "redirect:/guides/dashboard";
                }
                model.addAttribute("sighting", sighting);
            } else {
                model.addAttribute("error", "Sighting not found");
                return "redirect:/guides/dashboard";
            }
        } catch (Exception e) {
            model.addAttribute("error", "Failed to load sighting: " + e.getMessage());
        }

        return "guides/editsighting";
    }

    @GetMapping("/logout")
    public String logoutGuide() {
        session.removeAttribute("guideId");
        session.removeAttribute("guideName");
        session.removeAttribute("guide");
        session.invalidate();
        return "redirect:/guides/login";
    }
}