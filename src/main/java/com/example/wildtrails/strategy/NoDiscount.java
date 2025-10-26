package com.example.wildtrails.strategy;

import org.springframework.stereotype.Component;

@Component
public class NoDiscount implements PricingStrategy {

    @Override
    public double calculatePrice(double originalPrice) {
        return originalPrice; // No discount
    }

    @Override
    public String getDiscountType() {
        return "Regular";
    }

    @Override
    public double getDiscountPercentage() {
        return 0.0;
    }
}