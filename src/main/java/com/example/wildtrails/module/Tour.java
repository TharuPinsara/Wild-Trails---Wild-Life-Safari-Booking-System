package com.example.wildtrails.module;

import jakarta.persistence.*;
import org.springframework.web.multipart.MultipartFile;

@Entity
@Table(name = "tours")
public class Tour {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "tour_id", unique = true, nullable = false)
    private String tourId;

    @Column(name = "tour_name", nullable = false)
    private String tourName;

    @Column(name = "duration_days", nullable = false)
    private Integer durationDays;

    @Column(name = "destination", nullable = false)
    private String destination;

    @Column(name = "price", nullable = false)
    private Double price;

    @Column(name = "includes_breakfast")
    private Boolean includesBreakfast = false;

    @Column(name = "includes_lunch")
    private Boolean includesLunch = false;

    @Column(name = "includes_dinner")
    private Boolean includesDinner = false;

    @Column(name = "special_features", columnDefinition = "TEXT")
    private String specialFeatures;

    @Column(name = "tour_photo_name")
    private String tourPhotoName;

    @Column(name = "tour_photo_data", columnDefinition = "VARBINARY(MAX)")
    private byte[] tourPhotoData;

    @Column(name = "status")
    private String status = "active";

    @Transient
    private MultipartFile tourPhotoFile;

    // Constructors
    public Tour() {}

    public Tour(String tourId, String tourName, Integer durationDays, String destination,
                Double price, Boolean includesBreakfast, Boolean includesLunch,
                Boolean includesDinner, String specialFeatures, String status) {
        this.tourId = tourId;
        this.tourName = tourName;
        this.durationDays = durationDays;
        this.destination = destination;
        this.price = price;
        this.includesBreakfast = includesBreakfast;
        this.includesLunch = includesLunch;
        this.includesDinner = includesDinner;
        this.specialFeatures = specialFeatures;
        this.status = status;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTourId() { return tourId; }
    public void setTourId(String tourId) { this.tourId = tourId; }

    public String getTourName() { return tourName; }
    public void setTourName(String tourName) { this.tourName = tourName; }

    public Integer getDurationDays() { return durationDays; }
    public void setDurationDays(Integer durationDays) { this.durationDays = durationDays; }

    public String getDestination() { return destination; }
    public void setDestination(String destination) { this.destination = destination; }

    public Double getPrice() { return price; }
    public void setPrice(Double price) { this.price = price; }

    public Boolean getIncludesBreakfast() { return includesBreakfast; }
    public void setIncludesBreakfast(Boolean includesBreakfast) { this.includesBreakfast = includesBreakfast; }

    public Boolean getIncludesLunch() { return includesLunch; }
    public void setIncludesLunch(Boolean includesLunch) { this.includesLunch = includesLunch; }

    public Boolean getIncludesDinner() { return includesDinner; }
    public void setIncludesDinner(Boolean includesDinner) { this.includesDinner = includesDinner; }

    public String getSpecialFeatures() { return specialFeatures; }
    public void setSpecialFeatures(String specialFeatures) { this.specialFeatures = specialFeatures; }

    public String getTourPhotoName() { return tourPhotoName; }
    public void setTourPhotoName(String tourPhotoName) { this.tourPhotoName = tourPhotoName; }

    public byte[] getTourPhotoData() { return tourPhotoData; }
    public void setTourPhotoData(byte[] tourPhotoData) { this.tourPhotoData = tourPhotoData; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public MultipartFile getTourPhotoFile() { return tourPhotoFile; }
    public void setTourPhotoFile(MultipartFile tourPhotoFile) { this.tourPhotoFile = tourPhotoFile; }
}