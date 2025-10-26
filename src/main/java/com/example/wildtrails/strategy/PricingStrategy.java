package com.example.wildtrails.strategy;

public interface PricingStrategy {
    double calculatePrice(double originalPrice);
    String getDiscountType();
    double getDiscountPercentage();
}