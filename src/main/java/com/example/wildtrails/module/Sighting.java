package com.example.wildtrails.module;

import java.time.LocalDateTime;
import java.util.Base64;

public class Sighting {
    private Long id;
    private String sightId;
    private String guideId;
    private String animalType;
    private String species;
    private String coordinates;
    private String location;
    private String specialDetails;
    private LocalDateTime sightingDate;
    private String photoName;
    private byte[] photoData;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String base64Photo; // New field for Base64 encoded photo

    // Constructors
    public Sighting() {}

    public Sighting(String sightId, String guideId, String animalType, String species,
                    String coordinates, String location) {
        this.sightId = sightId;
        this.guideId = guideId;
        this.animalType = animalType;
        this.species = species;
        this.coordinates = coordinates;
        this.location = location;
        this.sightingDate = LocalDateTime.now();
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getSightId() { return sightId; }
    public void setSightId(String sightId) { this.sightId = sightId; }

    public String getGuideId() { return guideId; }
    public void setGuideId(String guideId) { this.guideId = guideId; }

    public String getAnimalType() { return animalType; }
    public void setAnimalType(String animalType) { this.animalType = animalType; }

    public String getSpecies() { return species; }
    public void setSpecies(String species) { this.species = species; }

    public String getCoordinates() { return coordinates; }
    public void setCoordinates(String coordinates) { this.coordinates = coordinates; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getSpecialDetails() { return specialDetails; }
    public void setSpecialDetails(String specialDetails) { this.specialDetails = specialDetails; }

    public LocalDateTime getSightingDate() { return sightingDate; }
    public void setSightingDate(LocalDateTime sightingDate) { this.sightingDate = sightingDate; }

    public String getPhotoName() { return photoName; }
    public void setPhotoName(String photoName) { this.photoName = photoName; }

    public byte[] getPhotoData() { return photoData; }
    public void setPhotoData(byte[] photoData) {
        this.photoData = photoData;
        // Automatically generate base64 photo when photoData is set
        if (photoData != null && photoData.length > 0) {
            this.base64Photo = Base64.getEncoder().encodeToString(photoData);
        } else {
            this.base64Photo = null;
        }
    }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    // Base64 Photo methods
    public String getBase64Photo() {
        if (base64Photo != null) {
            return base64Photo;
        }
        // Fallback: generate from photoData if base64Photo is null but photoData exists
        if (photoData != null && photoData.length > 0) {
            return Base64.getEncoder().encodeToString(photoData);
        }
        return null;
    }

    public void setBase64Photo(String base64Photo) {
        this.base64Photo = base64Photo;
    }

    // Helper method to check if photo exists
    public boolean hasPhoto() {
        return (photoData != null && photoData.length > 0) || base64Photo != null;
    }

    // Helper method to get photo data URL for HTML img src
    public String getPhotoDataUrl() {
        String base64 = getBase64Photo();
        if (base64 != null) {
            return "data:image/jpeg;base64," + base64;
        }
        return null;
    }
}