package com.example.wildtrails.repository;

import com.example.wildtrails.module.Vehicle;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface VehicleRepository extends JpaRepository<Vehicle, Long> {

    List<Vehicle> findByStatusOrderByVehicleNameAsc(String status);

    Optional<Vehicle> findByVehicleId(String vehicleId);

    boolean existsByVehicleId(String vehicleId);

    @Query("SELECT MAX(v.vehicleId) FROM Vehicle v WHERE v.vehicleId LIKE 'dri-%'")
    String findMaxVehicleId();

    Optional<Vehicle> findByDriverEmailAndStatus(String driverEmail, String status);

    List<Vehicle> findByStatus(String status);
    // NEW METHOD ADDED
    @Query("SELECT v FROM Vehicle v WHERE v.status = 'active' AND v.vehicleReady = true AND v.capacity >= :minCapacity")
    List<Vehicle> findAvailableVehiclesByCapacity(@Param("minCapacity") Integer minCapacity);
}