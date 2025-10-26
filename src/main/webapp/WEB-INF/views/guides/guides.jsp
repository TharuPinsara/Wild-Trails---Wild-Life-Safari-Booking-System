<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WildTrails - Our Guides</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-50">
<%@ include file="../Header.jsp" %>

<div class="min-h-screen py-8">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <!-- Header Section -->
        <div class="text-center mb-12">
            <h1 class="text-4xl font-bold text-gray-900 mb-4">Our Expert Guides</h1>
            <p class="text-lg text-gray-600 max-w-3xl mx-auto">
                Meet our team of experienced wildlife guides who will make your safari adventure unforgettable.
                Each guide is certified and passionate about Sri Lanka's rich biodiversity.
            </p>
            <div class="mt-6 flex justify-center space-x-4">
                <a href="${pageContext.request.contextPath}/guides/register"
                   class="inline-flex items-center px-6 py-3 bg-blue-600 text-white font-semibold rounded-lg hover:bg-blue-700 transition duration-200">
                    <i class="fas fa-plus mr-2"></i>
                    Register New Guide
                </a>
                <a href="${pageContext.request.contextPath}/guides/sightings"
                   class="inline-flex items-center px-6 py-3 bg-green-600 text-white font-semibold rounded-lg hover:bg-green-700 transition duration-200">
                    <i class="fas fa-binoculars mr-2"></i>
                    View All Sightings
                </a>
            </div>
        </div>

        <!-- Success/Error Messages -->
        <c:if test="${not empty success}">
            <div class="mb-6 p-4 bg-blue-100 border border-blue-400 text-blue-700 rounded-lg">
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

        <!-- Guides Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            <c:forEach var="guide" items="${guides}">
                <div class="bg-white rounded-xl shadow-lg overflow-hidden hover:shadow-xl transition duration-300 relative">
                    <!-- Guide ID Badge -->
                    <div class="absolute top-4 right-4 bg-blue-100 text-blue-800 text-xs font-medium px-2 py-1 rounded">
                            ${guide.guideId}
                    </div>

                    <!-- Guide Photo -->
                    <div class="h-64 overflow-hidden">
                        <c:choose>
                            <c:when test="${not empty guide.photoData}">
                                <img src="${pageContext.request.contextPath}/guides/photo/${guide.guideId}"
                                     alt="${guide.name}"
                                     class="w-full h-full object-cover transition duration-300 hover:scale-105">
                            </c:when>
                            <c:otherwise>
                                <div class="w-full h-full bg-gray-200 flex items-center justify-center">
                                    <i class="fas fa-user text-6xl text-gray-400"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Guide Info -->
                    <div class="p-6">
                        <div class="flex justify-between items-start mb-3">
                            <h3 class="text-xl font-bold text-gray-900">${guide.name}</h3>
                            <span class="bg-blue-100 text-blue-800 text-sm font-medium px-3 py-1 rounded-full">
                                    ${guide.experienceYears}+ years
                                </span>
                        </div>

                        <div class="space-y-2 mb-4">
                            <div class="flex items-center text-gray-600">
                                <i class="fas fa-phone-alt mr-2 text-blue-600"></i>
                                <span>${guide.phoneNumber}</span>
                            </div>
                            <c:if test="${not empty guide.email}">
                                <div class="flex items-center text-gray-600">
                                    <i class="fas fa-envelope mr-2 text-blue-600"></i>
                                    <span>${guide.email}</span>
                                </div>
                            </c:if>
                            <div class="flex items-center text-gray-600">
                                <i class="fas fa-language mr-2 text-blue-600"></i>
                                <span>${not empty guide.languages ? guide.languages : 'English, Sinhala'}</span>
                            </div>
                        </div>

                        <!-- Specialization -->
                        <c:if test="${not empty guide.specialization}">
                            <div class="mb-3">
                                <span class="text-sm font-medium text-gray-700">Specialization:</span>
                                <div class="flex flex-wrap gap-1 mt-1">
                                    <c:forEach var="spec" items="${guide.specialization.split(',')}">
                                        <span class="bg-blue-100 text-blue-800 text-xs font-medium px-2 py-1 rounded">
                                                ${spec.trim()}
                                        </span>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>

                        <!-- Opportunities -->
                        <c:if test="${not empty guide.opportunities}">
                            <div class="mb-3">
                                <span class="text-sm font-medium text-gray-700">Special Opportunities:</span>
                                <p class="text-gray-600 text-sm mt-1">${guide.opportunities}</p>
                            </div>
                        </c:if>

                        <!-- Available Trips -->
                        <c:if test="${not empty guide.availableTrips}">
                            <div class="mb-3">
                                <span class="text-sm font-medium text-gray-700">Available Trips:</span>
                                <p class="text-gray-600 text-sm mt-1">${guide.availableTrips}</p>
                            </div>
                        </c:if>

                        <div class="flex justify-between items-center mt-4 pt-4 border-t border-gray-200">
                            <span class="text-2xl font-bold text-blue-600">
                                Rs.<fmt:formatNumber value="${guide.dailyRate}" pattern="#,##0.00"/>/day
                            </span>
                            <a href="${pageContext.request.contextPath}/guides/sightings?guideId=${guide.guideId}"
                               class="inline-flex items-center px-4 py-2 bg-green-600 text-white text-sm font-medium rounded-lg hover:bg-green-700 transition duration-200">
                                <i class="fas fa-binoculars mr-2"></i>
                                View Sightings
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Empty State -->
        <c:if test="${empty guides}">
            <div class="text-center py-12">
                <i class="fas fa-users text-6xl text-gray-300 mb-4"></i>
                <h3 class="text-2xl font-bold text-gray-600 mb-2">No Guides Available</h3>
                <p class="text-gray-500 mb-6">We don't have any guides registered yet.</p>
                <a href="${pageContext.request.contextPath}/guides/register"
                   class="inline-flex items-center px-6 py-3 bg-blue-600 text-white font-semibold rounded-lg hover:bg-blue-700 transition duration-200">
                    <i class="fas fa-plus mr-2"></i>
                    Register First Guide
                </a>
            </div>
        </c:if>
    </div>
</div>
<%@ include file="../Footer.jsp" %>
</body>
</html>