package com.example.wildtrails.repository;

import com.example.wildtrails.module.TourMoreInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Repository
public interface TourMoreInfoRepository extends JpaRepository<TourMoreInfo, Long> {
    Optional<TourMoreInfo> findByTourId(String tourId);
    boolean existsByTourId(String tourId);

    @Modifying
    @Transactional
    @Query("DELETE FROM TourMoreInfo t WHERE t.tourId = :tourId")
    void deleteByTourId(@Param("tourId") String tourId);
}