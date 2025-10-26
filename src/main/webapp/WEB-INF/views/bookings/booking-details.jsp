<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WildTrails - Booking Details</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-50">
<%@ include file="../Header.jsp" %>

<div class="min-h-screen py-8">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <!-- Header Section -->
        <div class="text-center mb-8">
            <h1 class="text-3xl font-bold text-gray-900 mb-2">Booking Confirmed!</h1>
            <p class="text-lg text-gray-600">Your safari adventure is all set. Here are your booking details.</p>
        </div>

        <!-- Success Message -->
        <c:if test="${not empty success}">
            <div class="mb-6 p-4 bg-green-100 border border-green-400 text-green-700 rounded-lg">
                <div class="flex items-center">
                    <i class="fas fa-check-circle mr-2"></i>
                        ${success}
                </div>
            </div>
        </c:if>

        <!-- Booking Details Card -->
        <div class="bg-white rounded-xl shadow-lg overflow-hidden">
            <!-- Booking Header -->
            <div class="bg-green-600 px-6 py-4">
                <div class="flex flex-col md:flex-row md:items-center md:justify-between">
                    <div>
                        <h2 class="text-xl font-bold text-white">Booking #${booking.bookingId}</h2>
                        <p class="text-green-100">
                            Confirmed on
                            <c:choose>
                                <c:when test="${not empty booking.createdAt}">
                                    <fmt:parseDate value="${booking.createdAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedCreatedAt" />
                                    <fmt:formatDate value="${parsedCreatedAt}" pattern="MMMM d, yyyy 'at' h:mm a"/>
                                </c:when>
                                <c:otherwise>
                                    <fmt:formatDate value="${booking.createdAtAsDate}" pattern="MMMM d, yyyy 'at' h:mm a"/>
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    <div class="mt-2 md:mt-0">
                        <span class="inline-flex items-center px-3 py-1 bg-green-500 text-white rounded-full text-sm font-medium">
                            <i class="fas fa-check-circle mr-1"></i>
                            ${booking.status}
                        </span>
                    </div>
                </div>
            </div>

            <div class="p-6">
                <!-- Trip Information -->
                <div class="mb-8">
                    <h3 class="text-lg font-semibold text-gray-900 mb-4">Trip Information</h3>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div class="bg-gray-50 rounded-lg p-4">
                            <div class="flex items-center">
                                <i class="fas fa-calendar-day text-green-600 text-xl mr-3"></i>
                                <div>
                                    <p class="text-sm text-gray-600">Trip Date</p>
                                    <p class="font-semibold text-gray-900">
                                        <c:choose>
                                            <c:when test="${not empty booking.tripDate}">
                                                <fmt:parseDate value="${booking.tripDate}" pattern="yyyy-MM-dd" var="parsedTripDate" />
                                                <fmt:formatDate value="${parsedTripDate}" pattern="EEEE, MMMM d, yyyy"/>
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:formatDate value="${booking.tripDateAsDate}" pattern="EEEE, MMMM d, yyyy"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </div>
                        </div>

                        <div class="bg-gray-50 rounded-lg p-4">
                            <div class="flex items-center">
                                <i class="fas fa-clock text-green-600 text-xl mr-3"></i>
                                <div>
                                    <p class="text-sm text-gray-600">Duration</p>
                                    <p class="font-semibold text-gray-900">${booking.durationDays} day(s)</p>
                                </div>
                            </div>
                        </div>

                        <div class="bg-gray-50 rounded-lg p-4">
                            <div class="flex items-center">
                                <i class="fas fa-users text-green-600 text-xl mr-3"></i>
                                <div>
                                    <p class="text-sm text-gray-600">Number of People</p>
                                    <p class="font-semibold text-gray-900">${booking.numberOfPersons} person(s)</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="mt-4 bg-gray-50 rounded-lg p-4">
                        <div class="flex items-center">
                            <i class="fas fa-map-marked-alt text-green-600 text-xl mr-3"></i>
                            <div>
                                <p class="text-sm text-gray-600">Tour</p>
                                <p class="font-semibold text-gray-900">
                                    <c:choose>
                                        <c:when test="${not empty booking.tour}">
                                            ${booking.tour.tourName} - ${booking.tour.destination}
                                        </c:when>
                                        <c:otherwise>
                                            ${booking.tourId}
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Vehicle & Guide Details -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
                    <!-- Vehicle Details -->
                    <c:if test="${not empty booking.selectedVehicles && booking.selectedVehicles != ''}">
                        <div class="border border-gray-200 rounded-lg p-4">
                            <h4 class="font-semibold text-gray-900 mb-3 flex items-center">
                                <i class="fas fa-car text-green-600 mr-2"></i>
                                Vehicle Details
                            </h4>
                            <div class="space-y-4">
                                <c:choose>
                                    <c:when test="${not empty vehicles && vehicles.size() > 0}">
                                        <c:forEach var="vehicle" items="${vehicles}">
                                            <div class="bg-blue-50 rounded-lg p-4 border border-blue-200">
                                                <div class="flex justify-between items-start mb-3">
                                                    <h5 class="font-bold text-blue-800 text-lg">${vehicle.vehicleName}</h5>
                                                    <span class="bg-blue-100 text-blue-800 text-xs font-medium px-2 py-1 rounded">
                                                            ${vehicle.vehicleType}
                                                    </span>
                                                </div>
                                                <div class="space-y-2 text-sm">
                                                    <div class="flex justify-between">
                                                        <span class="text-gray-600 font-medium">Driver:</span>
                                                        <span class="font-semibold">${vehicle.driverName}</span>
                                                    </div>
                                                    <div class="flex justify-between">
                                                        <span class="text-gray-600 font-medium">Capacity:</span>
                                                        <span class="font-semibold">${vehicle.capacity} persons</span>
                                                    </div>
                                                    <div class="flex justify-between">
                                                        <span class="text-gray-600 font-medium">Contact:</span>
                                                        <span class="font-semibold">${vehicle.driverPhone}</span>
                                                    </div>
                                                    <c:if test="${not empty vehicle.driverEmail}">
                                                        <div class="flex justify-between">
                                                            <span class="text-gray-600 font-medium">Email:</span>
                                                            <span class="font-semibold">${vehicle.driverEmail}</span>
                                                        </div>
                                                    </c:if>
                                                    <div class="flex justify-between">
                                                        <span class="text-gray-600 font-medium">Daily Rate:</span>
                                                        <span class="font-semibold text-green-600">
                                                            Rs.<fmt:formatNumber value="${vehicle.dailyRate}" pattern="#,##0.00"/>
                                                        </span>
                                                    </div>
                                                    <c:if test="${not empty vehicle.specialFeatures}">
                                                        <div class="mt-2 pt-2 border-t border-blue-200">
                                                            <span class="text-gray-600 font-medium">Special Features:</span>
                                                            <p class="text-blue-700 text-sm mt-1">${vehicle.specialFeatures}</p>
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${not empty vehicle.inclusions}">
                                                        <div class="mt-2 pt-2 border-t border-blue-200">
                                                            <span class="text-gray-600 font-medium">Inclusions:</span>
                                                            <p class="text-blue-700 text-sm mt-1">${vehicle.inclusions}</p>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="space-y-2">
                                            <div class="flex justify-between">
                                                <span class="text-gray-600">Vehicles:</span>
                                                <span class="font-medium">${booking.selectedVehicles}</span>
                                            </div>
                                            <div class="mt-3 p-3 bg-blue-50 rounded-lg">
                                                <p class="text-sm text-blue-600">
                                                    <i class="fas fa-info-circle mr-1"></i>
                                                    Vehicle and driver details will be confirmed via SMS.
                                                </p>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:if>

                    <!-- Guide Details -->
                    <c:if test="${not empty guide}">
                        <div class="border border-gray-200 rounded-lg p-4">
                            <h4 class="font-semibold text-gray-900 mb-3 flex items-center">
                                <i class="fas fa-user text-blue-600 mr-2"></i>
                                Guide Details
                            </h4>
                            <div class="space-y-3">
                                <div class="flex justify-between">
                                    <span class="text-gray-600 font-medium">Guide Name:</span>
                                    <span class="font-semibold">${guide.name}</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-gray-600 font-medium">Experience:</span>
                                    <span class="font-semibold">${guide.experienceYears} years</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-gray-600 font-medium">Specialization:</span>
                                    <span class="font-semibold">${guide.specialization}</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-gray-600 font-medium">Contact:</span>
                                    <span class="font-semibold">${guide.phoneNumber}</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-gray-600 font-medium">Daily Rate:</span>
                                    <span class="font-semibold text-green-600">
                                        Rs.<fmt:formatNumber value="${guide.dailyRate}" pattern="#,##0.00"/>
                                    </span>
                                </div>
                                <c:if test="${not empty guide.email}">
                                    <div class="flex justify-between">
                                        <span class="text-gray-600 font-medium">Email:</span>
                                        <span class="font-semibold">${guide.email}</span>
                                    </div>
                                </c:if>
                                <c:if test="${not empty guide.languages}">
                                    <div class="flex justify-between">
                                        <span class="text-gray-600 font-medium">Languages:</span>
                                        <span class="font-semibold">${guide.languages}</span>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </c:if>
                </div>

                <!-- Insurance Information -->
                <c:if test="${not empty booking.insurancePlan && booking.insurancePlan != ''}">
                    <div class="mb-8">
                        <h4 class="font-semibold text-gray-900 mb-3">Insurance Plan</h4>
                        <div class="bg-gray-50 rounded-lg p-4">
                            <c:choose>
                                <c:when test="${not empty insuranceBooking}">
                                    <div class="space-y-2">
                                        <div class="flex justify-between">
                                            <span class="text-gray-600 font-medium">Insurance Company:</span>
                                            <span class="font-semibold">${insuranceBooking.companyName}</span>
                                        </div>
                                        <div class="flex justify-between">
                                            <span class="text-gray-600 font-medium">Insurance Type:</span>
                                            <span class="font-semibold">${insuranceBooking.insuranceType}</span>
                                        </div>
                                        <div class="flex justify-between">
                                            <span class="text-gray-600 font-medium">Coverage Type:</span>
                                            <span class="font-semibold">${insuranceBooking.coverageType}</span>
                                        </div>
                                        <div class="flex justify-between">
                                            <span class="text-gray-600 font-medium">Price per Day per Person:</span>
                                            <span class="font-semibold">
                                                Rs.<fmt:formatNumber value="${insuranceBooking.pricePerDayPerPerson}" pattern="#,##0.00"/>
                                            </span>
                                        </div>
                                        <div class="flex justify-between">
                                            <span class="text-gray-600 font-medium">Total Insurance Cost:</span>
                                            <span class="font-semibold text-green-600">
                                                Rs.<fmt:formatNumber value="${insuranceBooking.totalInsuranceCost}" pattern="#,##0.00"/>
                                            </span>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-gray-700">Insurance Plan: ${booking.insurancePlan}</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:if>

                <!-- Special Requirements -->
                <c:if test="${not empty booking.specialRequirements && booking.specialRequirements != ''}">
                    <div class="mb-8">
                        <h4 class="font-semibold text-gray-900 mb-3">Special Requirements</h4>
                        <div class="bg-gray-50 rounded-lg p-4">
                            <p class="text-gray-700">${booking.specialRequirements}</p>
                        </div>
                    </div>
                </c:if>

                <!-- Pricing Breakdown -->
                <div class="border-t border-gray-200 pt-6">
                    <h4 class="font-semibold text-gray-900 mb-4">Pricing Breakdown</h4>
                    <div class="space-y-3 mb-4">
                        <!-- Tour Price -->
                        <div class="flex justify-between">
                            <span class="text-gray-600">Tour Price (${booking.numberOfPersons} persons):</span>
                            <span class="font-medium">
                                <c:choose>
                                    <c:when test="${not empty booking.tour}">
                                        Rs.<fmt:formatNumber value="${booking.tour.price * booking.numberOfPersons}" pattern="#,##0.00"/>
                                    </c:when>
                                    <c:otherwise>
                                        Included in total
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <!-- Vehicle Costs -->
                        <c:if test="${not empty booking.selectedVehicles && booking.selectedVehicles != ''}">
                            <div class="flex justify-between">
                                <span class="text-gray-600">Vehicle Cost:</span>
                                <span class="font-medium">
                                    <c:choose>
                                        <c:when test="${not empty vehicles && vehicles.size() > 0}">
                                            <c:set var="totalVehicleCost" value="0" />
                                            <c:forEach var="vehicle" items="${vehicles}">
                                                <c:set var="totalVehicleCost" value="${totalVehicleCost + (vehicle.dailyRate * booking.durationDays)}" />
                                            </c:forEach>
                                            Rs.<fmt:formatNumber value="${totalVehicleCost}" pattern="#,##0.00"/>
                                        </c:when>
                                        <c:otherwise>
                                            Included in total
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </c:if>

                        <!-- Guide Cost -->
                        <c:if test="${not empty guide}">
                            <div class="flex justify-between">
                                <span class="text-gray-600">Guide Cost:</span>
                                <span class="font-medium">
                                    Rs.<fmt:formatNumber value="${guide.dailyRate * booking.durationDays}" pattern="#,##0.00"/>
                                </span>
                            </div>
                        </c:if>

                        <!-- Insurance Cost -->
                        <c:if test="${not empty booking.insurancePlan && booking.insurancePlan != ''}">
                            <div class="flex justify-between">
                                <span class="text-gray-600">Insurance Cost:</span>
                                <span class="font-medium">
                                    <c:choose>
                                        <c:when test="${not empty insuranceBooking}">
                                            Rs.<fmt:formatNumber value="${insuranceBooking.totalInsuranceCost}" pattern="#,##0.00"/>
                                        </c:when>
                                        <c:otherwise>
                                            Included in total
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </c:if>
                    </div>
                    <div class="flex justify-between items-center border-t border-gray-200 pt-4">
                        <span class="text-lg font-bold text-gray-900">Total Amount:</span>
                        <span class="text-2xl font-bold text-green-600">
                            Rs.<fmt:formatNumber value="${booking.totalAmount}" pattern="#,##0.00"/>
                        </span>
                    </div>
                </div>

                <!-- Important Notes -->
                <div class="mt-8 p-4 bg-yellow-50 border border-yellow-200 rounded-lg">
                    <h4 class="font-semibold text-yellow-800 mb-2 flex items-center">
                        <i class="fas fa-exclamation-circle mr-2"></i>
                        Important Notes
                    </h4>
                    <ul class="text-yellow-700 text-sm space-y-1">
                        <li>• Please arrive 30 minutes before your scheduled safari time</li>
                        <li>• Carry valid ID proof for verification</li>
                        <li>• Follow the guide's instructions during the safari</li>
                        <li>• Cancellation policy: 24 hours notice required for full refund</li>
                        <li>• You will receive SMS confirmation with driver and guide details</li>
                        <c:if test="${not empty vehicles && vehicles.size() > 0}">
                            <li>• Vehicle drivers will contact you 24 hours before the trip</li>
                        </c:if>
                        <c:if test="${not empty guide}">
                            <li>• Your guide ${guide.name} will meet you at the starting point</li>
                        </c:if>
                    </ul>
                </div>

                <!-- Action Buttons -->
                <div class="mt-8 flex flex-col sm:flex-row gap-4 justify-center">
                    <a href="${pageContext.request.contextPath}/bookings/mybookings"
                       class="inline-flex items-center justify-center px-6 py-3 bg-green-600 text-white font-semibold rounded-lg hover:bg-green-700 transition duration-200">
                        <i class="fas fa-list mr-2"></i>
                        View All Bookings
                    </a>
                    <a href="${pageContext.request.contextPath}/"
                       class="inline-flex items-center justify-center px-6 py-3 bg-gray-600 text-white font-semibold rounded-lg hover:bg-gray-700 transition duration-200">
                        <i class="fas fa-home mr-2"></i>
                        Back to Home
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../Footer.jsp" %>
</body>
</html>