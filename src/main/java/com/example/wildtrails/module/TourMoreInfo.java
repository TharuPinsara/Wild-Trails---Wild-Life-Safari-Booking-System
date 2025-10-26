package com.example.wildtrails.module;

import jakarta.persistence.*;

@Entity
@Table(name = "tours_more_info")
public class TourMoreInfo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "tour_id", nullable = false)
    private String tourId;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "places_to_visit", columnDefinition = "TEXT")
    private String placesToVisit;

    @Column(name = "itinerary", columnDefinition = "TEXT")
    private String itinerary;

    @Column(name = "included_services", columnDefinition = "TEXT")
    private String includedServices;

    @Column(name = "excluded_services", columnDefinition = "TEXT")
    private String excludedServices;

    @Column(name = "important_notes", columnDefinition = "TEXT")
    private String importantNotes;

    @Column(name = "additional_photos_data", columnDefinition = "VARBINARY(MAX)")
    private byte[] additionalPhotosData;

    // Constructors
    public TourMoreInfo() {}

    public TourMoreInfo(String tourId, String description, String placesToVisit,
                        String itinerary, String includedServices, String excludedServices,
                        String importantNotes) {
        this.tourId = tourId;
        this.description = description;
        this.placesToVisit = placesToVisit;
        this.itinerary = itinerary;
        this.includedServices = includedServices;
        this.excludedServices = excludedServices;
        this.importantNotes = importantNotes;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTourId() { return tourId; }
    public void setTourId(String tourId) { this.tourId = tourId; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getPlacesToVisit() { return placesToVisit; }
    public void setPlacesToVisit(String placesToVisit) { this.placesToVisit = placesToVisit; }

    public String getItinerary() { return itinerary; }
    public void setItinerary(String itinerary) { this.itinerary = itinerary; }

    public String getIncludedServices() { return includedServices; }
    public void setIncludedServices(String includedServices) { this.includedServices = includedServices; }

    public String getExcludedServices() { return excludedServices; }
    public void setExcludedServices(String excludedServices) { this.excludedServices = excludedServices; }

    public String getImportantNotes() { return importantNotes; }
    public void setImportantNotes(String importantNotes) { this.importantNotes = importantNotes; }

    public byte[] getAdditionalPhotosData() { return additionalPhotosData; }
    public void setAdditionalPhotosData(byte[] additionalPhotosData) { this.additionalPhotosData = additionalPhotosData; }
}