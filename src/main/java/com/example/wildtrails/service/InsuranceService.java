package com.example.wildtrails.service;

import com.example.wildtrails.module.Insurance;
import com.example.wildtrails.module.InsuranceBooking;
import com.example.wildtrails.module.TourMoreInfo;
import com.example.wildtrails.repository.InsuranceBookingRepository;
import com.example.wildtrails.repository.InsuranceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class InsuranceService {

    @Autowired
    private InsuranceRepository insuranceRepository;

    @Autowired
    private InsuranceBookingRepository insuranceBookingRepository;

    public List<Insurance> getAllActiveInsurance() {
        return insuranceRepository.findByStatusOrderByCompanyNameAsc("active");
    }

    public List<Insurance> getInsuranceByType(String type) {
        return insuranceRepository.findByInsuranceTypeAndStatusOrderByPricePerDayPerPersonAsc(type, "active");
    }

    public Optional<Insurance> getInsuranceById(String insuranceId) {
        return insuranceRepository.findByInsuranceId(insuranceId);
    }

    public Insurance saveInsurance(Insurance insurance) {
        // Generate insurance ID if not provided
        if (insurance.getInsuranceId() == null || insurance.getInsuranceId().isEmpty()) {
            insurance.setInsuranceId(generateInsuranceId());
        }
        return insuranceRepository.save(insurance);
    }

    public void deleteInsurance(String insuranceId) {
        // First delete the Insurance more info if it exists
        Optional<Insurance> moreInfoOptional = insuranceRepository.findByInsuranceId(insuranceId);
        moreInfoOptional.ifPresent(insuranceRepository::delete);

        // Then delete the Insurance
        insuranceRepository.deleteByInsuranceId(insuranceId);
    }

    private String generateInsuranceId() {
        String maxInsuranceId = insuranceRepository.findMaxInsuranceId();
        if (maxInsuranceId != null) {
            try {
                int lastNumber = Integer.parseInt(maxInsuranceId.replace("ins-", ""));
                return "ins-" + (lastNumber + 1);
            } catch (NumberFormatException e) {
                return "ins-1";
            }
        }
        return "ins-1";
    }

    public boolean deleteInsurancePermanently(String insuranceId) {
        Optional<Insurance> insuranceOptional = insuranceRepository.findByInsuranceId(insuranceId);
        if (insuranceOptional.isPresent()) {
            insuranceRepository.delete(insuranceOptional.get());
            return true;
        }
        return false;
    }

    // Get all insurance bookings
    public List<InsuranceBooking> getAllInsuranceBookings() {
        return insuranceBookingRepository.findAllByOrderByCreatedAtDesc();
    }

    // Admin authentication
    public boolean authenticateAdmin(String username, String password) {
        return "admin123".equals(username) && "pass123".equals(password);
    }
}