package com.example.wildtrails.service;

import com.example.wildtrails.module.Guide;
import com.example.wildtrails.repository.GuideRepository;
import com.example.wildtrails.util.PasswordUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@Service
public class GuideService {

    @Autowired
    private GuideRepository guideRepository;

    public List<Guide> getAllActiveGuides() {
        return guideRepository.findByStatusOrderByExperienceYearsDesc("active");
    }

    public Optional<Guide> getGuideById(String guideId) {
        return guideRepository.findByGuideId(guideId);
    }

    public Guide saveGuide(Guide guide, MultipartFile photoFile) throws IOException {
        // Generate guide ID if not provided
        if (guide.getGuideId() == null || guide.getGuideId().isEmpty()) {
            guide.setGuideId(generateGuideId());
        }

        // Encrypt password
        if (guide.getPlainPassword() != null && !guide.getPlainPassword().isEmpty()) {
            guide.setPassword(PasswordUtil.encrypt(guide.getPlainPassword()));
        }

        // Handle photo upload
        if (photoFile != null && !photoFile.isEmpty()) {
            guide.setPhotoName(photoFile.getOriginalFilename());
            guide.setPhotoData(photoFile.getBytes());
        }

        return guideRepository.save(guide);
    }

    public void deleteGuide(String guideId) {
        Optional<Guide> guideOptional = guideRepository.findByGuideId(guideId);
        guideOptional.ifPresent(guide -> {
            guide.setStatus("inactive");
            guideRepository.save(guide);
        });
    }

    private String generateGuideId() {
        String maxGuideId = guideRepository.findMaxGuideId();
        if (maxGuideId != null) {
            try {
                int lastNumber = Integer.parseInt(maxGuideId.replace("gui-", ""));
                return "gui-" + (lastNumber + 1);
            } catch (NumberFormatException e) {
                return "gui-1";
            }
        }
        return "gui-1";
    }

    public byte[] getGuidePhoto(String guideId) {
        Optional<Guide> guide = guideRepository.findByGuideId(guideId);
        return guide.map(Guide::getPhotoData).orElse(null);
    }

    public boolean validateGuidePassword(String guideId, String password) {
        Optional<Guide> guide = guideRepository.findByGuideId(guideId);
        return guide.map(g -> PasswordUtil.checkPassword(password, g.getPassword()))
                .orElse(false);
    }
}