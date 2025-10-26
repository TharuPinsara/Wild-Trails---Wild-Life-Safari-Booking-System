package com.example.wildtrails.controller;

import com.example.wildtrails.module.User;
import com.example.wildtrails.repository.UserRepository;
import com.example.wildtrails.util.PasswordUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;
import java.util.Optional;

@Controller
public class UserController {

    @Autowired
    private UserRepository userRepository;

    @GetMapping("/userlogin/login")
    public String showLoginPage(HttpSession session) {
        // If user is already logged in, redirect to homepage
        if (session.getAttribute("userLoggedIn") != null) {
            return "redirect:/homepage/index.html";
        }
        return "userlogin/login";
    }

    @GetMapping("/userlogin/register")
    public String showRegisterPage(HttpSession session) {
        // If user is already logged in, redirect to homepage
        if (session.getAttribute("userLoggedIn") != null) {
            return "redirect:/homepage/index.html";
        }
        return "userlogin/register";
    }

    @PostMapping("/userlogin/register")
    public String registerUser(
            @RequestParam String firstName,
            @RequestParam String lastName,
            @RequestParam String userType,
            @RequestParam String phoneNumber,
            @RequestParam String address,
            @RequestParam String country,
            @RequestParam String email,
            @RequestParam String password,
            Model model) {

        // Check if user already exists
        if (userRepository.existsByEmail(email)) {
            model.addAttribute("error", "Email already registered!");
            return "userlogin/register";
        }

        // Encrypt password
        String encryptedPassword = PasswordUtil.encrypt(password);

        // Create new user
        User user = new User(firstName, lastName, userType, phoneNumber, address, country, email, encryptedPassword);
        userRepository.save(user);

        model.addAttribute("success", "Registration successful! Please login.");
        return "userlogin/login";
    }

    @PostMapping("/userlogin/login")
    public String loginUser(
            @RequestParam String email,
            @RequestParam String password,
            HttpSession session,
            Model model) {

        Optional<User> userOptional = userRepository.findByEmail(email);

        if (userOptional.isPresent()) {
            User user = userOptional.get();
            if (PasswordUtil.checkPassword(password, user.getPassword())) {
                // Login successful - create session
                session.setAttribute("userLoggedIn", true);
                session.setAttribute("userId", user.getId());
                session.setAttribute("userFirstName", user.getFirstName());
                session.setAttribute("userEmail", user.getEmail());
                session.setAttribute("userType", user.getUserType());

                // Redirect to homepage
                return "redirect:/homepage/index.html";
            }
        }

        model.addAttribute("error", "Invalid email or password!");
        return "userlogin/login";
    }

    @GetMapping("/userlogin/logout")
    public String logoutUser(HttpSession session) {
        // Invalidate session
        session.removeAttribute("userLoggedIn");
        session.removeAttribute("userId");
        session.removeAttribute("userFirstName");
        session.removeAttribute("userEmail");
        session.removeAttribute("userType");
        session.invalidate();

        return "redirect:/homepage/index.html";
    }

    @GetMapping("/userlogin/userinfo")
    public String showUserInfo(HttpSession session, Model model) {
        // Check if user is logged in
        if (session.getAttribute("userLoggedIn") == null) {
            return "redirect:/userlogin/login";
        }

        // Get user ID from session
        Long userId = (Long) session.getAttribute("userId");
        Optional<User> userOptional = userRepository.findById(userId);

        if (userOptional.isPresent()) {
            User user = userOptional.get();
            model.addAttribute("user", user);
            return "userlogin/userinfo";
        } else {
            // User not found in database, logout
            session.invalidate();
            return "redirect:/userlogin/login";
        }
    }
}