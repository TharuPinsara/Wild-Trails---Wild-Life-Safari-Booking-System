package com.example.wildtrails.module;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "insurance")
public class Insurance {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "insurance_id", unique = true, nullable = false)
    private String insuranceId;

    @Column(name = "company_name", nullable = false)
    private String companyName;

    @Column(name = "insurance_type", nullable = false)
    private String insuranceType; // foreign or local

    @Column(name = "coverage_type", nullable = false)
    private String coverageType; // full, half, basic, premium

    @Column(name = "price_per_day_per_person", nullable = false)
    private Double pricePerDayPerPerson;

    @Column(name = "max_days", nullable = false)
    private Integer maxDays;

    @Column(name = "description", length = 1000)
    private String description;

    @Column(name = "special_features", length = 1000)
    private String specialFeatures;

    @Column(name = "status")
    private String status = "active";

    @Column(name = "created_date")
    private LocalDateTime createdDate;

    @Column(name = "updated_date")
    private LocalDateTime updatedDate;

    // Constructors
    public Insurance() {
        this.createdDate = LocalDateTime.now();
        this.updatedDate = LocalDateTime.now();
    }

    public Insurance(String insuranceId, String companyName, String insuranceType,
                     String coverageType, Double pricePerDayPerPerson, Integer maxDays,
                     String description, String specialFeatures) {
        this();
        this.insuranceId = insuranceId;
        this.companyName = companyName;
        this.insuranceType = insuranceType;
        this.coverageType = coverageType;
        this.pricePerDayPerPerson = pricePerDayPerPerson;
        this.maxDays = maxDays;
        this.description = description;
        this.specialFeatures = specialFeatures;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getInsuranceId() { return insuranceId; }
    public void setInsuranceId(String insuranceId) { this.insuranceId = insuranceId; }

    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }

    public String getInsuranceType() { return insuranceType; }
    public void setInsuranceType(String insuranceType) { this.insuranceType = insuranceType; }

    public String getCoverageType() { return coverageType; }
    public void setCoverageType(String coverageType) { this.coverageType = coverageType; }

    public Double getPricePerDayPerPerson() { return pricePerDayPerPerson; }
    public void setPricePerDayPerPerson(Double pricePerDayPerPerson) { this.pricePerDayPerPerson = pricePerDayPerPerson; }

    public Integer getMaxDays() { return maxDays; }
    public void setMaxDays(Integer maxDays) { this.maxDays = maxDays; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getSpecialFeatures() { return specialFeatures; }
    public void setSpecialFeatures(String specialFeatures) { this.specialFeatures = specialFeatures; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedDate() { return createdDate; }
    public void setCreatedDate(LocalDateTime createdDate) { this.createdDate = createdDate; }

    public LocalDateTime getUpdatedDate() { return updatedDate; }
    public void setUpdatedDate(LocalDateTime updatedDate) { this.updatedDate = updatedDate; }

    @PreUpdate
    public void setUpdatedDate() {
        this.updatedDate = LocalDateTime.now();
    }
}