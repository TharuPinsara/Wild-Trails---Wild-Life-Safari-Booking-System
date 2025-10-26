package com.example.wildtrails.service;

import com.example.wildtrails.module.GuideSchedule;
import com.example.wildtrails.repository.GuideScheduleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class GuideScheduleService {

    @Autowired
    private GuideScheduleRepository guideScheduleRepository;

    public List<GuideSchedule> getSchedulesByGuideId(String guideId) {
        return guideScheduleRepository.findByGuideIdOrderByScheduleDateAsc(guideId);
    }

    public int getBookedSchedulesCount(String guideId) {
        return guideScheduleRepository.countByGuideIdAndStatus(guideId, "booked");
    }

    public int getUpcomingBookingsCount(String guideId) {
        LocalDate today = LocalDate.now();
        return guideScheduleRepository.countByGuideIdAndStatusAndScheduleDateGreaterThanEqual(
                guideId, "booked", today);
    }

    public int getThisMonthBookingsCount(String guideId) {
        LocalDate startOfMonth = LocalDate.now().withDayOfMonth(1);
        LocalDate endOfMonth = startOfMonth.plusMonths(1).minusDays(1);
        return guideScheduleRepository.countByGuideIdAndStatusAndScheduleDateBetween(
                guideId, "booked", startOfMonth, endOfMonth);
    }

    // Add other schedule-related methods as needed
}