package com.example.wildtrails.strategy;

import org.springframework.stereotype.Component;

@Component
public class StudentDiscount implements PricingStrategy {

    @Override
    public double calculatePrice(double originalPrice) {
        return originalPrice * 0.8; // 20% discount
    }

    @Override
    public String getDiscountType() {
        return "Student";
    }

    @Override
    public double getDiscountPercentage() {
        return 20.0;
    }
}