package com.example.wildtrails.service;

import com.example.wildtrails.strategy.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class DiscountService {

    @Autowired
    private ChildDiscount childDiscount;

    @Autowired
    private StudentDiscount studentDiscount;

    @Autowired
    private NoDiscount noDiscount;

    public PricingStrategy getStrategy(String discountType) {
        if (discountType == null) {
            return noDiscount;
        }

        switch (discountType.toLowerCase()) {
            case "child":
                return childDiscount;
            case "student":
                return studentDiscount;
            default:
                return noDiscount;
        }
    }

    public double calculateDiscountedPrice(double originalPrice, String discountType) {
        PricingStrategy strategy = getStrategy(discountType);
        return strategy.calculatePrice(originalPrice);
    }
}