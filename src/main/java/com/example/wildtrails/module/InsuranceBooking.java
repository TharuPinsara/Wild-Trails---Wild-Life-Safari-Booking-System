package com.example.wildtrails.module;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "insurance_booking")
public class InsuranceBooking {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "booking_id", unique = true, nullable = false)
    private String bookingId;

    @Column(name = "insurance_id", nullable = false)
    private String insuranceId;

    @Column(name = "company_name", nullable = false)
    private String companyName;

    @Column(name = "insurance_type", nullable = false)
    private String insuranceType;

    @Column(name = "coverage_type")
    private String coverageType;

    @Column(name = "price_per_day_per_person")
    private Double pricePerDayPerPerson;

    @Column(name = "total_insurance_cost", nullable = false)
    private Double totalInsuranceCost;

    @Column(name = "number_of_persons", nullable = false)
    private Integer numberOfPersons;

    @Column(name = "duration_days", nullable = false)
    private Integer durationDays;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    // Constructors
    public InsuranceBooking() {
        this.createdAt = LocalDateTime.now();
    }

    public InsuranceBooking(String bookingId, String insuranceId, String companyName,
                            String insuranceType, String coverageType, Double pricePerDayPerPerson,
                            Double totalInsuranceCost, Integer numberOfPersons, Integer durationDays) {
        this();
        this.bookingId = bookingId;
        this.insuranceId = insuranceId;
        this.companyName = companyName;
        this.insuranceType = insuranceType;
        this.coverageType = coverageType;
        this.pricePerDayPerPerson = pricePerDayPerPerson;
        this.totalInsuranceCost = totalInsuranceCost;
        this.numberOfPersons = numberOfPersons;
        this.durationDays = durationDays;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getBookingId() { return bookingId; }
    public void setBookingId(String bookingId) { this.bookingId = bookingId; }

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

    public Double getTotalInsuranceCost() { return totalInsuranceCost; }
    public void setTotalInsuranceCost(Double totalInsuranceCost) { this.totalInsuranceCost = totalInsuranceCost; }

    public Integer getNumberOfPersons() { return numberOfPersons; }
    public void setNumberOfPersons(Integer numberOfPersons) { this.numberOfPersons = numberOfPersons; }

    public Integer getDurationDays() { return durationDays; }
    public void setDurationDays(Integer durationDays) { this.durationDays = durationDays; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}