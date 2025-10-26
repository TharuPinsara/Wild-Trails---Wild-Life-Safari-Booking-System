<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WildTrails - Guide Schedule</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-50">
<!-- Guide Header -->
<header class="bg-green-600 text-white shadow-lg">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center py-4">
            <div class="flex items-center space-x-4">
                <c:if test="${not empty guide.photoData}">
                    <img src="${pageContext.request.contextPath}/guides/photo/${guide.guideId}"
                         alt="${guide.name}"
                         class="h-10 w-10 rounded-full object-cover">
                </c:if>
                <div>
                    <h1 class="text-xl font-bold">Guide Schedule</h1>
                    <p class="text-green-100 text-sm">Welcome back, ${guide.name}!</p>
                </div>
            </div>
            <div class="flex items-center space-x-4">
                <span class="bg-green-700 px-3 py-1 rounded-full text-sm">
                    ${guide.guideId}
                </span>
                <a href="${pageContext.request.contextPath}/guides/dashboard"
                   class="bg-green-700 hover:bg-green-800 px-4 py-2 rounded-lg transition duration-200">
                    <i class="fas fa-tachometer-alt mr-2"></i>Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/guides/logout"
                   class="bg-green-700 hover:bg-green-800 px-4 py-2 rounded-lg transition duration-200">
                    <i class="fas fa-sign-out-alt mr-2"></i>Logout
                </a>
            </div>
        </div>
    </div>
</header>

<div class="min-h-screen py-8">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <!-- Success/Error Messages -->
        <c:if test="${not empty success}">
            <div class="mb-6 p-4 bg-green-100 border border-green-400 text-green-700 rounded-lg">
                <div class="flex items-center">
                    <i class="fas fa-check-circle mr-2"></i>
                        ${success}
                </div>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="mb-6 p-4 bg-red-100 border border-red-400 text-red-700 rounded-lg">
                <div class="flex items-center">
                    <i class="fas fa-exclamation-circle mr-2"></i>
                        ${error}
                </div>
            </div>
        </c:if>

        <!-- Schedule Overview -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
            <div class="bg-white rounded-lg shadow p-6">
                <div class="flex items-center">
                    <div class="p-3 bg-blue-100 rounded-lg">
                        <i class="fas fa-calendar-check text-blue-600 text-xl"></i>
                    </div>
                    <div class="ml-4">
                        <p class="text-sm font-medium text-gray-600">Total Bookings</p>
                        <p class="text-2xl font-semibold text-gray-900">${totalBookings}</p>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-lg shadow p-6">
                <div class="flex items-center">
                    <div class="p-3 bg-green-100 rounded-lg">
                        <i class="fas fa-check-circle text-green-600 text-xl"></i>
                    </div>
                    <div class="ml-4">
                        <p class="text-sm font-medium text-gray-600">Upcoming Bookings</p>
                        <p class="text-2xl font-semibold text-gray-900">${upcomingBookings}</p>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-lg shadow p-6">
                <div class="flex items-center">
                    <div class="p-3 bg-purple-100 rounded-lg">
                        <i class="fas fa-clock text-purple-600 text-xl"></i>
                    </div>
                    <div class="ml-4">
                        <p class="text-sm font-medium text-gray-600">This Month</p>
                        <p class="text-2xl font-semibold text-gray-900">${monthBookings}</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Schedule Content -->
        <div class="bg-white rounded-xl shadow-lg p-6">
            <div class="flex justify-between items-center mb-6">
                <h2 class="text-2xl font-bold text-gray-900">My Schedule</h2>
                <div class="flex space-x-4">
                    <button onclick="filterSchedule('all')"
                            class="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition duration-200">
                        All Schedules
                    </button>
                    <button onclick="filterSchedule('booked')"
                            class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition duration-200">
                        Booked Only
                    </button>
                </div>
            </div>

            <c:if test="${not empty schedules}">
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Booking ID</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                        </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                        <c:forEach var="schedule" items="${schedules}">
                            <tr class="schedule-row ${schedule.status}">
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="text-sm font-medium text-gray-900">
                                        <!-- FIXED: Format LocalDate directly without conversion -->
                                            ${schedule.scheduleDate}
                                    </div>
                                    <div class="text-sm text-gray-500">
                                        <!-- FIXED: Use custom function to get day name -->
                                        <script>
                                            document.write(new Date('${schedule.scheduleDate}').toLocaleDateString('en-US', { weekday: 'long' }));
                                        </script>
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <c:choose>
                                        <c:when test="${schedule.status == 'booked'}">
                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800">
                                                    Booked
                                                </span>
                                        </c:when>
                                        <c:otherwise>
                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                                                    Available
                                                </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                    <c:choose>
                                        <c:when test="${not empty schedule.bookingId}">
                                            ${schedule.bookingId}
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-gray-400">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                    <c:if test="${schedule.status == 'booked'}">
                                        <button onclick="viewBookingDetails('${schedule.bookingId}')"
                                                class="text-blue-600 hover:text-blue-900 mr-3">
                                            <i class="fas fa-eye mr-1"></i>View Details
                                        </button>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>

            <c:if test="${empty schedules}">
                <div class="text-center py-8 text-gray-500">
                    <i class="fas fa-calendar-times text-4xl mb-3"></i>
                    <p>No schedule data available.</p>
                </div>
            </c:if>
        </div>
    </div>
</div>

<script>
    function filterSchedule(status) {
        const rows = document.querySelectorAll('.schedule-row');
        rows.forEach(row => {
            if (status === 'all') {
                row.style.display = '';
            } else {
                if (row.classList.contains(status)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            }
        });
    }

    function viewBookingDetails(bookingId) {
        alert('Booking details for: ' + bookingId + '\n\nThis would typically show detailed booking information.');
        // In a real implementation, you might:
        // 1. Make an AJAX call to get booking details
        // 2. Show a modal with booking information
        // 3. Redirect to a booking details page
    }

    // Function to format date with day name
    function formatDateWithDay(dateString) {
        const date = new Date(dateString);
        const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        return date.toLocaleDateString('en-US', options);
    }
</script>
</body>
</html>