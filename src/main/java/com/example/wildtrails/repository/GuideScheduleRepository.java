package com.example.wildtrails.repository;

import com.example.wildtrails.module.GuideSchedule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface GuideScheduleRepository extends JpaRepository<GuideSchedule, Long> {

    List<GuideSchedule> findByGuideIdAndScheduleDate(String guideId, LocalDate scheduleDate);

    List<GuideSchedule> findByGuideIdAndScheduleDateAndStatus(String guideId, LocalDate scheduleDate, String status);

    List<GuideSchedule> findByGuideIdAndScheduleDateBetween(String guideId, LocalDate startDate, LocalDate endDate);

    List<GuideSchedule> findByBookingId(String bookingId);

    @Modifying
    @Transactional
    @Query("UPDATE GuideSchedule gs SET gs.status = :status WHERE gs.bookingId = :bookingId")
    void updateStatusByBookingId(@Param("bookingId") String bookingId, @Param("status") String status);

    List<GuideSchedule> findByGuideId(String guideId);

    List<GuideSchedule> findByGuideIdAndStatus(String guideId, String status);

    @Query("SELECT COUNT(gs) > 0 FROM GuideSchedule gs WHERE gs.guideId = :guideId AND gs.scheduleDate BETWEEN :startDate AND :endDate AND gs.status = 'booked'")
    boolean isGuideBookedBetweenDates(@Param("guideId") String guideId,
                                      @Param("startDate") LocalDate startDate,
                                      @Param("endDate") LocalDate endDate);

    List<GuideSchedule> findByBookingIdAndGuideId(String bookingId, String guideId);

    @Query("SELECT gs FROM GuideSchedule gs WHERE gs.guideId = :guideId AND gs.scheduleDate BETWEEN :startDate AND :endDate AND gs.status = 'booked'")
    List<GuideSchedule> findOverlappingSchedules(@Param("guideId") String guideId,
                                                 @Param("startDate") LocalDate startDate,
                                                 @Param("endDate") LocalDate endDate);

    // FIXED: Returns int (number of rows deleted)
    @Modifying
    @Transactional
    @Query("DELETE FROM GuideSchedule gs WHERE gs.bookingId = :bookingId")
    int deleteByBookingId(@Param("bookingId") String bookingId);

    @Query("SELECT gs FROM GuideSchedule gs WHERE gs.guideId = :guideId AND gs.scheduleDate BETWEEN :startDate AND :endDate")
    List<GuideSchedule> findByGuideIdAndDateRange(@Param("guideId") String guideId,
                                                  @Param("startDate") LocalDate startDate,
                                                  @Param("endDate") LocalDate endDate);

    List<GuideSchedule> findByGuideIdOrderByScheduleDateAsc(String guideId);

    int countByGuideIdAndStatus(String guideId, String status);

    int countByGuideIdAndStatusAndScheduleDateGreaterThanEqual(String guideId, String status, LocalDate scheduleDate);

    int countByGuideIdAndStatusAndScheduleDateBetween(String guideId, String status, LocalDate startDate, LocalDate endDate);
}