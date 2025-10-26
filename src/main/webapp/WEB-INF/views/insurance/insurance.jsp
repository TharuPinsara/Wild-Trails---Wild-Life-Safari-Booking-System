<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WildTrails - Travel Insurance</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-50">
<%@ include file="../Header.jsp" %>

<div class="min-h-screen py-8">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <!-- Header Section -->
        <div class="text-center mb-12">
            <h1 class="text-4xl font-bold text-gray-900 mb-4">Travel Insurance Plans</h1>
            <p class="text-lg text-gray-600 max-w-3xl mx-auto">
                Protect your wildlife adventure with comprehensive travel insurance.
                Choose from our range of plans designed for both foreign and local travelers.
            </p>
            <div class="mt-6">
                <a href="${pageContext.request.contextPath}/insurance/admin"
                   class="inline-flex items-center px-6 py-3 bg-green-600 text-white font-semibold rounded-lg hover:bg-green-700 transition duration-200">
                    <i class="fas fa-cog mr-2"></i>
                    Admin Portal
                </a>
            </div>
        </div>

        <!-- Foreign Travelers Section -->
        <div class="mb-16">
            <h2 class="text-3xl font-bold text-gray-900 mb-8 text-center">Insurance for Foreign Travelers</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                <c:forEach var="plan" items="${foreignPlans}">
                    <div class="bg-white rounded-xl shadow-lg overflow-hidden hover:shadow-xl transition duration-300">
                        <div class="bg-blue-600 p-4 text-white">
                            <h3 class="text-xl font-bold">${plan.companyName}</h3>
                            <p class="text-blue-100">${plan.coverageType} Coverage</p>
                        </div>
                        <div class="p-6">
                            <div class="text-center mb-4">
                                <span class="text-3xl font-bold text-green-600">
                                    $<fmt:formatNumber value="${plan.pricePerDayPerPerson}" pattern="#,##0.00"/>
                                </span>
                                <span class="text-gray-600">/day/person</span>
                            </div>

                            <div class="space-y-3 mb-6">
                                <div class="flex justify-between">
                                    <span class="font-semibold text-gray-700">Coverage Type:</span>
                                    <span class="text-gray-900 capitalize">${plan.coverageType}</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="font-semibold text-gray-700">Max Duration:</span>
                                    <span class="text-gray-900">${plan.maxDays} days</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="font-semibold text-gray-700">Traveler Type:</span>
                                    <span class="text-gray-900 capitalize">${plan.insuranceType}</span>
                                </div>
                            </div>

                            <c:if test="${not empty plan.description}">
                                <div class="mb-4">
                                    <h4 class="font-semibold text-gray-900 mb-2">Description</h4>
                                    <p class="text-gray-600 text-sm">${plan.description}</p>
                                </div>
                            </c:if>

                            <c:if test="${not empty plan.specialFeatures}">
                                <div class="mb-6">
                                    <h4 class="font-semibold text-gray-900 mb-2">Special Features</h4>
                                    <div class="space-y-1">
                                        <c:forEach var="feature" items="${plan.specialFeatures.split(',')}">
                                            <div class="flex items-center text-sm text-gray-600">
                                                <i class="fas fa-check text-green-500 mr-2"></i>
                                                    ${feature.trim()}
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:if>

                            <div class="flex space-x-3">
                                <button class="flex-1 bg-blue-600 text-white py-2 px-4 rounded-lg hover:bg-blue-700 transition duration-200">
                                    Select Plan
                                </button>
                                <button class="bg-gray-200 text-gray-700 py-2 px-4 rounded-lg hover:bg-gray-300 transition duration-200">
                                    <i class="fas fa-info-circle"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <c:if test="${empty foreignPlans}">
                <div class="text-center py-12 bg-white rounded-xl shadow-lg">
                    <i class="fas fa-passport text-6xl text-gray-300 mb-4"></i>
                    <h3 class="text-2xl font-bold text-gray-600 mb-2">No Insurance Plans Available</h3>
                    <p class="text-gray-500">We don't have any insurance plans for foreign travelers at the moment.</p>
                </div>
            </c:if>
        </div>

        <!-- Local Travelers Section -->
        <div class="mb-16">
            <h2 class="text-3xl font-bold text-gray-900 mb-8 text-center">Insurance for Local Travelers</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                <c:forEach var="plan" items="${localPlans}">
                    <div class="bg-white rounded-xl shadow-lg overflow-hidden hover:shadow-xl transition duration-300">
                        <div class="bg-green-600 p-4 text-white">
                            <h3 class="text-xl font-bold">${plan.companyName}</h3>
                            <p class="text-green-100">${plan.coverageType} Coverage</p>
                        </div>
                        <div class="p-6">
                            <div class="text-center mb-4">
                                <span class="text-3xl font-bold text-green-600">
                                    Rs.<fmt:formatNumber value="${plan.pricePerDayPerPerson}" pattern="#,##0.00"/>
                                </span>
                                <span class="text-gray-600">/day/person</span>
                            </div>

                            <div class="space-y-3 mb-6">
                                <div class="flex justify-between">
                                    <span class="font-semibold text-gray-700">Coverage Type:</span>
                                    <span class="text-gray-900 capitalize">${plan.coverageType}</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="font-semibold text-gray-700">Max Duration:</span>
                                    <span class="text-gray-900">${plan.maxDays} days</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="font-semibold text-gray-700">Traveler Type:</span>
                                    <span class="text-gray-900 capitalize">${plan.insuranceType}</span>
                                </div>
                            </div>

                            <c:if test="${not empty plan.description}">
                                <div class="mb-4">
                                    <h4 class="font-semibold text-gray-900 mb-2">Description</h4>
                                    <p class="text-gray-600 text-sm">${plan.description}</p>
                                </div>
                            </c:if>

                            <c:if test="${not empty plan.specialFeatures}">
                                <div class="mb-6">
                                    <h4 class="font-semibold text-gray-900 mb-2">Special Features</h4>
                                    <div class="space-y-1">
                                        <c:forEach var="feature" items="${plan.specialFeatures.split(',')}">
                                            <div class="flex items-center text-sm text-gray-600">
                                                <i class="fas fa-check text-green-500 mr-2"></i>
                                                    ${feature.trim()}
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:if>

                            <div class="flex space-x-3">
                                <button class="flex-1 bg-green-600 text-white py-2 px-4 rounded-lg hover:bg-green-700 transition duration-200">
                                    Select Plan
                                </button>
                                <button class="bg-gray-200 text-gray-700 py-2 px-4 rounded-lg hover:bg-gray-300 transition duration-200">
                                    <i class="fas fa-info-circle"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <c:if test="${empty localPlans}">
                <div class="text-center py-12 bg-white rounded-xl shadow-lg">
                    <i class="fas fa-user text-6xl text-gray-300 mb-4"></i>
                    <h3 class="text-2xl font-bold text-gray-600 mb-2">No Insurance Plans Available</h3>
                    <p class="text-gray-500">We don't have any insurance plans for local travelers at the moment.</p>
                </div>
            </c:if>
        </div>
    </div>
</div>

<%@ include file="../Footer.jsp" %>
</body>
</html>