<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WildTrails - My Bookings</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-50">
<%@ include file="../Header.jsp" %>

<div class="min-h-screen py-8">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <!-- Header Section -->
        <div class="text-center mb-12">
            <h1 class="text-4xl font-bold text-gray-900 mb-4">My Bookings</h1>
            <p class="text-lg text-gray-600 max-w-3xl mx-auto">
                View and manage your safari bookings
            </p>
        </div>

        <div class="text-center mb-6">
            <a href="${pageContext.request.contextPath}/reports/myreports"
               class="inline-flex items-center px-6 py-3 bg-purple-600 text-white font-semibold rounded-lg hover:bg-purple-700 transition duration-200">
                <i class="fas fa-file-invoice-dollar mr-2"></i>
                View My Financial Reports
            </a>
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

        <!-- Bookings List -->
        <div class="space-y-6">
            <c:forEach var="booking" items="${bookings}">
                <div class="bg-white rounded-xl shadow-lg overflow-hidden">
                    <div class="p-6">
                        <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-4">
                            <div>
                                <h3 class="text-xl font-bold text-gray-900">Booking #${booking.bookingId}</h3>
                                <p class="text-gray-600">
                                    <!-- Fixed date formatting for LocalDate -->
                                    <c:choose>
                                        <c:when test="${not empty booking.tripDate}">
                                            <fmt:parseDate value="${booking.tripDate}" pattern="yyyy-MM-dd" var="parsedTripDate" />
                                            <fmt:formatDate value="${parsedTripDate}" pattern="MMMM d, yyyy"/>
                                        </c:when>
                                        <c:otherwise>
                                            ${booking.tripDate}
                                        </c:otherwise>
                                    </c:choose>
                                    • ${booking.durationDays} day(s) • ${booking.numberOfPersons} people
                                </p>
                            </div>
                            <div class="mt-2 md:mt-0">
                                <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium
                                    ${booking.status eq 'confirmed' ? 'bg-green-100 text-green-800' :
                                      booking.status eq 'pending' ? 'bg-yellow-100 text-yellow-800' :
                                      booking.status eq 'cancelled' ? 'bg-red-100 text-red-800' :
                                      'bg-blue-100 text-blue-800'}">
                                        ${booking.status}
                                </span>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-4">
                            <!-- Vehicle Info -->
                            <c:if test="${not empty booking.selectedVehicles && booking.selectedVehicles != ''}">
                                <div class="bg-gray-50 rounded-lg p-4">
                                    <h4 class="font-semibold text-gray-900 mb-2">Vehicle Details</h4>
                                    <div class="flex items-center">
                                        <i class="fas fa-car text-green-600 mr-3"></i>
                                        <div>
                                            <p class="font-medium">${booking.selectedVehicles}</p>
                                            <p class="text-sm text-gray-600">Details will be confirmed via SMS</p>
                                        </div>
                                    </div>
                                </div>
                            </c:if>

                            <!-- Guide Info -->
                            <c:if test="${not empty booking.selectedGuideId && booking.selectedGuideId != ''}">
                                <div class="bg-gray-50 rounded-lg p-4">
                                    <h4 class="font-semibold text-gray-900 mb-2">Guide Details</h4>
                                    <div class="flex items-center">
                                        <i class="fas fa-user text-blue-600 mr-3"></i>
                                        <div>
                                            <p class="font-medium">
                                                <c:choose>
                                                    <c:when test="${not empty booking.guide}">
                                                        ${booking.guide.name}
                                                    </c:when>
                                                    <c:otherwise>
                                                        Guide Selected
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                            <p class="text-sm text-gray-600">Details will be confirmed via SMS</p>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </div>

                        <div class="flex flex-col md:flex-row md:items-center md:justify-between">
                            <div class="mb-4 md:mb-0">
                                <p class="text-lg font-semibold text-gray-900">
                                    Total Amount: Rs.<fmt:formatNumber value="${booking.totalAmount}" pattern="#,##0.00"/>
                                </p>
                                <p class="text-sm text-gray-600">
                                    Booked on:
                                    <c:choose>
                                        <c:when test="${not empty booking.createdAt}">
                                            <fmt:parseDate value="${booking.createdAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedCreatedAt" />
                                            <fmt:formatDate value="${parsedCreatedAt}" pattern="MMMM d, yyyy 'at' h:mm a"/>
                                        </c:when>
                                        <c:otherwise>
                                            ${booking.createdAt}
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                            <div class="flex space-x-3">
                                <a href="${pageContext.request.contextPath}/bookings/${booking.bookingId}"
                                   class="inline-flex items-center px-4 py-2 bg-green-600 text-white font-medium rounded-lg hover:bg-green-700 transition duration-200">
                                    <i class="fas fa-eye mr-2"></i>
                                    View Details
                                </a>

                                <!-- Report Request Button -->
                                <button type="button" onclick="requestReport('${booking.bookingId}', ${booking.id})"
                                        class="inline-flex items-center px-4 py-2 bg-purple-600 text-white font-medium rounded-lg hover:bg-purple-700 transition duration-200">
                                    <i class="fas fa-file-invoice-dollar mr-2"></i>
                                    Request Report
                                </button>

                                <!-- DELETE BUTTON - ADDED -->
                                <button type="button" onclick="deleteBooking('${booking.bookingId}')"
                                        class="inline-flex items-center px-4 py-2 bg-red-600 text-white font-medium rounded-lg hover:bg-red-700 transition duration-200">
                                    <i class="fas fa-trash mr-2"></i>
                                    Delete
                                </button>

                                <c:if test="${booking.status eq 'pending' || booking.status eq 'confirmed'}">
                                    <button type="button" onclick="cancelBooking('${booking.bookingId}')"
                                            class="inline-flex items-center px-4 py-2 bg-orange-600 text-white font-medium rounded-lg hover:bg-orange-700 transition duration-200">
                                        <i class="fas fa-times mr-2"></i>
                                        Cancel
                                    </button>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Empty State -->
        <c:if test="${empty bookings}">
            <div class="text-center py-12">
                <i class="fas fa-calendar-times text-6xl text-gray-300 mb-4"></i>
                <h3 class="text-2xl font-bold text-gray-600 mb-2">No Bookings Found</h3>
                <p class="text-gray-500 mb-6">You haven't made any bookings yet.</p>
                <a href="${pageContext.request.contextPath}/tours"
                   class="inline-flex items-center px-6 py-3 bg-green-600 text-white font-semibold rounded-lg hover:bg-green-700 transition duration-200">
                    <i class="fas fa-plus mr-2"></i>
                    Book Now
                </a>
            </div>
        </c:if>
    </div>
</div>

<%@ include file="../Footer.jsp" %>

<script>
    function cancelBooking(bookingId) {
        if (confirm('Are you sure you want to cancel this booking?')) {
            fetch('${pageContext.request.contextPath}/bookings/' + bookingId + '/cancel', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                }
            })
                .then(response => {
                    if (response.ok) {
                        alert('Booking cancelled successfully!');
                        location.reload();
                    } else {
                        alert('Failed to cancel booking. Please try again.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('An error occurred while cancelling the booking.');
                });
        }
    }

    // DELETE FUNCTION - ADDED
    function deleteBooking(bookingId) {
        if (confirm('Are you sure you want to permanently delete this booking? This action cannot be undone and will remove all related data including insurance, guide schedules, and vehicle schedules.')) {
            fetch('${pageContext.request.contextPath}/bookings/' + bookingId + '/delete', {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json',
                }
            })
                .then(response => {
                    if (response.ok) {
                        return response.text();
                    } else {
                        throw new Error('Failed to delete booking');
                    }
                })
                .then(message => {
                    alert('Booking deleted successfully!');
                    location.reload();
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('An error occurred while deleting the booking.');
                });
        }
    }

    function requestReport(bookingId, bookingInternalId) {
        if (confirm('Request a detailed financial report for this booking? Our finance team will generate a comprehensive report with all costs and send it to you.')) {
            fetch('${pageContext.request.contextPath}/bookings/' + bookingId + '/request-report', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                }
            })
                .then(response => {
                    if (response.ok) {
                        return response.text();
                    } else {
                        throw new Error('Failed to request report');
                    }
                })
                .then(message => {
                    alert('Report requested successfully! ' + message);
                    // Optionally redirect to reports page
                    window.location.href = '${pageContext.request.contextPath}/reports/myreports';
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('An error occurred while requesting the report.');
                });
        }
    }
</script>
</body>
</html>