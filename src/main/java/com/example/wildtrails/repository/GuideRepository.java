package com.example.wildtrails.repository;

import com.example.wildtrails.module.Guide;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface GuideRepository extends JpaRepository<Guide, Long> {

    List<Guide> findByStatusOrderByExperienceYearsDesc(String status);

    Optional<Guide> findByGuideId(String guideId);

    boolean existsByGuideId(String guideId);

    @Query("SELECT MAX(g.guideId) FROM Guide g WHERE g.guideId LIKE 'gui-%'")
    String findMaxGuideId();
}