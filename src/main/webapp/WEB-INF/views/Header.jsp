<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Header</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Load Font Awesome CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Raleway:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        .header-nav {
            font-family: 'Raleway', sans-serif;
        }
        .logo-text {
            font-family: 'Playfair Display', serif;
        }

        /* Dropdown styles */
        .dropdown {
            position: relative;
        }

        .dropdown-menu {
            display: none;
            position: absolute;
            right: 0;
            top: 100%;
            margin-top: 4px;
            z-index: 1000;
        }

        .dropdown-menu.show {
            display: block;
        }

        /* My Bookings button styles */
        .my-bookings-btn {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 8px 12px;
        }

        .my-bookings-text {
            font-size: 12px;
            margin-top: 2px;
            line-height: 1;
        }
    </style>
</head>
<body>
<nav class="header-nav bg-[#202721] py-4">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center">
            <!-- Logo Section -->
            <div class="flex items-center">
                <img src="/images/logo.png"
                     alt="WildTrails Logo"
                     class="h-12 mr-4">
                <h1 class="logo-text text-white text-2xl font-semibold">WildTrails</h1>
            </div>

            <!-- Navigation Menu -->
            <ul class="flex space-x-8 items-center">
                <li>
                    <a href="${pageContext.request.contextPath}/homepage/index.html"
                       class="text-white font-medium hover:text-[#76ad7e] hover:bg-white hover:bg-opacity-10 transition-colors duration-300 py-2 px-4 rounded">
                        HomePage
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/tours"
                       class="text-white font-medium hover:text-[#76ad7e] hover:bg-white hover:bg-opacity-10 transition-colors duration-300 py-2 px-4 rounded">
                        Tours
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/vehicles"
                       class="text-white font-medium hover:text-[#76ad7e] hover:bg-white hover:bg-opacity-10 transition-colors duration-300 py-2 px-4 rounded">
                        Vehicles
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/guides"
                       class="text-white font-medium hover:text-[#76ad7e] hover:bg-white hover:bg-opacity-10 transition-colors duration-300 py-2 px-4 rounded">
                        Guides
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/insurance"
                       class="text-white font-medium hover:text-[#76ad7e] hover:bg-white hover:bg-opacity-10 transition-colors duration-300 py-2 px-4 rounded">
                        Insurance
                    </a>
                </li>

                <!-- My Bookings Button -->
                <li>
                    <a href="${pageContext.request.contextPath}/bookings/mybooking"
                       class="my-bookings-btn text-white font-medium hover:text-[#76ad7e] hover:bg-white hover:bg-opacity-10 transition-colors duration-300 py-2 px-4 rounded">
                        <span class="text-lg">📋</span>
                        <span class="my-bookings-text">My Bookings</span>
                    </a>
                </li>

                <!-- User Login/Profile Section -->
                <c:choose>
                    <c:when test="${not empty sessionScope.userLoggedIn}">
                        <!-- User is logged in - Show profile dropdown -->
                        <li class="relative dropdown" id="profile-dropdown">
                            <button class="bg-[#76ad7e] text-white font-medium hover:bg-[#5a8c63] transition-colors duration-300 py-2 px-6 rounded-full flex items-center">
                                <i class="fas fa-user mr-2"></i>
                                    ${sessionScope.userFirstName}
                                <i class="fas fa-chevron-down ml-2 text-sm"></i>
                            </button>
                            <div class="dropdown-menu w-48 bg-white rounded-md shadow-lg py-1">
                                <a href="${pageContext.request.contextPath}/userlogin/userinfo"
                                   class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors duration-200">
                                    <i class="fas fa-user-circle mr-2"></i>My Profile
                                </a>
                                <a href="${pageContext.request.contextPath}/bookings/mybooking"
                                   class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors duration-200">
                                    <i class="fas fa-calendar-check mr-2"></i>My Bookings
                                </a>
                                <a href="${pageContext.request.contextPath}/userlogin/logout"
                                   class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors duration-200">
                                    <i class="fas fa-sign-out-alt mr-2"></i>Logout
                                </a>
                            </div>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <!-- User is not logged in - Show login button -->
                        <li>
                            <a href="${pageContext.request.contextPath}/userlogin/login"
                               class="bg-[#76ad7e] text-white font-medium hover:bg-[#5a8c63] transition-colors duration-300 py-2 px-6 rounded-full">
                                Login
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const dropdown = document.querySelector('.dropdown');
        const dropdownButton = dropdown?.querySelector('button');
        const dropdownMenu = dropdown?.querySelector('.dropdown-menu');

        if (dropdown && dropdownButton && dropdownMenu) {
            let closeTimeout;

            // Show dropdown on hover
            dropdown.addEventListener('mouseenter', function() {
                clearTimeout(closeTimeout);
                dropdownMenu.classList.add('show');
            });

            // Hide dropdown with delay when leaving
            dropdown.addEventListener('mouseleave', function() {
                closeTimeout = setTimeout(function() {
                    dropdownMenu.classList.remove('show');
                }, 300); // 300ms delay to allow moving to dropdown
            });

            // Keep dropdown open when hovering over menu
            dropdownMenu.addEventListener('mouseenter', function() {
                clearTimeout(closeTimeout);
                dropdownMenu.classList.add('show');
            });

            dropdownMenu.addEventListener('mouseleave', function() {
                closeTimeout = setTimeout(function() {
                    dropdownMenu.classList.remove('show');
                }, 150);
            });

            // Also support click to toggle
            dropdownButton.addEventListener('click', function(e) {
                e.stopPropagation();
                dropdownMenu.classList.toggle('show');
            });

            // Close dropdown when clicking elsewhere
            document.addEventListener('click', function() {
                dropdownMenu.classList.remove('show');
            });
        }
    });
</script>
</body>
</html>