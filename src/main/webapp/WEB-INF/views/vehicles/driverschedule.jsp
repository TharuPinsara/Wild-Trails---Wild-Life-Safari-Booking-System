<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WildTrails - Driver Schedule</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
</head>
<body class="bg-gray-50">
<%@ include file="../Header.jsp" %>

<div class="min-h-screen py-8">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">

        <c:if test="${empty sessionScope.driverLoggedIn}">
            <div class="text-center">
                <h1 class="text-2xl font-bold text-gray-900 mb-4">Access Denied</h1>
                <p class="text-gray-600 mb-4">Please login to access your schedule.</p>
                <a href="${pageContext.request.contextPath}/vehicles/admin"
                   class="inline-flex items-center px-6 py-3 bg-green-600 text-white font-medium rounded-lg hover:bg-green-700 transition duration-200">
                    <i class="fas fa-sign-in-alt mr-2"></i>Driver Login
                </a>
            </div>
        </c:if>

        <c:if test="${not empty sessionScope.driverLoggedIn}">
            <!-- Header -->
            <div class="text-center mb-8">
                <h1 class="text-3xl font-bold text-gray-900 mb-2">Schedule Management</h1>
                <p class="text-gray-600">Manage your vehicle availability and bookings</p>
                <div class="mt-4 space-x-4">
                    <a href="${pageContext.request.contextPath}/vehicles/admin/dashboard"
                       class="inline-flex items-center text-green-600 hover:text-green-700">
                        <i class="fas fa-arrow-left mr-2"></i>Back to Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/vehicles"
                       class="inline-flex items-center text-blue-600 hover:text-blue-700">
                        <i class="fas fa-car mr-2"></i>View All Vehicles
                    </a>
                    <a href="${pageContext.request.contextPath}/vehicles/logout"
                       class="inline-flex items-center text-red-600 hover:text-red-700">
                        <i class="fas fa-sign-out-alt mr-2"></i>Logout
                    </a>
                </div>
            </div>

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

            <!-- Quick Stats -->
            <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
                <div class="bg-green-50 rounded-lg p-4 text-center">
                    <div class="text-2xl font-bold text-green-600">${totalSchedules}</div>
                    <div class="text-sm text-green-800">Total Days Scheduled</div>
                </div>
                <div class="bg-blue-50 rounded-lg p-4 text-center">
                    <div class="text-2xl font-bold text-blue-600">${assignedSchedules}</div>
                    <div class="text-sm text-blue-800">Booked Days</div>
                </div>
                <div class="bg-yellow-50 rounded-lg p-4 text-center">
                    <div class="text-2xl font-bold text-yellow-600">${availableSchedules}</div>
                    <div class="text-sm text-yellow-800">Available Days</div>
                </div>
                <div class="bg-purple-50 rounded-lg p-4 text-center">
                    <div class="text-2xl font-bold text-purple-600">Rs. <fmt:formatNumber value="${totalEarnings}" pattern="#,##0"/></div>
                    <div class="text-sm text-purple-800">Estimated Earnings</div>
                </div>
            </div>

            <!-- Add New Schedule Section -->
            <div class="bg-white rounded-xl shadow-lg p-6 mb-8">
                <h2 class="text-2xl font-bold text-gray-900 mb-6">Add Availability</h2>
                <form action="${pageContext.request.contextPath}/vehicles/schedules/add" method="post" class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                        <label for="scheduleDate" class="block text-sm font-medium text-gray-700 mb-2">Date *</label>
                        <input type="text" id="scheduleDate" name="scheduleDate" required
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200"
                               placeholder="Select date">
                    </div>

                    <div>
                        <label for="notes" class="block text-sm font-medium text-gray-700 mb-2">Notes (Optional)</label>
                        <input type="text" id="notes" name="notes"
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200"
                               placeholder="Any special notes...">
                    </div>

                    <input type="hidden" name="vehicleId" value="${vehicle.vehicleId}">

                    <div class="md:col-span-2 flex justify-end space-x-4">
                        <button type="reset"
                                class="px-6 py-3 border border-gray-300 text-gray-700 font-medium rounded-lg hover:bg-gray-50 transition duration-200">
                            <i class="fas fa-redo mr-2"></i>Reset
                        </button>
                        <button type="submit"
                                class="px-6 py-3 bg-green-600 text-white font-medium rounded-lg hover:bg-green-700 transition duration-200">
                            <i class="fas fa-plus-circle mr-2"></i>Add Availability
                        </button>
                    </div>
                </form>
            </div>

            <!-- Schedule List -->
            <div class="bg-white rounded-xl shadow-lg p-6">
                <div class="flex justify-between items-center mb-6">
                    <h2 class="text-2xl font-bold text-gray-900">Your Schedule</h2>
                    <div class="flex items-center space-x-2">
                        <span class="bg-green-100 text-green-800 text-sm font-medium px-3 py-1 rounded-full">
                            Vehicle: ${vehicle.vehicleId}
                        </span>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${not empty schedules}">
                        <div class="overflow-x-auto">
                            <table class="w-full table-auto">
                                <thead>
                                <tr class="bg-gray-50">
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Day</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Booking ID</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tour ID</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                                </tr>
                                </thead>
                                <tbody class="bg-white divide-y divide-gray-200">
                                <c:forEach var="schedule" items="${schedules}">
                                    <tr class="hover:bg-gray-50 transition duration-200">
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="text-sm font-medium text-gray-900">
                                                <fmt:parseDate value="${schedule.scheduleDate}" pattern="yyyy-MM-dd" var="parsedDate"/>
                                                <fmt:formatDate value="${parsedDate}" pattern="MMM dd, yyyy"/>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="text-sm text-gray-500">
                                                <fmt:formatDate value="${parsedDate}" pattern="EEEE"/>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <c:choose>
                                                <c:when test="${schedule.status == 'booked'}">
                                                        <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">
                                                            <i class="fas fa-clock mr-1"></i>Booked (Pending)
                                                        </span>
                                                </c:when>
                                                <c:when test="${schedule.status == 'confirmed'}">
                                                        <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                            <i class="fas fa-check-circle mr-1"></i>Confirmed
                                                        </span>
                                                </c:when>
                                                <c:otherwise>
                                                        <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                                                            <i class="fas fa-calendar-check mr-1"></i>Available
                                                        </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="text-sm text-gray-900">
                                                <c:out value="${schedule.bookingId != null ? schedule.bookingId : 'N/A'}" />
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="text-sm text-gray-900">
                                                <c:out value="${schedule.tourId != null ? schedule.tourId : 'N/A'}" />
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                            <div class="flex space-x-2">
                                                <c:if test="${schedule.status == 'available'}">
                                                    <form action="${pageContext.request.contextPath}/vehicles/schedules/delete/${schedule.id}" method="post" class="inline">
                                                        <button type="submit"
                                                                onclick="return confirm('Are you sure you want to remove this availability?')"
                                                                class="text-red-600 hover:text-red-900 transition duration-200">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </form>
                                                </c:if>
                                                <c:if test="${schedule.status == 'booked'}">
                                                    <a href="${pageContext.request.contextPath}/vehicles/schedules/confirm/${schedule.id}"
                                                       onclick="return confirm('Confirm this booking?')"
                                                       class="text-green-600 hover:text-green-900 transition duration-200">
                                                        <i class="fas fa-check"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/vehicles/schedules/reject/${schedule.id}"
                                                       onclick="return confirm('Reject this booking?')"
                                                       class="text-red-600 hover:text-red-900 transition duration-200">
                                                        <i class="fas fa-times"></i>
                                                    </a>
                                                </c:if>
                                                <c:if test="${schedule.status == 'confirmed'}">
                                                        <span class="text-gray-400 cursor-not-allowed">
                                                            <i class="fas fa-lock"></i>
                                                        </span>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Schedule Summary -->
                        <div class="mt-6 p-4 bg-gray-50 rounded-lg">
                            <h3 class="text-lg font-semibold text-gray-900 mb-3">Schedule Summary</h3>
                            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
                                <div class="flex items-center">
                                    <span class="w-3 h-3 bg-blue-500 rounded-full mr-2"></span>
                                    <span class="text-gray-700">Available: ${availableSchedules} days</span>
                                </div>
                                <div class="flex items-center">
                                    <span class="w-3 h-3 bg-yellow-500 rounded-full mr-2"></span>
                                    <span class="text-gray-700">Pending: ${assignedSchedules} days</span>
                                </div>
                                <div class="flex items-center">
                                    <span class="w-3 h-3 bg-green-500 rounded-full mr-2"></span>
                                    <span class="text-gray-700">Confirmed: ${schedules.stream().filter(s -> s.status == 'confirmed').count()} days</span>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-12">
                            <div class="w-24 h-24 mx-auto mb-4 bg-gray-100 rounded-full flex items-center justify-center">
                                <i class="fas fa-calendar-times text-4xl text-gray-400"></i>
                            </div>
                            <h3 class="text-lg font-medium text-gray-900 mb-2">No schedules found</h3>
                            <p class="text-gray-600 mb-6">Add your availability to start accepting bookings.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Upcoming Bookings -->
            <div class="bg-white rounded-xl shadow-lg p-6 mt-8">
                <h2 class="text-2xl font-bold text-gray-900 mb-6">Upcoming Bookings</h2>
                <c:set var="upcomingBookings" value="${schedules.stream().filter(s -> s.status == 'booked' || s.status == 'confirmed').sorted((s1, s2) -> s1.scheduleDate.compareTo(s2.scheduleDate)).toList()}"/>
                <c:choose>
                    <c:when test="${not empty upcomingBookings}">
                        <div class="space-y-4">
                            <c:forEach var="booking" items="${upcomingBookings}" end="4">
                                <div class="flex items-center justify-between p-4 border border-gray-200 rounded-lg">
                                    <div class="flex items-center space-x-4">
                                        <div class="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center">
                                            <i class="fas fa-calendar-day text-green-600"></i>
                                        </div>
                                        <div>
                                            <div class="text-sm font-medium text-gray-900">
                                                <fmt:parseDate value="${booking.scheduleDate}" pattern="yyyy-MM-dd" var="parsedDate"/>
                                                <fmt:formatDate value="${parsedDate}" pattern="EEEE, MMMM dd, yyyy"/>
                                            </div>
                                            <div class="text-sm text-gray-500">
                                                Booking ID: <c:out value="${booking.bookingId != null ? booking.bookingId : 'N/A'}" />
                                            </div>
                                        </div>
                                    </div>
                                    <div>
                                        <c:choose>
                                            <c:when test="${booking.status == 'booked'}">
                                                <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">
                                                    Pending Confirmation
                                                </span>
                                            </c:when>
                                            <c:when test="${booking.status == 'confirmed'}">
                                                <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                    Confirmed
                                                </span>
                                            </c:when>
                                        </c:choose>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-8">
                            <i class="fas fa-calendar-check text-4xl text-gray-300 mb-3"></i>
                            <p class="text-gray-500">No upcoming bookings</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>
    </div>
</div>

<%@ include file="../Footer.jsp" %>

<script>
    // Initialize date picker
    flatpickr("#scheduleDate", {
        minDate: "today",
        dateFormat: "Y-m-d",
        disableMobile: true
    });
</script>
</body>
</html>