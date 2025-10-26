<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WildTrails - Update Vehicle</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-50">
<%@ include file="../Header.jsp" %>

<div class="min-h-screen py-8">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">

        <c:if test="${empty sessionScope.driverLoggedIn}">
            <div class="text-center">
                <h1 class="text-2xl font-bold text-gray-900 mb-4">Access Denied</h1>
                <p class="text-gray-600 mb-4">Please login to update your vehicle information.</p>
                <a href="${pageContext.request.contextPath}/vehicles/admin"
                   class="inline-flex items-center px-6 py-3 bg-green-600 text-white font-medium rounded-lg hover:bg-green-700 transition duration-200">
                    <i class="fas fa-sign-in-alt mr-2"></i>Driver Login
                </a>
            </div>
        </c:if>

        <c:if test="${not empty sessionScope.driverLoggedIn}">
            <!-- Header -->
            <div class="text-center mb-8">
                <h1 class="text-3xl font-bold text-gray-900 mb-2">Update Vehicle Information</h1>
                <p class="text-gray-600">Update your vehicle details and preferences</p>
                <div class="mt-4 space-x-4">
                    <a href="${pageContext.request.contextPath}/vehicles/admin/dashboard"
                       class="inline-flex items-center text-green-600 hover:text-green-700">
                        <i class="fas fa-arrow-left mr-2"></i>Back to Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/vehicles/admin/schedule"
                       class="inline-flex items-center text-blue-600 hover:text-blue-700">
                        <i class="fas fa-calendar mr-2"></i>Manage Schedule
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

            <!-- Update Form -->
            <div class="bg-white rounded-xl shadow-lg p-8">
                <form action="${pageContext.request.contextPath}/vehicles/update/${vehicle.vehicleId}" method="post" enctype="multipart/form-data" class="space-y-8">

                    <!-- Driver Information -->
                    <div>
                        <h2 class="text-xl font-bold text-gray-900 mb-6">Driver Information</h2>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label for="driverName" class="block text-sm font-medium text-gray-700 mb-2">Driver Name *</label>
                                <input type="text" id="driverName" name="driverName" required
                                       value="${vehicle.driverName}"
                                       class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200"
                                       placeholder="Enter driver name">
                            </div>

                            <div>
                                <label for="driverPhone" class="block text-sm font-medium text-gray-700 mb-2">Phone Number *</label>
                                <input type="tel" id="driverPhone" name="driverPhone" required
                                       value="${vehicle.driverPhone}"
                                       class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200"
                                       placeholder="Enter phone number">
                            </div>

                            <div>
                                <label for="driverEmail" class="block text-sm font-medium text-gray-700 mb-2">Email Address</label>
                                <input type="email" id="driverEmail" name="driverEmail"
                                       value="${vehicle.driverEmail}"
                                       class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200"
                                       placeholder="Enter email address">
                            </div>

                            <div>
                                <label for="password" class="block text-sm font-medium text-gray-700 mb-2">New Password (Leave blank to keep current)</label>
                                <input type="password" id="password" name="password"
                                       class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200"
                                       placeholder="Enter new password (min 8 characters)">
                                <p class="text-xs text-gray-500 mt-1">Leave blank if you don't want to change the password</p>
                            </div>
                        </div>
                    </div>

                    <!-- Vehicle Information -->
                    <div>
                        <h2 class="text-xl font-bold text-gray-900 mb-6">Vehicle Information</h2>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label for="vehicleName" class="block text-sm font-medium text-gray-700 mb-2">Vehicle Name *</label>
                                <input type="text" id="vehicleName" name="vehicleName" required
                                       value="${vehicle.vehicleName}"
                                       class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200"
                                       placeholder="Enter vehicle name">
                            </div>

                            <div>
                                <label for="vehicleType" class="block text-sm font-medium text-gray-700 mb-2">Vehicle Type *</label>
                                <select id="vehicleType" name="vehicleType" required
                                        class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200">
                                    <option value="">Select vehicle type</option>
                                    <option value="Car" ${vehicle.vehicleType == 'Car' ? 'selected' : ''}>Car</option>
                                    <option value="SUV" ${vehicle.vehicleType == 'SUV' ? 'selected' : ''}>SUV</option>
                                    <option value="Van" ${vehicle.vehicleType == 'Van' ? 'selected' : ''}>Van</option>
                                    <option value="Bus" ${vehicle.vehicleType == 'Bus' ? 'selected' : ''}>Bus</option>
                                    <option value="Luxury" ${vehicle.vehicleType == 'Luxury' ? 'selected' : ''}>Luxury</option>
                                </select>
                            </div>

                            <div>
                                <label for="capacity" class="block text-sm font-medium text-gray-700 mb-2">Passenger Capacity *</label>
                                <input type="number" id="capacity" name="capacity" required min="1" max="50"
                                       value="${vehicle.capacity}"
                                       class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200"
                                       placeholder="Enter capacity">
                            </div>

                            <div>
                                <label for="dailyRate" class="block text-sm font-medium text-gray-700 mb-2">Daily Rate (Rs.) *</label>
                                <input type="number" id="dailyRate" name="dailyRate" required min="0" step="0.01"
                                       value="${vehicle.dailyRate}"
                                       class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200"
                                       placeholder="Enter daily rate">
                            </div>
                        </div>
                    </div>

                    <!-- Vehicle Status -->
                    <div>
                        <h2 class="text-xl font-bold text-gray-900 mb-6">Vehicle Status</h2>
                        <div class="flex items-center space-x-4">
                            <label class="flex items-center">
                                <input type="radio" name="vehicleReady" value="true" ${vehicle.vehicleReady ? 'checked' : ''}
                                       class="w-4 h-4 text-green-600 focus:ring-green-500 border-gray-300">
                                <span class="ml-2 text-sm font-medium text-gray-700">Active (Accepting bookings)</span>
                            </label>
                            <label class="flex items-center">
                                <input type="radio" name="vehicleReady" value="false" ${!vehicle.vehicleReady ? 'checked' : ''}
                                       class="w-4 h-4 text-red-600 focus:ring-red-500 border-gray-300">
                                <span class="ml-2 text-sm font-medium text-gray-700">Inactive (Not accepting bookings)</span>
                            </label>
                        </div>
                    </div>

                    <!-- Inclusions -->
                    <div>
                        <h2 class="text-xl font-bold text-gray-900 mb-6">Vehicle Inclusions</h2>
                        <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
                            <c:set var="currentInclusions" value="${vehicle.inclusions != null ? vehicle.inclusions.split(',') : []}" />
                            <label class="flex items-center">
                                <input type="checkbox" name="inclusions" value="AC"
                                       <c:forEach var="inc" items="${currentInclusions}"><c:if test="${inc.trim() == 'AC'}">checked</c:if></c:forEach>
                                       class="w-4 h-4 text-green-600 focus:ring-green-500 border-gray-300 rounded">
                                <span class="ml-2 text-sm text-gray-700">Air Conditioning</span>
                            </label>
                            <label class="flex items-center">
                                <input type="checkbox" name="inclusions" value="Music System"
                                       <c:forEach var="inc" items="${currentInclusions}"><c:if test="${inc.trim() == 'Music System'}">checked</c:if></c:forEach>
                                       class="w-4 h-4 text-green-600 focus:ring-green-500 border-gray-300 rounded">
                                <span class="ml-2 text-sm text-gray-700">Music System</span>
                            </label>
                            <label class="flex items-center">
                                <input type="checkbox" name="inclusions" value="Charging Ports"
                                       <c:forEach var="inc" items="${currentInclusions}"><c:if test="${inc.trim() == 'Charging Ports'}">checked</c:if></c:forEach>
                                       class="w-4 h-4 text-green-600 focus:ring-green-500 border-gray-300 rounded">
                                <span class="ml-2 text-sm text-gray-700">Charging Ports</span>
                            </label>
                            <label class="flex items-center">
                                <input type="checkbox" name="inclusions" value="WiFi"
                                       <c:forEach var="inc" items="${currentInclusions}"><c:if test="${inc.trim() == 'WiFi'}">checked</c:if></c:forEach>
                                       class="w-4 h-4 text-green-600 focus:ring-green-500 border-gray-300 rounded">
                                <span class="ml-2 text-sm text-gray-700">WiFi</span>
                            </label>
                            <label class="flex items-center">
                                <input type="checkbox" name="inclusions" value="GPS"
                                       <c:forEach var="inc" items="${currentInclusions}"><c:if test="${inc.trim() == 'GPS'}">checked</c:if></c:forEach>
                                       class="w-4 h-4 text-green-600 focus:ring-green-500 border-gray-300 rounded">
                                <span class="ml-2 text-sm text-gray-700">GPS Navigation</span>
                            </label>
                            <label class="flex items-center">
                                <input type="checkbox" name="inclusions" value="Luggage Space"
                                       <c:forEach var="inc" items="${currentInclusions}"><c:if test="${inc.trim() == 'Luggage Space'}">checked</c:if></c:forEach>
                                       class="w-4 h-4 text-green-600 focus:ring-green-500 border-gray-300 rounded">
                                <span class="ml-2 text-sm text-gray-700">Luggage Space</span>
                            </label>
                        </div>
                    </div>

                    <!-- Special Features -->
                    <div>
                        <label for="specialFeatures" class="block text-sm font-medium text-gray-700 mb-2">Special Features</label>
                        <textarea id="specialFeatures" name="specialFeatures" rows="4"
                                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200"
                                  placeholder="Describe any special features of your vehicle...">${vehicle.specialFeatures}</textarea>
                    </div>

                    <!-- Photo Uploads -->
                    <div>
                        <h2 class="text-xl font-bold text-gray-900 mb-6">Update Photos (Optional)</h2>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label for="driverPhotoFile" class="block text-sm font-medium text-gray-700 mb-2">Driver Photo</label>
                                <input type="file" id="driverPhotoFile" name="driverPhotoFile" accept="image/*"
                                       class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200">
                                <p class="text-xs text-gray-500 mt-1">Leave blank to keep current photo</p>
                            </div>

                            <div>
                                <label for="vehiclePhotoFile" class="block text-sm font-medium text-gray-700 mb-2">Vehicle Photo</label>
                                <input type="file" id="vehiclePhotoFile" name="vehiclePhotoFile" accept="image/*"
                                       class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200">
                                <p class="text-xs text-gray-500 mt-1">Leave blank to keep current photo</p>
                            </div>
                        </div>
                    </div>

                    <!-- Form Actions -->
                    <div class="flex justify-end space-x-4 pt-6 border-t border-gray-200">
                        <a href="${pageContext.request.contextPath}/vehicles/admin/dashboard"
                           class="px-6 py-3 border border-gray-300 text-gray-700 font-medium rounded-lg hover:bg-gray-50 transition duration-200">
                            <i class="fas fa-times mr-2"></i>Cancel
                        </a>
                        <button type="submit"
                                class="px-6 py-3 bg-green-600 text-white font-medium rounded-lg hover:bg-green-700 transition duration-200">
                            <i class="fas fa-save mr-2"></i>Update Vehicle
                        </button>
                    </div>
                </form>
            </div>
        </c:if>
    </div>
</div>

<%@ include file="../Footer.jsp" %>
</body>
</html>
