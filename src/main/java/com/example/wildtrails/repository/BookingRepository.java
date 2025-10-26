package com.example.wildtrails.repository;

import com.example.wildtrails.module.Booking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface BookingRepository extends JpaRepository<Booking, Long> {
    Optional<Booking> findByBookingId(String bookingId);
    List<Booking> findByUserIdOrderByCreatedAtDesc(Long userId);
    List<Booking> findByTourId(String tourId);

    @Query("SELECT MAX(b.bookingId) FROM Booking b WHERE b.bookingId LIKE 'book-%'")
    String findMaxBookingId();

    boolean existsByBookingId(String bookingId);
}