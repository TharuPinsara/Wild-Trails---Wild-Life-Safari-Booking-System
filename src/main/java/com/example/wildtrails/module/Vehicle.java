package com.example.wildtrails.module;

import jakarta.persistence.*;
import org.springframework.web.multipart.MultipartFile;

@Entity
@Table(name = "vehicles")
public class Vehicle {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "vehicle_id", unique = true, nullable = false)
    private String vehicleId;

    @Column(name = "driver_name", nullable = false)
    private String driverName;

    @Column(name = "driver_phone", nullable = false)
    private String driverPhone;

    @Column(name = "driver_email")
    private String driverEmail;

    @Column(name = "driver_password", nullable = false)
    private String driverPassword;

    @Column(name = "vehicle_name", nullable = false)
    private String vehicleName;

    @Column(name = "vehicle_type", nullable = false)
    private String vehicleType;

    @Column(name = "capacity")
    private Integer capacity = 4;

    @Column(name = "vehicle_ready")
    private Boolean vehicleReady = true;

    @Column(name = "inclusions")
    private String inclusions;

    @Column(name = "daily_rate", nullable = false)
    private Double dailyRate;

    @Column(name = "special_features", columnDefinition = "TEXT")
    private String specialFeatures;

    @Column(name = "driver_photo_name")
    private String driverPhotoName;

    @Column(name = "driver_photo_data", columnDefinition = "VARBINARY(MAX)")
    private byte[] driverPhotoData;

    @Column(name = "vehicle_photo_name")
    private String vehiclePhotoName;

    @Column(name = "vehicle_photo_data", columnDefinition = "VARBINARY(MAX)")
    private byte[] vehiclePhotoData;

    @Column(name = "status")
    private String status = "active";

    // Transient fields for form handling
    @Transient
    private MultipartFile driverPhotoFile;

    @Transient
    private MultipartFile vehiclePhotoFile;

    @Transient
    private String plainPassword;

    // Constructors
    public Vehicle() {}

    public Vehicle(String vehicleId, String driverName, String driverPhone, String driverEmail,
                   String vehicleName, String vehicleType, Integer capacity, Double dailyRate) {
        this.vehicleId = vehicleId;
        this.driverName = driverName;
        this.driverPhone = driverPhone;
        this.driverEmail = driverEmail;
        this.vehicleName = vehicleName;
        this.vehicleType = vehicleType;
        this.capacity = capacity;
        this.dailyRate = dailyRate;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getVehicleId() { return vehicleId; }
    public void setVehicleId(String vehicleId) { this.vehicleId = vehicleId; }

    public String getDriverName() { return driverName; }
    public void setDriverName(String driverName) { this.driverName = driverName; }

    public String getDriverPhone() { return driverPhone; }
    public void setDriverPhone(String driverPhone) { this.driverPhone = driverPhone; }

    public String getDriverEmail() { return driverEmail; }
    public void setDriverEmail(String driverEmail) { this.driverEmail = driverEmail; }

    public String getDriverPassword() { return driverPassword; }
    public void setDriverPassword(String driverPassword) { this.driverPassword = driverPassword; }

    public String getVehicleName() { return vehicleName; }
    public void setVehicleName(String vehicleName) { this.vehicleName = vehicleName; }

    public String getVehicleType() { return vehicleType; }
    public void setVehicleType(String vehicleType) { this.vehicleType = vehicleType; }

    public Integer getCapacity() { return capacity; }
    public void setCapacity(Integer capacity) { this.capacity = capacity; }

    public Boolean getVehicleReady() { return vehicleReady; }
    public void setVehicleReady(Boolean vehicleReady) { this.vehicleReady = vehicleReady; }

    public String getInclusions() { return inclusions; }
    public void setInclusions(String inclusions) { this.inclusions = inclusions; }

    public Double getDailyRate() { return dailyRate; }
    public void setDailyRate(Double dailyRate) { this.dailyRate = dailyRate; }

    public String getSpecialFeatures() { return specialFeatures; }
    public void setSpecialFeatures(String specialFeatures) { this.specialFeatures = specialFeatures; }

    public String getDriverPhotoName() { return driverPhotoName; }
    public void setDriverPhotoName(String driverPhotoName) { this.driverPhotoName = driverPhotoName; }

    public byte[] getDriverPhotoData() { return driverPhotoData; }
    public void setDriverPhotoData(byte[] driverPhotoData) { this.driverPhotoData = driverPhotoData; }

    public String getVehiclePhotoName() { return vehiclePhotoName; }
    public void setVehiclePhotoName(String vehiclePhotoName) { this.vehiclePhotoName = vehiclePhotoName; }

    public byte[] getVehiclePhotoData() { return vehiclePhotoData; }
    public void setVehiclePhotoData(byte[] vehiclePhotoData) { this.vehiclePhotoData = vehiclePhotoData; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public MultipartFile getDriverPhotoFile() { return driverPhotoFile; }
    public void setDriverPhotoFile(MultipartFile driverPhotoFile) { this.driverPhotoFile = driverPhotoFile; }

    public MultipartFile getVehiclePhotoFile() { return vehiclePhotoFile; }
    public void setVehiclePhotoFile(MultipartFile vehiclePhotoFile) { this.vehiclePhotoFile = vehiclePhotoFile; }

    public String getPlainPassword() { return plainPassword; }
    public void setPlainPassword(String plainPassword) { this.plainPassword = plainPassword; }
}