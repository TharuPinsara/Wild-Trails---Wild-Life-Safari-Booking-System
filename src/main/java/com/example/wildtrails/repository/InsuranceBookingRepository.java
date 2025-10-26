package com.example.wildtrails.repository;

import com.example.wildtrails.module.InsuranceBooking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public interface InsuranceBookingRepository extends JpaRepository<InsuranceBooking, Long> {
    List<InsuranceBooking> findAllByOrderByCreatedAtDesc();
    List<InsuranceBooking> findByInsuranceId(String insuranceId);

}