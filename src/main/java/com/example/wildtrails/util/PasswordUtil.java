package com.example.wildtrails.util;

import java.util.Base64;

public class PasswordUtil {

    // Simple encryption using Base64 (for demonstration purposes)
    // In production, use proper password hashing like BCrypt
    public static String encrypt(String password) {
        return Base64.getEncoder().encodeToString(password.getBytes());
    }

    public static String decrypt(String encryptedPassword) {
        byte[] decodedBytes = Base64.getDecoder().decode(encryptedPassword);
        return new String(decodedBytes);
    }

    public static boolean checkPassword(String plainPassword, String encryptedPassword) {
        return encrypt(plainPassword).equals(encryptedPassword);
    }
}