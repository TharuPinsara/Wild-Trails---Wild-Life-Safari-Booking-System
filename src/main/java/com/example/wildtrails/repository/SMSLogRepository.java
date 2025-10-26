package com.example.wildtrails.repository;

import com.example.wildtrails.module.SMSLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public interface SMSLogRepository extends JpaRepository<SMSLog, Long> {

    List<SMSLog> findByBookingId(String bookingId);

    List<SMSLog> findByRecipientPhone(String recipientPhone);

    List<SMSLog> findByRecipientType(String recipientType);

    List<SMSLog> findByBookingIdAndRecipientType(String bookingId, String recipientType);

    // FIXED: Returns int (number of rows deleted)
    @Modifying
    @Transactional
    @Query("DELETE FROM SMSLog sl WHERE sl.bookingId = :bookingId")
    int deleteByBookingId(@Param("bookingId") String bookingId);

    @Query("SELECT COUNT(sl) FROM SMSLog sl WHERE sl.bookingId = :bookingId")
    int countByBookingId(@Param("bookingId") String bookingId);

    @Query("SELECT sl FROM SMSLog sl WHERE sl.sentAt BETWEEN :startDate AND :endDate")
    List<SMSLog> findBySentAtBetween(@Param("startDate") java.time.LocalDateTime startDate,
                                     @Param("endDate") java.time.LocalDateTime endDate);

    List<SMSLog> findByStatus(String status);

    @Query("SELECT sl FROM SMSLog sl WHERE sl.recipientPhone = :phoneNumber ORDER BY sl.sentAt DESC")
    List<SMSLog> findByRecipientPhoneOrderBySentAtDesc(@Param("phoneNumber") String phoneNumber);
}