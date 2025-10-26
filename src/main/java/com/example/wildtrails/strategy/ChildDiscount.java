package com.example.wildtrails.strategy;

import org.springframework.stereotype.Component;

@Component
public class ChildDiscount implements PricingStrategy {

    @Override
    public double calculatePrice(double originalPrice) {
        return originalPrice * 0.5; // 50% discount
    }

    @Override
    public String getDiscountType() {
        return "Child";
    }

    @Override
    public double getDiscountPercentage() {
        return 50.0;
    }
}