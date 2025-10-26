package com.example.wildtrails.controller;

import com.example.wildtrails.module.Sighting;
import com.example.wildtrails.service.SightingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@Controller
@RequestMapping("/guides/sightings")
public class SightingController {

    private final SightingService sightingService;

    @Autowired
    private HttpSession session;

    public SightingController(SightingService sightingService) {
        this.sightingService = sightingService;
    }

    @PostMapping("/add")
    public String addSighting(@RequestParam String animalType,
                              @RequestParam String species,
                              @RequestParam String coordinates,
                              @RequestParam(required = false) String location,
                              @RequestParam(required = false) String specialDetails,
                              @RequestParam(required = false) MultipartFile sightingPhoto,
                              RedirectAttributes redirectAttributes) {
        String guideId = (String) session.getAttribute("guideId");
        if (guideId == null) {
            return "redirect:/guides/login";
        }

        try {
            Sighting sighting = new Sighting();
            sighting.setGuideId(guideId);
            sighting.setAnimalType(animalType);
            sighting.setSpecies(species);
            sighting.setCoordinates(coordinates);
            sighting.setLocation(location);
            sighting.setSpecialDetails(specialDetails);
            sighting.setSightingDate(java.time.LocalDateTime.now());
            sighting.setCreatedAt(java.time.LocalDateTime.now());
            sighting.setUpdatedAt(java.time.LocalDateTime.now());

            Sighting savedSighting = sightingService.addSighting(sighting, sightingPhoto);
            redirectAttributes.addFlashAttribute("success",
                    "Sighting recorded successfully! ID: " + savedSighting.getSightId());

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error",
                    "Failed to record sighting: " + e.getMessage());
        }

        return "redirect:/guides/dashboard";
    }

    // UPDATE SIGHTING - FIXED VERSION
    @PostMapping("/update")
    public String updateSighting(@RequestParam("sightId") Long sightId,
                                 @RequestParam String animalType,
                                 @RequestParam String species,
                                 @RequestParam String coordinates,
                                 @RequestParam(required = false) String location,
                                 @RequestParam(required = false) String specialDetails,
                                 @RequestParam(required = false) MultipartFile sightingPhoto,
                                 RedirectAttributes redirectAttributes) {
        String guideId = (String) session.getAttribute("guideId");
        if (guideId == null) {
            return "redirect:/guides/login";
        }

        try {
            // Verify the sighting belongs to the guide
            java.util.Optional<Sighting> existingSighting = sightingService.getSightingById(sightId);
            if (!existingSighting.isPresent()) {
                redirectAttributes.addFlashAttribute("error", "Sighting not found");
                return "redirect:/guides/dashboard";
            }

            Sighting sighting = existingSighting.get();
            if (!sighting.getGuideId().equals(guideId)) {
                redirectAttributes.addFlashAttribute("error", "You can only update your own sightings");
                return "redirect:/guides/dashboard";
            }

            // Update sighting fields
            sighting.setAnimalType(animalType);
            sighting.setSpecies(species);
            sighting.setCoordinates(coordinates);
            sighting.setLocation(location);
            sighting.setSpecialDetails(specialDetails);
            sighting.setSightingDate(java.time.LocalDateTime.now());

            Sighting updatedSighting = sightingService.updateSighting(sighting, sightingPhoto);
            redirectAttributes.addFlashAttribute("success", "Sighting updated successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to update sighting: " + e.getMessage());
            e.printStackTrace(); // For debugging
        }

        return "redirect:/guides/dashboard";
    }

    // DELETE SIGHTING
    @PostMapping("/delete/{sightId}")
    public String deleteSighting(@PathVariable Long sightId, RedirectAttributes redirectAttributes) {
        String guideId = (String) session.getAttribute("guideId");
        if (guideId == null) {
            return "redirect:/guides/login";
        }

        try {
            // Verify the sighting belongs to the guide
            java.util.Optional<Sighting> sighting = sightingService.getSightingById(sightId);
            if (sighting.isPresent() && !sighting.get().getGuideId().equals(guideId)) {
                redirectAttributes.addFlashAttribute("error", "You can only delete your own sightings");
                return "redirect:/guides/dashboard";
            }

            sightingService.deleteSighting(sightId);
            redirectAttributes.addFlashAttribute("success", "Sighting deleted successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to delete sighting: " + e.getMessage());
        }

        return "redirect:/guides/dashboard";
    }

    @GetMapping("/photo/{sightId}")
    public ResponseEntity<byte[]> getSightingPhoto(@PathVariable String sightId) {
        byte[] photoData = sightingService.getSightingPhoto(sightId);
        if (photoData != null) {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.IMAGE_JPEG);
            return new ResponseEntity<>(photoData, headers, HttpStatus.OK);
        }
        return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }
}