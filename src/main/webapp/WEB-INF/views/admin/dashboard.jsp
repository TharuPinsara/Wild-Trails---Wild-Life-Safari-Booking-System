<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Safari Management System</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .admin-card {
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }
        .admin-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
        }
    </style>
</head>
<body class="bg-gray-50 min-h-screen">
<!-- Header -->
<header class="bg-white shadow-sm">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center py-6">
            <div class="flex items-center">
                <i class="fas fa-compass text-2xl text-purple-600 mr-3"></i>
                <h1 class="text-2xl font-bold text-gray-900">Safari Management System</h1>
            </div>
            <div class="text-sm text-gray-500">
                Admin Dashboard
            </div>
        </div>
    </div>
</header>

<!-- Main Content -->
<main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- Welcome Section -->
    <div class="text-center mb-12">
        <h2 class="text-4xl font-bold text-gray-900 mb-4">Admin Dashboard</h2>
        <p class="text-xl text-gray-600 max-w-3xl mx-auto">
            Manage different aspects of the safari tour system. Select a department below to access its administrative functions.
        </p>
    </div>

    <!-- Admin Cards Grid -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        <!-- Drivers Management -->
        <div class="admin-card bg-white rounded-xl shadow-md p-6 border-l-4 border-l-blue-500">
            <div class="flex items-center mb-4">
                <div class="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center mr-4">
                    <i class="fas fa-car text-blue-600 text-xl"></i>
                </div>
                <h3 class="text-xl font-semibold text-gray-900">Drivers Management</h3>
            </div>
            <p class="text-gray-600 mb-6">
                Register and manage vehicle drivers, assign vehicles, and track driver availability.
            </p>
            <a href="${pageContext.request.contextPath}/vehicles/admin"
               class="w-full bg-blue-600 text-white px-4 py-3 rounded-lg hover:bg-blue-700 transition duration-200 font-semibold flex items-center justify-center">
                <i class="fas fa-arrow-right mr-2"></i>
                Access Drivers Portal
            </a>
        </div>

        <!-- Guides Management -->
        <div class="admin-card bg-white rounded-xl shadow-md p-6 border-l-4 border-l-green-500">
            <div class="flex items-center mb-4">
                <div class="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center mr-4">
                    <i class="fas fa-user text-green-600 text-xl"></i>
                </div>
                <h3 class="text-xl font-semibold text-gray-900">Guides Management</h3>
            </div>
            <p class="text-gray-600 mb-6">
                Register tour guides, manage certifications, and assign guides to safari tours.
            </p>
            <a href="${pageContext.request.contextPath}/guides/login"
               class="w-full bg-green-600 text-white px-4 py-3 rounded-lg hover:bg-green-700 transition duration-200 font-semibold flex items-center justify-center">
                <i class="fas fa-arrow-right mr-2"></i>
                Access Guides Portal
            </a>
        </div>

        <!-- Insurance Management -->
        <div class="admin-card bg-white rounded-xl shadow-md p-6 border-l-4 border-l-purple-500">
            <div class="flex items-center mb-4">
                <div class="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center mr-4">
                    <i class="fas fa-shield-alt text-purple-600 text-xl"></i>
                </div>
                <h3 class="text-xl font-semibold text-gray-900">Insurance Officer</h3>
            </div>
            <p class="text-gray-600 mb-6">
                Manage insurance plans, coverage options, and process insurance claims for tours.
            </p>
            <a href="${pageContext.request.contextPath}/insurance/admin"
               class="w-full bg-purple-600 text-white px-4 py-3 rounded-lg hover:bg-purple-700 transition duration-200 font-semibold flex items-center justify-center">
                <i class="fas fa-arrow-right mr-2"></i>
                Access Insurance Portal
            </a>
        </div>

        <!-- Finance Management -->
        <div class="admin-card bg-white rounded-xl shadow-md p-6 border-l-4 border-l-yellow-500">
            <div class="flex items-center mb-4">
                <div class="w-12 h-12 bg-yellow-100 rounded-lg flex items-center justify-center mr-4">
                    <i class="fas fa-chart-line text-yellow-600 text-xl"></i>
                </div>
                <h3 class="text-xl font-semibold text-gray-900">Finance Officer</h3>
            </div>
            <p class="text-gray-600 mb-6">
                View financial reports, revenue analytics, and manage billing and payment systems.
            </p>
            <a href="${pageContext.request.contextPath}/reports/admin/login"
               class="w-full bg-yellow-600 text-white px-4 py-3 rounded-lg hover:bg-yellow-700 transition duration-200 font-semibold flex items-center justify-center">
                <i class="fas fa-arrow-right mr-2"></i>
                Access Finance Portal
            </a>
        </div>

        <!-- Safari Management -->
        <div class="admin-card bg-white rounded-xl shadow-md p-6 border-l-4 border-l-red-500">
            <div class="flex items-center mb-4">
                <div class="w-12 h-12 bg-red-100 rounded-lg flex items-center justify-center mr-4">
                    <i class="fas fa-mountain text-red-600 text-xl"></i>
                </div>
                <h3 class="text-xl font-semibold text-gray-900">Safari Manager</h3>
            </div>
            <p class="text-gray-600 mb-6">
                Create and manage safari tours, itineraries, and oversee overall tour operations.
            </p>
            <a href="${pageContext.request.contextPath}/tours/add"
               class="w-full bg-red-600 text-white px-4 py-3 rounded-lg hover:bg-red-700 transition duration-200 font-semibold flex items-center justify-center">
                <i class="fas fa-arrow-right mr-2"></i>
                Access Safari Manager
            </a>
        </div>

        <!-- System Overview -->
        <div class="admin-card bg-white rounded-xl shadow-md p-6 border-l-4 border-l-gray-500">
            <div class="flex items-center mb-4">
                <div class="w-12 h-12 bg-gray-100 rounded-lg flex items-center justify-center mr-4">
                    <i class="fas fa-tachometer-alt text-gray-600 text-xl"></i>
                </div>
                <h3 class="text-xl font-semibold text-gray-900">System Overview</h3>
            </div>
            <p class="text-gray-600 mb-6">
                View system statistics, active bookings, and overall platform performance metrics.
            </p>
            <button
                    class="w-full bg-gray-600 text-white px-4 py-3 rounded-lg hover:bg-gray-700 transition duration-200 font-semibold flex items-center justify-center">
                <i class="fas fa-chart-bar mr-2"></i>
                View Dashboard
            </button>
        </div>
    </div>

    <!-- Quick Stats -->
    <div class="mt-16 bg-white rounded-xl shadow-md p-6">
        <h3 class="text-2xl font-bold text-gray-900 mb-6 text-center">Quick Statistics</h3>
        <div class="grid grid-cols-2 md:grid-cols-4 gap-6">
            <div class="text-center">
                <div class="text-3xl font-bold text-blue-600 mb-2">${activeDriversCount}</div>
                <div class="text-gray-600">Active Drivers</div>
            </div>
            <div class="text-center">
                <div class="text-3xl font-bold text-green-600 mb-2">${availableGuidesCount}</div>
                <div class="text-gray-600">Available Guides</div>
            </div>
            <div class="text-center">
                <div class="text-3xl font-bold text-purple-600 mb-2">${activeBookingsCount}</div>
                <div class="text-gray-600">Active Bookings</div>
            </div>
            <div class="text-center">
                <div class="text-3xl font-bold text-red-600 mb-2">${safariToursCount}</div>
                <div class="text-gray-600">Safari Tours</div>
            </div>
        </div>
    </div>
</main>

<!-- Footer -->
<footer class="bg-white border-t border-gray-200 mt-16">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
        <div class="flex justify-between items-center">
            <div class="text-gray-500 text-sm">
                &copy; 2024 Safari Management System. All rights reserved.
            </div>
            <div class="text-sm text-gray-500">
                Admin Access Only
            </div>
        </div>
    </div>
</footer>

<script>
    // Add some interactive features
    document.addEventListener('DOMContentLoaded', function() {
        // Add click animation to cards
        const cards = document.querySelectorAll('.admin-card');
        cards.forEach(card => {
            card.addEventListener('click', function(e) {
                // Only animate if clicking on the card itself, not the link
                if (e.target.tagName !== 'A' && !e.target.closest('a')) {
                    this.style.transform = 'scale(0.98)';
                    setTimeout(() => {
                        this.style.transform = '';
                    }, 150);
                }
            });
        });
    });
</script>
</body>
</html>