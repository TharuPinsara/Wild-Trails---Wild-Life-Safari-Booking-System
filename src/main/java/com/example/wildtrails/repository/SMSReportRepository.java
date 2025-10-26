// File: SMSReportRepository.java
package com.example.wildtrails.repository;

import com.example.wildtrails.module.SMSReport;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Repository
public interface SMSReportRepository extends JpaRepository<SMSReport, Long> {

    Optional<SMSReport> findByReportId(String reportId);

    List<SMSReport> findByUserIdOrderByCreatedAtDesc(Long userId);

    List<SMSReport> findByStatusOrderByRequestDateAsc(String status);

    List<SMSReport> findByBookingId(Long bookingId);

    List<SMSReport> findAllByOrderByCreatedAtDesc();

    @Query("SELECT MAX(s.reportId) FROM SMSReport s WHERE s.reportId LIKE 'rep-%'")
    String findMaxReportId();

    @Query("SELECT COUNT(s) FROM SMSReport s WHERE s.status = :status")
    Long countByStatus(@Param("status") String status);

    @Query("SELECT COUNT(s) FROM SMSReport s WHERE s.status = 'GENERATED'")
    Long countGeneratedReports();

    boolean existsByReportId(String reportId);

    @Modifying
    @Transactional
    @Query("DELETE FROM SMSReport s WHERE s.reportId = :reportId")
    void deleteByReportId(@Param("reportId") String reportId);
}