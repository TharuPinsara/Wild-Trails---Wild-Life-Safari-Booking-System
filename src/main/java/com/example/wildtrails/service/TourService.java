package com.example.wildtrails.service;

import com.example.wildtrails.module.Tour;
import com.example.wildtrails.module.TourMoreInfo;
import com.example.wildtrails.repository.TourMoreInfoRepository;
import com.example.wildtrails.repository.TourRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@Service
public class TourService {

    @Autowired
    private TourRepository tourRepository;

    @Autowired
    private TourMoreInfoRepository tourMoreInfoRepository;

    public List<Tour> getAllActiveTours() {
        return tourRepository.findByStatusOrderByTourNameAsc("active");
    }

    public Optional<Tour> getTourById(String tourId) {
        return tourRepository.findByTourId(tourId);
    }

    public Tour saveTour(Tour tour, MultipartFile tourPhotoFile) throws IOException {
        // Generate tour ID if not provided
        if (tour.getTourId() == null || tour.getTourId().isEmpty()) {
            tour.setTourId(generateTourId());
        }

        // Handle tour photo upload
        if (tourPhotoFile != null && !tourPhotoFile.isEmpty()) {
            tour.setTourPhotoName(tourPhotoFile.getOriginalFilename());
            tour.setTourPhotoData(tourPhotoFile.getBytes());
        }

        return tourRepository.save(tour);
    }

    public TourMoreInfo saveTourMoreInfo(TourMoreInfo tourMoreInfo) {
        // Check if info already exists for this tour
        Optional<TourMoreInfo> existingInfo = tourMoreInfoRepository.findByTourId(tourMoreInfo.getTourId());
        if (existingInfo.isPresent()) {
            // Update existing record
            TourMoreInfo existing = existingInfo.get();
            existing.setDescription(tourMoreInfo.getDescription());
            existing.setPlacesToVisit(tourMoreInfo.getPlacesToVisit());
            existing.setItinerary(tourMoreInfo.getItinerary());
            existing.setIncludedServices(tourMoreInfo.getIncludedServices());
            existing.setExcludedServices(tourMoreInfo.getExcludedServices());
            existing.setImportantNotes(tourMoreInfo.getImportantNotes());
            return tourMoreInfoRepository.save(existing);
        } else {
            // Create new record
            return tourMoreInfoRepository.save(tourMoreInfo);
        }
    }

    public Optional<TourMoreInfo> getTourMoreInfo(String tourId) {
        return tourMoreInfoRepository.findByTourId(tourId);
    }

    @Transactional
    public void deleteTour(String tourId) {
        // First delete the tour more info if it exists
        Optional<TourMoreInfo> moreInfoOptional = tourMoreInfoRepository.findByTourId(tourId);
        moreInfoOptional.ifPresent(tourMoreInfoRepository::delete);

        // Then delete the tour
        tourRepository.deleteByTourId(tourId);
    }

    private String generateTourId() {
        String maxTourId = tourRepository.findMaxTourId();
        if (maxTourId != null) {
            try {
                int lastNumber = Integer.parseInt(maxTourId.replace("tour-", ""));
                return "tour-" + (lastNumber + 1);
            } catch (NumberFormatException e) {
                return "tour-1";
            }
        }
        return "tour-1";
    }

    public byte[] getTourPhoto(String tourId) {
        Optional<Tour> tour = tourRepository.findByTourId(tourId);
        return tour.map(Tour::getTourPhotoData).orElse(null);
    }

    public boolean validateAdminLogin(String username, String password) {
        return "admin".equals(username) && "admin".equals(password);
    }
}