package com.example.wildtrails.controller;

import com.example.wildtrails.module.Tour;
import com.example.wildtrails.module.TourMoreInfo;
import com.example.wildtrails.service.TourService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/tours")
public class TourController {

    @Autowired
    private TourService tourService;

    @GetMapping
    public String showToursList(Model model) {
        List<Tour> tours = tourService.getAllActiveTours();
        model.addAttribute("tours", tours);
        return "tours/tours";
    }

    @GetMapping("/add")
    public String showAddTourForm(HttpSession session, Model model) {
        return "tours/addtrips";
    }

    @PostMapping("/add")
    public String processTourForm(@RequestParam(required = false) String login,
                                  @RequestParam(required = false) String username,
                                  @RequestParam(required = false) String password,
                                  @RequestParam(required = false) String tourName,
                                  @RequestParam(required = false) Integer durationDays,
                                  @RequestParam(required = false) String destination,
                                  @RequestParam(required = false) Double price,
                                  @RequestParam(required = false) Boolean includesBreakfast,
                                  @RequestParam(required = false) Boolean includesLunch,
                                  @RequestParam(required = false) Boolean includesDinner,
                                  @RequestParam(required = false) String specialFeatures,
                                  @RequestParam(required = false) MultipartFile tourPhotoFile,
                                  HttpSession session,
                                  Model model) {

        // Handle login attempt
        if (login != null && "true".equals(login)) {
            if ("admin123".equals(username) && "pass123".equals(password)) {
                session.setAttribute("adminLoggedIn", true);
                return "redirect:/tours/add";
            } else {
                model.addAttribute("error", "Invalid admin credentials");
                return "tours/addtrips";
            }
        }

        // Handle tour submission (only if logged in)
        if (session.getAttribute("adminLoggedIn") == null) {
            model.addAttribute("error", "Please login first");
            return "tours/addtrips";
        }

        try {
            Tour tour = new Tour();
            tour.setTourName(tourName);
            tour.setDurationDays(durationDays);
            tour.setDestination(destination);
            tour.setPrice(price);
            tour.setIncludesBreakfast(includesBreakfast != null);
            tour.setIncludesLunch(includesLunch != null);
            tour.setIncludesDinner(includesDinner != null);
            tour.setSpecialFeatures(specialFeatures);
            tour.setStatus("active");

            Tour savedTour = tourService.saveTour(tour, tourPhotoFile);
            model.addAttribute("success", "Tour added successfully with ID: " + savedTour.getTourId());

        } catch (Exception e) {
            model.addAttribute("error", "Error adding tour: " + e.getMessage());
        }

        return "tours/addtrips";
    }

    @GetMapping("/view")
    public String viewAllTours(HttpSession session, Model model) {
        if (session.getAttribute("adminLoggedIn") == null) {
            return "redirect:/tours/add";
        }

        List<Tour> tours = tourService.getAllActiveTours();
        model.addAttribute("tours", tours);
        return "tours/viewtrips";
    }

    @GetMapping("/{tourId}")
    public String showTourDetails(@PathVariable String tourId, Model model) {
        Optional<Tour> tourOptional = tourService.getTourById(tourId);
        if (tourOptional.isEmpty()) {
            return "redirect:/tours";
        }

        Tour tour = tourOptional.get();
        Optional<TourMoreInfo> moreInfoOptional = tourService.getTourMoreInfo(tourId);
        TourMoreInfo moreInfo = moreInfoOptional.orElse(new TourMoreInfo());

        model.addAttribute("tour", tour);
        model.addAttribute("moreInfo", moreInfo);

        return "tours/moreinfo";
    }

    @GetMapping("/{tourId}/add-info")
    public String showAddMoreInfoForm(@PathVariable String tourId, HttpSession session, Model model) {
        if (session.getAttribute("adminLoggedIn") == null) {
            return "redirect:/tours/add";
        }

        Optional<Tour> tourOptional = tourService.getTourById(tourId);
        if (tourOptional.isEmpty()) {
            return "redirect:/tours/view";
        }

        Tour tour = tourOptional.get();
        Optional<TourMoreInfo> moreInfoOptional = tourService.getTourMoreInfo(tourId);
        TourMoreInfo moreInfo = moreInfoOptional.orElse(new TourMoreInfo());

        model.addAttribute("tour", tour);
        model.addAttribute("moreInfo", moreInfo);

        return "tours/addmoreinfo";
    }

    @PostMapping("/{tourId}/add-info")
    public String addMoreInfo(@PathVariable String tourId,
                              @RequestParam String description,
                              @RequestParam String placesToVisit,
                              @RequestParam String itinerary,
                              @RequestParam String includedServices,
                              @RequestParam String excludedServices,
                              @RequestParam String importantNotes,
                              HttpSession session,
                              Model model) {

        if (session.getAttribute("adminLoggedIn") == null) {
            return "redirect:/tours/add";
        }

        try {
            TourMoreInfo moreInfo = new TourMoreInfo();
            moreInfo.setTourId(tourId);
            moreInfo.setDescription(description);
            moreInfo.setPlacesToVisit(placesToVisit);
            moreInfo.setItinerary(itinerary);
            moreInfo.setIncludedServices(includedServices);
            moreInfo.setExcludedServices(excludedServices);
            moreInfo.setImportantNotes(importantNotes);

            tourService.saveTourMoreInfo(moreInfo);
            model.addAttribute("success", "Additional information added successfully!");

        } catch (Exception e) {
            model.addAttribute("error", "Error adding information: " + e.getMessage());
            return "tours/addmoreinfo";
        }

        return "redirect:/tours/" + tourId;
    }

    // Delete tour endpoint
    @PostMapping("/{tourId}/delete")
    public String deleteTour(@PathVariable String tourId, HttpSession session, Model model) {
        if (session.getAttribute("adminLoggedIn") == null) {
            return "redirect:/tours/add";
        }

        try {
            tourService.deleteTour(tourId);
            model.addAttribute("success", "Tour deleted successfully!");
        } catch (Exception e) {
            model.addAttribute("error", "Error deleting tour: " + e.getMessage());
        }

        return "redirect:/tours/view";
    }

    @GetMapping("/logout")
    public String adminLogout(HttpSession session) {
        session.removeAttribute("adminLoggedIn");
        return "redirect:/tours";
    }

    @GetMapping("/photo/{tourId}")
    public ResponseEntity<byte[]> getTourPhoto(@PathVariable String tourId) {
        byte[] photoData = tourService.getTourPhoto(tourId);
        if (photoData != null) {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.IMAGE_JPEG);
            return new ResponseEntity<>(photoData, headers, HttpStatus.OK);
        }
        return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }
}