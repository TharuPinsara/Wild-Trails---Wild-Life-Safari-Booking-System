<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WildTrails - Insurance Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-50">
<%@ include file="../Header.jsp" %>

<div class="min-h-screen py-8">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">

        <c:if test="${empty sessionScope.insuranceAdminLoggedIn}">
            <!-- Admin Login Form -->
            <div class="max-w-md mx-auto bg-white rounded-xl shadow-lg p-8">
                <div class="text-center mb-8">
                    <h1 class="text-2xl font-bold text-gray-900 mb-2">Insurance Admin Login</h1>
                    <p class="text-gray-600">Access insurance management portal</p>
                </div>

                <c:if test="${not empty error}">
                    <div class="mb-6 p-4 bg-red-100 border border-red-400 text-red-700 rounded-lg">
                        <div class="flex items-center">
                            <i class="fas fa-exclamation-circle mr-2"></i>
                                ${error}
                        </div>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/insurance/admin" method="post" class="space-y-6">
                    <div>
                        <label for="username" class="block text-sm font-medium text-gray-700 mb-2">Username *</label>
                        <input type="text" id="username" name="username" required
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200"
                               placeholder="Enter admin username">
                    </div>

                    <div>
                        <label for="password" class="block text-sm font-medium text-gray-700 mb-2">Password *</label>
                        <input type="password" id="password" name="password" required
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200"
                               placeholder="Enter admin password">
                    </div>

                    <div class="flex justify-end space-x-4 pt-4">
                        <a href="${pageContext.request.contextPath}/insurance"
                           class="px-6 py-3 border border-gray-300 text-gray-700 font-medium rounded-lg hover:bg-gray-50 transition duration-200">
                            Cancel
                        </a>
                        <button type="submit"
                                class="px-6 py-3 bg-green-600 text-white font-medium rounded-lg hover:bg-green-700 transition duration-200">
                            <i class="fas fa-sign-in-alt mr-2"></i>
                            Login
                        </button>
                    </div>
                </form>
            </div>
        </c:if>

        <c:if test="${not empty sessionScope.insuranceAdminLoggedIn}">
            <!-- Admin Dashboard -->
            <div class="text-center mb-8">
                <h1 class="text-3xl font-bold text-gray-900 mb-2">Insurance Management</h1>
                <p class="text-gray-600">Manage insurance plans and pricing</p>
                <div class="mt-4 space-x-4">
                    <a href="${pageContext.request.contextPath}/insurance"
                       class="inline-flex items-center text-green-600 hover:text-green-700">
                        <i class="fas fa-eye mr-2"></i>View Public Page
                    </a>
                    <a href="${pageContext.request.contextPath}/insurance/logout"
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

            <!-- Add New Insurance Form -->
            <div class="bg-white rounded-xl shadow-lg p-6 mb-8">
                <h2 class="text-2xl font-bold text-gray-900 mb-6">Add New Insurance Plan</h2>
                <form action="${pageContext.request.contextPath}/insurance/admin/add" method="post" class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                        <label for="companyName" class="block text-sm font-medium text-gray-700 mb-2">Insurance Company *</label>
                        <input type="text" id="companyName" name="companyName" required
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent"
                               placeholder="e.g., Ceylinco Insurance">
                    </div>

                    <div>
                        <label for="insuranceType" class="block text-sm font-medium text-gray-700 mb-2">Traveler Type *</label>
                        <select id="insuranceType" name="insuranceType" required
                                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent">
                            <option value="">Select traveler type</option>
                            <option value="foreign">Foreign Tourist</option>
                            <option value="local">Local Traveler</option>
                        </select>
                    </div>

                    <div>
                        <label for="coverageType" class="block text-sm font-medium text-gray-700 mb-2">Coverage Type *</label>
                        <select id="coverageType" name="coverageType" required
                                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent">
                            <option value="">Select coverage type</option>
                            <option value="full">Full Coverage</option>
                            <option value="half">Half Coverage</option>
                            <option value="basic">Basic Coverage</option>
                            <option value="premium">Premium Coverage</option>
                        </select>
                    </div>

                    <div>
                        <label for="pricePerDayPerPerson" class="block text-sm font-medium text-gray-700 mb-2">Price per Day per Person *</label>
                        <input type="number" id="pricePerDayPerPerson" name="pricePerDayPerPerson" required step="0.01" min="0"
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent"
                               placeholder="0.00">
                    </div>

                    <div>
                        <label for="maxDays" class="block text-sm font-medium text-gray-700 mb-2">Maximum Days *</label>
                        <input type="number" id="maxDays" name="maxDays" required min="1" max="365"
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent"
                               placeholder="30">
                    </div>

                    <div class="md:col-span-2">
                        <label for="description" class="block text-sm font-medium text-gray-700 mb-2">Description</label>
                        <textarea id="description" name="description" rows="3"
                                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent"
                                  placeholder="Brief description of the insurance plan..."></textarea>
                    </div>

                    <div class="md:col-span-2">
                        <label for="specialFeatures" class="block text-sm font-medium text-gray-700 mb-2">Special Features (comma separated)</label>
                        <textarea id="specialFeatures" name="specialFeatures" rows="3"
                                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent"
                                  placeholder="Medical coverage, Trip cancellation, Lost baggage..."></textarea>
                    </div>

                    <div class="md:col-span-2 flex justify-end">
                        <button type="submit"
                                class="px-6 py-3 bg-green-600 text-white font-medium rounded-lg hover:bg-green-700 transition duration-200">
                            <i class="fas fa-plus mr-2"></i>
                            Add Insurance Plan
                        </button>
                    </div>
                </form>
            </div>

            <!-- Existing Insurance Plans -->
            <div class="bg-white rounded-xl shadow-lg p-6 mb-8">
                <h2 class="text-2xl font-bold text-gray-900 mb-6">Existing Insurance Plans</h2>

                <c:if test="${not empty insurancePlans}">
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Company</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Type</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Coverage</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Price/Day</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Max Days</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                            </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                            <c:forEach var="plan" items="${insurancePlans}">
                                <tr>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">${plan.insuranceId}</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${plan.companyName}</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 capitalize">${plan.insuranceType}</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 capitalize">${plan.coverageType}</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                        <c:choose>
                                            <c:when test="${plan.insuranceType == 'foreign'}">
                                                $<fmt:formatNumber value="${plan.pricePerDayPerPerson}" pattern="#,##0.00"/>
                                            </c:when>
                                            <c:otherwise>
                                                Rs.<fmt:formatNumber value="${plan.pricePerDayPerPerson}" pattern="#,##0.00"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${plan.maxDays}</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium space-x-2">
                                        <a href="${pageContext.request.contextPath}/insurance/admin/edit/${plan.insuranceId}"
                                           class="text-blue-600 hover:text-blue-900">
                                            <i class="fas fa-edit"></i> Edit
                                        </a>
                                        <form action="${pageContext.request.contextPath}/insurance/admin/delete/${plan.insuranceId}" method="post" class="inline">
                                            <button type="submit"
                                                    onclick="return confirm('Are you sure you want to delete ${plan.insuranceId}?')"
                                                    class="text-red-600 hover:text-red-900">
                                                <i class="fas fa-trash"></i> Delete
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>

                <c:if test="${empty insurancePlans}">
                    <div class="text-center py-12">
                        <i class="fas fa-shield-alt text-6xl text-gray-300 mb-4"></i>
                        <h3 class="text-2xl font-bold text-gray-600 mb-2">No Insurance Plans</h3>
                        <p class="text-gray-500">No insurance plans have been added yet.</p>
                    </div>
                </c:if>
            </div>

            <!-- Insurance Bookings Section -->
            <div class="bg-white rounded-xl shadow-lg p-6">
                <h2 class="text-2xl font-bold text-gray-900 mb-6">Insurance Bookings</h2>

                <c:if test="${not empty insuranceBookings}">
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Booking ID</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Insurance ID</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Company</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Type</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Persons</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Days</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Total Cost</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Created At</th>
                            </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                            <c:forEach var="booking" items="${insuranceBookings}">
                                <tr>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">${booking.bookingId}</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${booking.insuranceId}</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${booking.companyName}</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 capitalize">${booking.insuranceType}</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${booking.numberOfPersons}</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${booking.durationDays}</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                        <c:choose>
                                            <c:when test="${booking.insuranceType == 'foreign'}">
                                                $<fmt:formatNumber value="${booking.totalInsuranceCost}" pattern="#,##0.00"/>
                                            </c:when>
                                            <c:otherwise>
                                                Rs.<fmt:formatNumber value="${booking.totalInsuranceCost}" pattern="#,##0.00"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                        <!-- Fixed date formatting for LocalDateTime -->
                                            ${booking.createdAt}
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>

                <c:if test="${empty insuranceBookings}">
                    <div class="text-center py-12">
                        <i class="fas fa-file-alt text-6xl text-gray-300 mb-4"></i>
                        <h3 class="text-2xl font-bold text-gray-600 mb-2">No Insurance Bookings</h3>
                        <p class="text-gray-500">No insurance bookings have been made yet.</p>
                    </div>
                </c:if>
            </div>
        </c:if>
    </div>
</div>

<%@ include file="../Footer.jsp" %>
</body>
</html>