package com.example.wildtrails.repository;

import com.example.wildtrails.module.VehicleSchedule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface VehicleScheduleRepository extends JpaRepository<VehicleSchedule, Long> {

    @Modifying
    @Transactional
    @Query("UPDATE VehicleSchedule vs SET vs.status = :status WHERE vs.bookingId = :bookingId")
    void updateStatusByBookingId(@Param("bookingId") String bookingId, @Param("status") String status);

    // FIXED: Returns int (number of rows deleted)
    @Modifying
    @Transactional
    @Query("DELETE FROM VehicleSchedule vs WHERE vs.bookingId = :bookingId")
    int deleteByBookingId(@Param("bookingId") String bookingId);

    List<VehicleSchedule> findByVehicleIdAndScheduleDate(String vehicleId, LocalDate scheduleDate);
    List<VehicleSchedule> findByVehicleIdAndScheduleDateAndStatus(String vehicleId, LocalDate scheduleDate, String status);
    List<VehicleSchedule> findByVehicleIdAndScheduleDateBetween(String vehicleId, LocalDate startDate, LocalDate endDate);
    List<VehicleSchedule> findByVehicleIdAndScheduleDateBetweenAndStatus(String vehicleId, LocalDate startDate, LocalDate endDate, String status);
    List<VehicleSchedule> findByScheduleDate(LocalDate scheduleDate);
    List<VehicleSchedule> findByScheduleDateAndStatus(LocalDate scheduleDate, String status);
    List<VehicleSchedule> findByBookingId(String bookingId);
    List<VehicleSchedule> findByVehicleId(String vehicleId);
    List<VehicleSchedule> findByStatus(String status);

    @Query("SELECT COUNT(vs) > 0 FROM VehicleSchedule vs WHERE vs.vehicleId = :vehicleId AND vs.scheduleDate BETWEEN :startDate AND :endDate AND vs.status = 'booked'")
    boolean isVehicleBookedBetweenDates(@Param("vehicleId") String vehicleId,
                                        @Param("startDate") LocalDate startDate,
                                        @Param("endDate") LocalDate endDate);

    @Query("SELECT vs.scheduleDate FROM VehicleSchedule vs WHERE vs.vehicleId = :vehicleId AND vs.scheduleDate BETWEEN :startDate AND :endDate AND vs.status = 'booked'")
    List<LocalDate> findBookedDatesForVehicle(@Param("vehicleId") String vehicleId,
                                              @Param("startDate") LocalDate startDate,
                                              @Param("endDate") LocalDate endDate);

    @Query("SELECT vs FROM VehicleSchedule vs WHERE vs.vehicleId = :vehicleId AND vs.scheduleDate BETWEEN :startDate AND :endDate AND vs.status = 'booked'")
    List<VehicleSchedule> findOverlappingSchedules(@Param("vehicleId") String vehicleId,
                                                   @Param("startDate") LocalDate startDate,
                                                   @Param("endDate") LocalDate endDate);

    @Query("SELECT DISTINCT v FROM Vehicle v WHERE v.status = 'active' AND v.vehicleReady = true AND v.vehicleId NOT IN " +
            "(SELECT vs.vehicleId FROM VehicleSchedule vs WHERE vs.scheduleDate BETWEEN :startDate AND :endDate AND vs.status = 'booked')")
    List<com.example.wildtrails.module.Vehicle> findAvailableVehicles(@Param("startDate") LocalDate startDate,
                                                                      @Param("endDate") LocalDate endDate);

    @Query("SELECT DISTINCT v FROM Vehicle v WHERE v.status = 'active' AND v.vehicleReady = true AND v.capacity >= :requiredCapacity AND v.vehicleId NOT IN " +
            "(SELECT vs.vehicleId FROM VehicleSchedule vs WHERE vs.scheduleDate BETWEEN :startDate AND :endDate AND vs.status = 'booked')")
    List<com.example.wildtrails.module.Vehicle> findAvailableVehiclesWithCapacity(@Param("startDate") LocalDate startDate,
                                                                                  @Param("endDate") LocalDate endDate,
                                                                                  @Param("requiredCapacity") Integer requiredCapacity);

    @Query("SELECT COUNT(vs) FROM VehicleSchedule vs WHERE vs.vehicleId = :vehicleId AND YEAR(vs.scheduleDate) = :year AND MONTH(vs.scheduleDate) = :month AND vs.status = 'booked'")
    Long countBookedDaysInMonth(@Param("vehicleId") String vehicleId,
                                @Param("year") int year,
                                @Param("month") int month);

    List<VehicleSchedule> findByVehicleIdAndStatus(String vehicleId, String status);

    @Query("SELECT vs FROM VehicleSchedule vs WHERE vs.vehicleId IN :vehicleIds AND vs.scheduleDate BETWEEN :startDate AND :endDate")
    List<VehicleSchedule> findByVehicleIdsAndDateRange(@Param("vehicleIds") List<String> vehicleIds,
                                                       @Param("startDate") LocalDate startDate,
                                                       @Param("endDate") LocalDate endDate);

    @Query("SELECT vs.vehicleId FROM VehicleSchedule vs WHERE vs.vehicleId IN :vehicleIds AND vs.scheduleDate BETWEEN :startDate AND :endDate AND vs.status = 'booked'")
    List<String> findBookedVehicleIds(@Param("vehicleIds") List<String> vehicleIds,
                                      @Param("startDate") LocalDate startDate,
                                      @Param("endDate") LocalDate endDate);
}