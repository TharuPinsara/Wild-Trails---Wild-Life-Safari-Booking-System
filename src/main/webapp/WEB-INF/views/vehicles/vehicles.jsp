<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WildTrails - Our Vehicles</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-50">
<%@ include file="../Header.jsp" %>

<div class="min-h-screen py-8">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <!-- Header Section -->
        <div class="text-center mb-12">
            <h1 class="text-4xl font-bold text-gray-900 mb-4">Our Safari Vehicles</h1>
            <p class="text-lg text-gray-600 max-w-3xl mx-auto">
                Explore our fleet of well-maintained safari vehicles equipped with modern amenities
                and driven by experienced drivers for your wildlife adventures.
            </p>
            <div class="mt-6">
                <a href="${pageContext.request.contextPath}/vehicles/admin"
                   class="inline-flex items-center px-6 py-3 bg-green-600 text-white font-semibold rounded-lg hover:bg-green-700 transition duration-200">
                    <i class="fas fa-plus mr-2"></i>
                    Register New Vehicle
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

        <!-- Vehicles Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            <c:forEach var="vehicle" items="${vehicles}">
                <div class="bg-white rounded-xl shadow-lg overflow-hidden hover:shadow-xl transition duration-300 relative">
                    <!-- Vehicle ID Badge -->
                    <div class="absolute top-4 right-4 bg-green-100 text-green-800 text-xs font-medium px-2 py-1 rounded">
                            ${vehicle.vehicleId}
                    </div>

                    <!-- Status Badge -->
                    <div class="absolute top-4 left-4 ${vehicle.vehicleReady ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'} text-xs font-medium px-2 py-1 rounded">
                            ${vehicle.vehicleReady ? 'Available' : 'Not Available'}
                    </div>

                    <!-- Vehicle Photo -->
                    <div class="h-48 overflow-hidden">
                        <c:choose>
                            <c:when test="${not empty vehicle.vehiclePhotoData}">
                                <img src="${pageContext.request.contextPath}/vehicles/vehicle-photo/${vehicle.vehicleId}"
                                     alt="${vehicle.vehicleName}"
                                     class="w-full h-full object-cover transition duration-300 hover:scale-105">
                            </c:when>
                            <c:otherwise>
                                <div class="w-full h-full bg-gray-200 flex items-center justify-center">
                                    <i class="fas fa-car text-4xl text-gray-400"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Vehicle Info -->
                    <div class="p-6">
                        <div class="flex justify-between items-start mb-3">
                            <h3 class="text-xl font-bold text-gray-900">${vehicle.vehicleName}</h3>
                            <span class="bg-green-100 text-green-800 text-sm font-medium px-3 py-1 rounded-full">
                                    ${vehicle.vehicleType}
                            </span>
                        </div>
                        
                        <div class="flex items-center text-gray-600 mb-2">
                            <i class="fas fa-users mr-2 text-green-600"></i>
                            <span class="text-sm">Capacity: ${vehicle.capacity} passengers</span>
                        </div>


                        <!-- Driver Info with Photo -->
                        <div class="flex items-center mb-4">
                            <div class="w-12 h-12 rounded-full overflow-hidden mr-3">
                                <c:choose>
                                    <c:when test="${not empty vehicle.driverPhotoData}">
                                        <img src="${pageContext.request.contextPath}/vehicles/driver-photo/${vehicle.vehicleId}"
                                             alt="${vehicle.driverName}"
                                             class="w-full h-full object-cover">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="w-full h-full bg-gray-300 flex items-center justify-center">
                                            <i class="fas fa-user text-gray-500"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div>
                                <h4 class="font-semibold text-gray-900">${vehicle.driverName}</h4>
                                <p class="text-sm text-gray-600">${vehicle.driverPhone}</p>
                                <c:if test="${not empty vehicle.driverEmail}">
                                    <p class="text-sm text-gray-600">${vehicle.driverEmail}</p>
                                </c:if>
                            </div>
                        </div>

                        <!-- Inclusions -->
                        <c:if test="${not empty vehicle.inclusions}">
                            <div class="mb-3">
                                <span class="text-sm font-medium text-gray-700">Inclusions:</span>
                                <div class="flex flex-wrap gap-1 mt-1">
                                    <c:forEach var="inclusion" items="${vehicle.inclusions.split(',')}">
                                        <span class="bg-green-100 text-green-800 text-xs font-medium px-2 py-1 rounded">
                                            <i class="fas fa-check mr-1"></i>${inclusion.trim()}
                                        </span>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>

                        <!-- Special Features -->
                        <c:if test="${not empty vehicle.specialFeatures}">
                            <div class="mb-3">
                                <span class="text-sm font-medium text-gray-700">Special Features:</span>
                                <p class="text-gray-600 text-sm mt-1">${vehicle.specialFeatures}</p>
                            </div>
                        </c:if>

                        <!-- Price -->
                        <div class="flex justify-between items-center mt-4 pt-4 border-t border-gray-200">
                            <span class="text-2xl font-bold text-green-600">
                                Rs.<fmt:formatNumber value="${vehicle.dailyRate}" pattern="#,##0.00"/>/day
                            </span>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Empty State -->
        <c:if test="${empty vehicles}">
            <div class="text-center py-12">
                <i class="fas fa-car text-6xl text-gray-300 mb-4"></i>
                <h3 class="text-2xl font-bold text-gray-600 mb-2">No Vehicles Available</h3>
                <p class="text-gray-500 mb-6">We don't have any vehicles registered yet.</p>
                <a href="${pageContext.request.contextPath}/vehicles/register"
                   class="inline-flex items-center px-6 py-3 bg-green-600 text-white font-semibold rounded-lg hover:bg-green-700 transition duration-200">
                    <i class="fas fa-plus mr-2"></i>
                    Register First Vehicle
                </a>
            </div>
        </c:if>
    </div>
</div>
<%@ include file="../Footer.jsp" %>
</body>
</html>