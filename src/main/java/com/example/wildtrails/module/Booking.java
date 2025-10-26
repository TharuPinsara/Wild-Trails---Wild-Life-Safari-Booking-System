package com.example.wildtrails.module;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;

@Entity
@Table(name = "bookings")
public class Booking {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "booking_id", unique = true, nullable = false)
    private String bookingId;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "tour_id", nullable = false)
    private String tourId;

    @Column(name = "trip_date", nullable = false)
    private LocalDate tripDate;

    @Column(name = "duration_days", nullable = false)
    private Integer durationDays;

    @Column(name = "number_of_persons", nullable = false)
    private Integer numberOfPersons;

    @Column(name = "selected_vehicles", columnDefinition = "TEXT")
    private String selectedVehicles;

    @Column(name = "selected_guide_id")
    private String selectedGuideId;

    @Column(name = "insurance_plan")
    private String insurancePlan;

    @Column(name = "special_requirements", columnDefinition = "TEXT")
    private String specialRequirements;

    @Column(name = "total_amount", nullable = false)
    private Double totalAmount;

    @Column(name = "status")
    private String status = "confirmed";

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "discount_type")
    private String discountType = "Loyalty";

    @Column(name = "number_of_adults")
    private Integer numberOfAdults;

    @Column(name = "number_of_children")
    private Integer numberOfChildren;

    @Column(name = "number_of_students")
    private Integer numberOfStudents;

    // Helper methods for JSP compatibility
    public Date getCreatedAtAsDate() {
        return java.sql.Timestamp.valueOf(createdAt);
    }

    public Date getTripDateAsDate() {
        return java.sql.Date.valueOf(tripDate);
    }

    // Remove the problematic relationships for now to fix the immediate error
    // We'll load these separately through service methods

    @Transient
    private User user;

    @Transient
    private Tour tour;

    @Transient
    private Guide guide;

    // Constructors
    public Booking() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
        this.status = "confirmed";
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getBookingId() { return bookingId; }
    public void setBookingId(String bookingId) { this.bookingId = bookingId; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getTourId() { return tourId; }
    public void setTourId(String tourId) { this.tourId = tourId; }

    public LocalDate getTripDate() { return tripDate; }
    public void setTripDate(LocalDate tripDate) { this.tripDate = tripDate; }

    public Integer getDurationDays() { return durationDays; }
    public void setDurationDays(Integer durationDays) { this.durationDays = durationDays; }

    public Integer getNumberOfPersons() { return numberOfPersons; }
    public void setNumberOfPersons(Integer numberOfPersons) { this.numberOfPersons = numberOfPersons; }

    public String getSelectedVehicles() { return selectedVehicles; }
    public void setSelectedVehicles(String selectedVehicles) { this.selectedVehicles = selectedVehicles; }

    public String getSelectedGuideId() { return selectedGuideId; }
    public void setSelectedGuideId(String selectedGuideId) { this.selectedGuideId = selectedGuideId; }

    public String getInsurancePlan() { return insurancePlan; }
    public void setInsurancePlan(String insurancePlan) { this.insurancePlan = insurancePlan; }

    public String getSpecialRequirements() { return specialRequirements; }
    public void setSpecialRequirements(String specialRequirements) { this.specialRequirements = specialRequirements; }

    public Double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(Double totalAmount) { this.totalAmount = totalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public Tour getTour() { return tour; }
    public void setTour(Tour tour) { this.tour = tour; }

    public Guide getGuide() { return guide; }
    public void setGuide(Guide guide) { this.guide = guide; }

    @PreUpdate
    public void setUpdatedAt() {
        this.updatedAt = LocalDateTime.now();
    }

    @Override
    public String toString() {
        return "Booking{" +
                "id=" + id +
                ", bookingId='" + bookingId + '\'' +
                ", userId=" + userId +
                ", tourId='" + tourId + '\'' +
                ", tripDate=" + tripDate +
                ", durationDays=" + durationDays +
                ", numberOfPersons=" + numberOfPersons +
                ", selectedVehicles='" + selectedVehicles + '\'' +
                ", selectedGuideId='" + selectedGuideId + '\'' +
                ", insurancePlan='" + insurancePlan + '\'' +
                ", specialRequirements='" + specialRequirements + '\'' +
                ", totalAmount=" + totalAmount +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
    public String getDiscountType() { return discountType; }
    public void setDiscountType(String discountType) { this.discountType = discountType; }
    public Integer getNumberOfAdults() { return numberOfAdults; }
    public void setNumberOfAdults(Integer numberOfAdults) { this.numberOfAdults = numberOfAdults; }

    public Integer getNumberOfChildren() { return numberOfChildren; }
    public void setNumberOfChildren(Integer numberOfChildren) { this.numberOfChildren = numberOfChildren; }

    public Integer getNumberOfStudents() { return numberOfStudents; }
    public void setNumberOfStudents(Integer numberOfStudents) { this.numberOfStudents = numberOfStudents; }

}