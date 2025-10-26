package com.example.wildtrails.repository;

import com.example.wildtrails.module.Insurance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Repository
public interface InsuranceRepository extends JpaRepository<Insurance, Long> {
    List<Insurance> findByStatusOrderByCompanyNameAsc(String status);
    List<Insurance> findByInsuranceTypeAndStatusOrderByPricePerDayPerPersonAsc(String insuranceType, String status);
    Optional<Insurance> findByInsuranceId(String insuranceId);

    @Query("SELECT MAX(i.insuranceId) FROM Insurance i WHERE i.insuranceId LIKE 'ins-%'")
    String findMaxInsuranceId();

    boolean existsByInsuranceId(String insuranceId);
    @Modifying
    @Transactional
    @Query("DELETE FROM Insurance ins WHERE ins.insuranceId = :insuranceId")
    void deleteByInsuranceId(@Param("insuranceId") String insuranceId);
    // Additional method if needed
    List<Insurance> findByStatus(String status);
}