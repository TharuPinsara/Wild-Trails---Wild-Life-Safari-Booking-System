<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WildTrails - ${tour.tourName}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-50 flex flex-col min-h-screen">
<%@ include file="../Header.jsp" %>

<div class="flex-grow py-8">
    <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
        <!-- Breadcrumb -->
        <nav class="flex mb-8" aria-label="Breadcrumb">
            <ol class="flex items-center space-x-2">
                <li>
                    <a href="${pageContext.request.contextPath}/tours" class="text-gray-500 hover:text-gray-700">
                        <i class="fas fa-home"></i>
                    </a>
                </li>
                <li>
                    <span class="text-gray-400 mx-2">/</span>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/tours" class="text-gray-500 hover:text-gray-700">Tours</a>
                </li>
                <li>
                    <span class="text-gray-400 mx-2">/</span>
                </li>
                <li class="text-gray-900 font-medium">${tour.tourName}</li>
            </ol>
        </nav>

        <!-- Tour Header -->
        <div class="bg-white rounded-xl shadow-lg overflow-hidden mb-8">
            <div class="md:flex">
                <!-- Tour Photo -->
                <div class="md:w-1/2">
                    <c:choose>
                        <c:when test="${not empty tour.tourPhotoData}">
                            <img src="${pageContext.request.contextPath}/tours/photo/${tour.tourId}"
                                 alt="${tour.tourName}"
                                 class="w-full h-80 object-cover">
                        </c:when>
                        <c:otherwise>
                            <div class="w-full h-80 bg-gray-200 flex items-center justify-center">
                                <i class="fas fa-mountain text-6xl text-gray-400"></i>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Tour Basic Info -->
                <div class="md:w-1/2 p-8">
                    <div class="flex justify-between items-start mb-4">
                        <h1 class="text-3xl font-bold text-gray-900">${tour.tourName}</h1>
                        <span class="bg-purple-100 text-purple-800 text-xs font-medium px-2 py-1 rounded">
                            ${tour.tourId}
                        </span>
                    </div>

                    <div class="space-y-3 mb-6">
                        <div class="flex items-center text-gray-600">
                            <i class="fas fa-map-marker-alt mr-3 text-purple-600"></i>
                            <span class="font-medium">Destination:</span>
                            <span class="ml-2">${tour.destination}</span>
                        </div>

                        <div class="flex items-center text-gray-600">
                            <i class="fas fa-clock mr-3 text-purple-600"></i>
                            <span class="font-medium">Duration:</span>
                            <span class="ml-2">${tour.durationDays} ${tour.durationDays == 1 ? 'Day' : 'Days'}</span>
                        </div>

                        <!-- Meal Inclusions -->
                        <!-- Meal Inclusions -->
                        <div class="flex items-center text-gray-600">
                            <i class="fas fa-utensils mr-3 text-purple-600"></i>
                            <span class="font-medium">Meals:</span>
                            <div class="ml-2 flex space-x-2">
                                <c:if test="${tour.includesBreakfast == true}">
                                    <span class="bg-green-100 text-green-800 text-xs px-2 py-1 rounded">Breakfast</span>
                                </c:if>
                                <c:if test="${tour.includesLunch == true}">
                                    <span class="bg-yellow-100 text-yellow-800 text-xs px-2 py-1 rounded">Lunch</span>
                                </c:if>
                                <c:if test="${tour.includesDinner == true}">
                                    <span class="bg-red-100 text-red-800 text-xs px-2 py-1 rounded">Dinner</span>
                                </c:if>
                                <c:if test="${tour.includesBreakfast != true && tour.includesLunch != true && tour.includesDinner != true}">
                                    <span class="text-gray-500 text-xs">No meals included</span>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <!-- Special Features -->
                    <c:if test="${not empty tour.specialFeatures}">
                        <div class="mb-6">
                            <h3 class="text-lg font-semibold text-gray-900 mb-2">Special Features</h3>
                            <p class="text-gray-600">${tour.specialFeatures}</p>
                        </div>
                    </c:if>

                    <!-- Price and Action Button -->
                    <div class="border-t pt-6">
                        <div class="flex justify-between items-center">
                            <div>
                                <span class="text-2xl font-bold text-purple-600">
                                    Rs. <fmt:formatNumber value="${tour.price}" pattern="#,##0.00"/>
                                </span>
                                <span class="text-gray-500 text-sm block">per person</span>
                            </div>
                            <a href="${pageContext.request.contextPath}/bookings/new?tourId=${tour.tourId}"
                               class="bg-purple-600 text-white px-6 py-3 rounded-lg hover:bg-purple-700 transition duration-200 font-semibold">
                                <i class="fas fa-calendar-check mr-2"></i>Book Now
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Additional Information -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
            <!-- Left Column -->
            <div class="space-y-8">
                <!-- Description -->
                <c:if test="${not empty moreInfo.description}">
                    <div class="bg-white rounded-xl shadow-lg p-6">
                        <h2 class="text-xl font-bold text-gray-900 mb-4">Tour Description</h2>
                        <div class="text-gray-600 leading-relaxed">${moreInfo.description}</div>
                    </div>
                </c:if>

                <!-- Itinerary -->
                <c:if test="${not empty moreInfo.itinerary}">
                    <div class="bg-white rounded-xl shadow-lg p-6">
                        <h2 class="text-xl font-bold text-gray-900 mb-4">Detailed Itinerary</h2>
                        <div class="text-gray-600 whitespace-pre-line leading-relaxed">${moreInfo.itinerary}</div>
                    </div>
                </c:if>
            </div>

            <!-- Right Column -->
            <div class="space-y-8">
                <!-- Places to Visit -->
                <c:if test="${not empty moreInfo.placesToVisit}">
                    <div class="bg-white rounded-xl shadow-lg p-6">
                        <h2 class="text-xl font-bold text-gray-900 mb-4">Places to Visit</h2>
                        <div class="text-gray-600 whitespace-pre-line leading-relaxed">${moreInfo.placesToVisit}</div>
                    </div>
                </c:if>

                <!-- Included Services -->
                <c:if test="${not empty moreInfo.includedServices}">
                    <div class="bg-white rounded-xl shadow-lg p-6">
                        <h2 class="text-xl font-bold text-gray-900 mb-4">Included Services</h2>
                        <div class="text-gray-600 whitespace-pre-line leading-relaxed">${moreInfo.includedServices}</div>
                    </div>
                </c:if>

                <!-- Excluded Services -->
                <c:if test="${not empty moreInfo.excludedServices}">
                    <div class="bg-white rounded-xl shadow-lg p-6">
                        <h2 class="text-xl font-bold text-gray-900 mb-4">Excluded Services</h2>
                        <div class="text-gray-600 whitespace-pre-line leading-relaxed">${moreInfo.excludedServices}</div>
                    </div>
                </c:if>

                <!-- Important Notes -->
                <c:if test="${not empty moreInfo.importantNotes}">
                    <div class="bg-white rounded-xl shadow-lg p-6">
                        <h2 class="text-xl font-bold text-gray-900 mb-4">Important Notes</h2>
                        <div class="text-gray-600 whitespace-pre-line leading-relaxed">${moreInfo.importantNotes}</div>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Admin Actions -->
        <c:if test="${not empty sessionScope.adminLoggedIn}">
            <div class="mt-8 bg-white rounded-xl shadow-lg p-6">
                <h2 class="text-xl font-bold text-gray-900 mb-4">Admin Actions</h2>
                <div class="flex space-x-4">
                    <a href="${pageContext.request.contextPath}/tours/${tour.tourId}/add-info"
                       class="bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition duration-200">
                        <i class="fas fa-edit mr-2"></i>Edit Additional Info
                    </a>
                    <a href="${pageContext.request.contextPath}/tours/view"
                       class="bg-gray-600 text-white px-4 py-2 rounded-lg hover:bg-gray-700 transition duration-200">
                        <i class="fas fa-list mr-2"></i>Back to Tours List
                    </a>
                </div>
            </div>
        </c:if>

        <!-- Contact Section -->
        <div id="contact" class="mt-12 bg-white rounded-xl shadow-lg p-8">
            <h2 class="text-2xl font-bold text-gray-900 mb-6 text-center">Ready to Book This Tour?</h2>
            <div class="text-center">
                <p class="text-gray-600 mb-6">Contact us to book your safari adventure or for more information</p>
                <div class="flex justify-center space-x-6">
                    <a href="tel:+94123456789"
                       class="bg-green-600 text-white px-6 py-3 rounded-lg hover:bg-green-700 transition duration-200">
                        <i class="fas fa-phone mr-2"></i>Call Us
                    </a>
                    <a href="mailto:info@wildtrails.com"
                       class="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition duration-200">
                        <i class="fas fa-envelope mr-2"></i>Email Us
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../Footer.jsp" %>
</body>
</html>