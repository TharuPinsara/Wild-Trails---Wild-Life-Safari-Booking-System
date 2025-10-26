package com.example.wildtrails.module;

import jakarta.persistence.*;
import org.springframework.web.multipart.MultipartFile;

@Entity
@Table(name = "guidesinfo")
public class Guide {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "guide_id", unique = true, nullable = false)
    private String guideId;

    @Column(name = "name", nullable = false)
    private String name;

    @Column(name = "phone_number", nullable = false)
    private String phoneNumber;

    @Column(name = "email")
    private String email;

    @Column(name = "experience_years", nullable = false)
    private Integer experienceYears;

    @Column(name = "specialization")
    private String specialization;

    @Column(name = "languages")
    private String languages;

    @Column(name = "daily_rate", nullable = false)
    private Double dailyRate;

    @Column(name = "available_trips")
    private String availableTrips;

    @Column(name = "opportunities", columnDefinition = "TEXT")
    private String opportunities;

    @Column(name = "status")
    private String status = "active";

    @Column(name = "photo_name")
    private String photoName;

    @Column(name = "photo_data", columnDefinition = "VARBINARY(MAX)")
    private byte[] photoData;

    @Column(name = "password", nullable = false)
    private String password;

    @Transient
    private MultipartFile photoFile;

    @Transient
    private String plainPassword; // ADD THIS FIELD

    // Default constructor
    public Guide() {}

    // Parameterized constructor
    public Guide(String guideId, String name, String phoneNumber, String email,
                 Integer experienceYears, String specialization, String languages,
                 Double dailyRate, String availableTrips, String opportunities,
                 String status, String password) {
        this.guideId = guideId;
        this.name = name;
        this.phoneNumber = phoneNumber;
        this.email = email;
        this.experienceYears = experienceYears;
        this.specialization = specialization;
        this.languages = languages;
        this.dailyRate = dailyRate;
        this.availableTrips = availableTrips;
        this.opportunities = opportunities;
        this.status = status;
        this.password = password;
    }

    // Getters and Setters (keep all existing and add the new one)
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getGuideId() { return guideId; }
    public void setGuideId(String guideId) { this.guideId = guideId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public Integer getExperienceYears() { return experienceYears; }
    public void setExperienceYears(Integer experienceYears) { this.experienceYears = experienceYears; }

    public String getSpecialization() { return specialization; }
    public void setSpecialization(String specialization) { this.specialization = specialization; }

    public String getLanguages() { return languages; }
    public void setLanguages(String languages) { this.languages = languages; }

    public Double getDailyRate() { return dailyRate; }
    public void setDailyRate(Double dailyRate) { this.dailyRate = dailyRate; }

    public String getAvailableTrips() { return availableTrips; }
    public void setAvailableTrips(String availableTrips) { this.availableTrips = availableTrips; }

    public String getOpportunities() { return opportunities; }
    public void setOpportunities(String opportunities) { this.opportunities = opportunities; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getPhotoName() { return photoName; }
    public void setPhotoName(String photoName) { this.photoName = photoName; }

    public byte[] getPhotoData() { return photoData; }
    public void setPhotoData(byte[] photoData) { this.photoData = photoData; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public MultipartFile getPhotoFile() { return photoFile; }
    public void setPhotoFile(MultipartFile photoFile) { this.photoFile = photoFile; }

    public String getPlainPassword() { return plainPassword; } // ADD THIS GETTER
    public void setPlainPassword(String plainPassword) { this.plainPassword = plainPassword; } // ADD THIS SETTER
}