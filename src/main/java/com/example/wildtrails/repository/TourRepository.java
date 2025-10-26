package com.example.wildtrails.repository;

import com.example.wildtrails.module.Tour;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Repository
public interface TourRepository extends JpaRepository<Tour, Long> {

    List<Tour> findByStatusOrderByTourNameAsc(String status);

    Optional<Tour> findByTourId(String tourId);

    boolean existsByTourId(String tourId);

    @Query("SELECT MAX(t.tourId) FROM Tour t WHERE t.tourId LIKE 'tour-%'")
    String findMaxTourId();

    @Modifying
    @Transactional
    @Query("DELETE FROM Tour t WHERE t.tourId = :tourId")
    void deleteByTourId(@Param("tourId") String tourId);
}