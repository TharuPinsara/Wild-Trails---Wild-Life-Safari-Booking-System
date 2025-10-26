<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WildTrails - Safari Tours</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-50 flex flex-col min-h-screen">
<%@ include file="../Header.jsp" %>

<div class="flex-grow py-8">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <!-- Header Section -->
        <div class="text-center mb-12">
            <h1 class="text-4xl font-bold text-gray-900 mb-4">Safari Tours & Packages</h1>
            <p class="text-lg text-gray-600 max-w-3xl mx-auto">
                Discover amazing wildlife adventures in Sri Lanka's national parks.
                Choose from our carefully curated tour packages for an unforgettable experience.
            </p>
            <div class="mt-6 flex justify-center space-x-4">
                <a href="${pageContext.request.contextPath}/tours/add"
                   class="inline-flex items-center px-6 py-3 bg-purple-600 text-white font-semibold rounded-lg hover:bg-purple-700 transition duration-200">
                    <i class="fas fa-plus mr-2"></i>
                    Add New Tour (Admin)
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

        <!-- Tours Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            <c:forEach var="tour" items="${tours}">
                <div class="bg-white rounded-xl shadow-lg overflow-hidden hover:shadow-xl transition duration-300 relative">
                    <!-- Tour ID Badge -->
                    <div class="absolute top-4 right-4 bg-purple-100 text-purple-800 text-xs font-medium px-2 py-1 rounded">
                            ${tour.tourId}
                    </div>

                    <!-- Tour Photo -->
                    <div class="h-48 overflow-hidden">
                        <c:choose>
                            <c:when test="${not empty tour.tourPhotoData}">
                                <img src="${pageContext.request.contextPath}/tours/photo/${tour.tourId}"
                                     alt="${tour.tourName}"
                                     class="w-full h-full object-cover transition duration-300 hover:scale-105">
                            </c:when>
                            <c:otherwise>
                                <div class="w-full h-full bg-gray-200 flex items-center justify-center">
                                    <i class="fas fa-mountain text-4xl text-gray-400"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Tour Info -->
                    <div class="p-6">
                        <div class="flex justify-between items-start mb-3">
                            <h3 class="text-xl font-bold text-gray-900">${tour.tourName}</h3>
                            <span class="bg-blue-100 text-blue-800 text-sm font-medium px-3 py-1 rounded-full">
                                ${tour.durationDays} ${tour.durationDays == 1 ? 'Day' : 'Days'}
                            </span>
                        </div>

                        <div class="space-y-2 mb-4">
                            <div class="flex items-center text-gray-600">
                                <i class="fas fa-map-marker-alt mr-2 text-purple-600"></i>
                                <span>${tour.destination}</span>
                            </div>

                            <!-- Meal Inclusions -->
                            <div class="flex flex-wrap gap-2 mt-2">
                                <c:if test="${tour.includesBreakfast}">
                                    <span class="bg-green-100 text-green-800 text-xs px-2 py-1 rounded">
                                        <i class="fas fa-utensils mr-1"></i>Breakfast
                                    </span>
                                </c:if>
                                <c:if test="${tour.includesLunch}">
                                    <span class="bg-yellow-100 text-yellow-800 text-xs px-2 py-1 rounded">
                                        <i class="fas fa-utensils mr-1"></i>Lunch
                                    </span>
                                </c:if>
                                <c:if test="${tour.includesDinner}">
                                    <span class="bg-red-100 text-red-800 text-xs px-2 py-1 rounded">
                                        <i class="fas fa-utensils mr-1"></i>Dinner
                                    </span>
                                </c:if>
                            </div>
                        </div>

                        <!-- Special Features -->
                        <c:if test="${not empty tour.specialFeatures}">
                            <div class="mb-3">
                                <span class="text-sm font-medium text-gray-700">Features:</span>
                                <p class="text-gray-600 text-sm mt-1">${tour.specialFeatures}</p>
                            </div>
                        </c:if>

                        <div class="flex justify-between items-center mt-4 pt-4 border-t border-gray-200">
                            <span class="text-2xl font-bold text-purple-600">
                                Rs. <fmt:formatNumber value="${tour.price}" pattern="#,##0.00"/>
                            </span>
                            <a href="${pageContext.request.contextPath}/tours/${tour.tourId}"
                               class="bg-purple-600 text-white px-4 py-2 rounded-lg hover:bg-purple-700 transition duration-200">
                                View Details
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Empty State -->
        <c:if test="${empty tours}">
            <div class="text-center py-12">
                <i class="fas fa-mountain text-6xl text-gray-300 mb-4"></i>
                <h3 class="text-2xl font-bold text-gray-600 mb-2">No Tours Available</h3>
                <p class="text-gray-500 mb-6">We don't have any tours available at the moment.</p>
                <a href="${pageContext.request.contextPath}/tours/add"
                   class="inline-flex items-center px-6 py-3 bg-purple-600 text-white font-semibold rounded-lg hover:bg-purple-700 transition duration-200">
                    <i class="fas fa-plus mr-2"></i>
                    Add First Tour
                </a>
            </div>
        </c:if>
    </div>
</div>

<%@ include file="../Footer.jsp" %>
</body>
</html>