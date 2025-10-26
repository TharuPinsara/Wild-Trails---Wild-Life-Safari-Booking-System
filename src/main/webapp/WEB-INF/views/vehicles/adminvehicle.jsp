<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WildTrails - Vehicle Driver Portal</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-50">
<%@ include file="../Header.jsp" %>

<div class="min-h-screen py-8">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">

        <c:if test="${empty sessionScope.driverLoggedIn}">
            <!-- Driver Login Form -->
            <div class="max-w-md mx-auto bg-white rounded-xl shadow-lg p-8">
                <div class="text-center mb-8">
                    <h1 class="text-2xl font-bold text-gray-900 mb-2">Vehicle Driver Login</h1>
                    <p class="text-gray-600">Access your vehicle management portal</p>
                </div>

                <c:if test="${not empty error}">
                    <div class="mb-6 p-4 bg-red-100 border border-red-400 text-red-700 rounded-lg">
                        <div class="flex items-center">
                            <i class="fas fa-exclamation-circle mr-2"></i>
                                ${error}
                        </div>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/vehicles/admin" method="post" class="space-y-6">
                    <div>
                        <label for="driverEmail" class="block text-sm font-medium text-gray-700 mb-2">Driver Email *</label>
                        <input type="email" id="driverEmail" name="driverEmail" required
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200"
                               placeholder="Enter your registered email">
                    </div>

                    <div>
                        <label for="password" class="block text-sm font-medium text-gray-700 mb-2">Password *</label>
                        <input type="password" id="password" name="password" required
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200"
                               placeholder="Enter your password">
                    </div>

                    <input type="hidden" name="login" value="true">

                    <!-- Cancel and Login Buttons in one row -->
                    <div class="flex justify-end space-x-4 pt-4">
                        <a href="${pageContext.request.contextPath}/vehicles"
                           class="px-6 py-3 border border-gray-300 text-gray-700 font-medium rounded-lg hover:bg-gray-50 transition duration-200">
                            Cancel
                        </a>
                        <button type="submit"
                                class="px-6 py-3 bg-green-600 text-white font-medium rounded-lg hover:bg-green-700 transition duration-200">
                            <i class="fas fa-sign-in-alt mr-2"></i>
                            Login
                        </button>
                    </div>

                    <!-- Create New Account Button below -->
                    <div class="pt-4 border-t border-gray-200">
                        <a href="${pageContext.request.contextPath}/vehicles/register"
                           class="w-full inline-flex justify-center items-center px-6 py-3 border border-green-600 text-green-600 font-medium rounded-lg hover:bg-green-50 transition duration-200">
                            <i class="fas fa-user-plus mr-2"></i>
                            Create New Account
                        </a>
                    </div>
                </form>

                <!-- Additional Help Text -->
                <div class="mt-6 p-4 bg-blue-50 rounded-lg">
                    <div class="flex items-start">
                        <i class="fas fa-info-circle text-blue-500 mt-1 mr-2"></i>
                        <div>
                            <p class="text-sm text-blue-700">
                                <strong>New driver?</strong> Click "Create New Account" to register your vehicle and start accepting bookings.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>

        <c:if test="${not empty sessionScope.driverLoggedIn}">
            <!-- Driver Dashboard -->
            <div class="text-center mb-8">
                <h1 class="text-3xl font-bold text-gray-900 mb-2">Vehicle Driver Portal</h1>
                <p class="text-gray-600">Manage your vehicle and schedules</p>
                <div class="mt-4 space-x-4">
                    <a href="${pageContext.request.contextPath}/vehicles"
                       class="inline-flex items-center text-green-600 hover:text-green-700">
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

            <!-- Status Toggle Button -->
            <div class="mb-6 flex justify-end">
                <form action="${pageContext.request.contextPath}/vehicles/toggle-status/${vehicle.vehicleId}" method="post" class="inline">
                    <button type="submit"
                            class="flex items-center px-6 py-3 rounded-lg font-medium transition duration-200
                                   ${vehicle.vehicleReady ? 'bg-yellow-600 text-white hover:bg-yellow-700' : 'bg-green-600 text-white hover:bg-green-700'}">
                        <c:choose>
                            <c:when test="${vehicle.vehicleReady}">
                                <i class="fas fa-pause-circle mr-2"></i>Set as Inactive
                            </c:when>
                            <c:otherwise>
                                <i class="fas fa-play-circle mr-2"></i>Set as Active
                            </c:otherwise>
                        </c:choose>
                    </button>
                </form>
            </div>

            <!-- Vehicle Information Card -->
            <div class="bg-white rounded-xl shadow-lg p-6 mb-8">
                <div class="flex justify-between items-start mb-6">
                    <h2 class="text-2xl font-bold text-gray-900">Vehicle Information</h2>
                    <div class="flex items-center space-x-2">
                        <span class="bg-green-100 text-green-800 text-sm font-medium px-3 py-1 rounded-full">
                                ${vehicle.vehicleId}
                        </span>
                        <span class="${vehicle.vehicleReady ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'} text-sm font-medium px-3 py-1 rounded-full">
                                ${vehicle.vehicleReady ? 'ACTIVE' : 'INACTIVE'}
                        </span>
                    </div>
                </div>

                <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                    <!-- Vehicle Details -->
                    <div>
                        <div class="space-y-4">
                            <div class="flex justify-between items-center">
                                <span class="font-semibold text-gray-700">Vehicle Name:</span>
                                <span class="text-gray-900">${vehicle.vehicleName}</span>
                            </div>
                            <div class="flex justify-between items-center">
                                <span class="font-semibold text-gray-700">Vehicle Type:</span>
                                <span class="text-gray-900">${vehicle.vehicleType}</span>
                            </div>
                            <div class="flex justify-between items-center">
                                <span class="font-semibold text-gray-700">Passenger Capacity:</span>
                                <span class="text-gray-900">${vehicle.capacity} passengers</span>
                            </div>
                            <div class="flex justify-between items-center">
                                <span class="font-semibold text-gray-700">Daily Rate:</span>
                                <span class="text-green-600 font-bold">Rs. <fmt:formatNumber value="${vehicle.dailyRate}" pattern="#,##0.00"/></span>
                            </div>
                            <div class="flex justify-between items-center">
                                <span class="font-semibold text-gray-700">Status:</span>
                                <span class="${vehicle.vehicleReady ? 'text-green-600' : 'text-red-600'} font-semibold">
                                        ${vehicle.vehicleReady ? 'Available for Bookings' : 'Not Accepting Bookings'}
                                </span>
                            </div>
                        </div>

                        <!-- Inclusions -->
                        <c:if test="${not empty vehicle.inclusions}">
                            <div class="mt-6">
                                <h3 class="text-lg font-semibold text-gray-900 mb-3">Vehicle Inclusions</h3>
                                <div class="flex flex-wrap gap-2">
                                    <c:forEach var="inclusion" items="${vehicle.inclusions.split(',')}">
                                        <span class="bg-green-100 text-green-800 text-xs font-medium px-3 py-1 rounded">
                                            <i class="fas fa-check mr-1"></i>${inclusion.trim()}
                                        </span>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>

                        <!-- Special Features -->
                        <c:if test="${not empty vehicle.specialFeatures}">
                            <div class="mt-6">
                                <h3 class="text-lg font-semibold text-gray-900 mb-3">Special Features</h3>
                                <p class="text-gray-600">${vehicle.specialFeatures}</p>
                            </div>
                        </c:if>
                    </div>

                    <!-- Vehicle Photo -->
                    <div class="flex justify-center">
                        <div class="w-64 h-64 rounded-lg overflow-hidden border-4 ${vehicle.vehicleReady ? 'border-green-200' : 'border-red-200'}">
                            <c:choose>
                                <c:when test="${not empty vehicle.vehiclePhotoData}">
                                    <img src="${pageContext.request.contextPath}/vehicles/vehicle-photo/${vehicle.vehicleId}"
                                         alt="${vehicle.vehicleName}"
                                         class="w-full h-full object-cover">
                                </c:when>
                                <c:otherwise>
                                    <div class="w-full h-full bg-gray-200 flex items-center justify-center">
                                        <i class="fas fa-car text-6xl text-gray-400"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Driver Information Card -->
            <div class="bg-white rounded-xl shadow-lg p-6 mb-8">
                <h2 class="text-2xl font-bold text-gray-900 mb-6">Driver Information</h2>

                <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                    <!-- Driver Details -->
                    <div class="space-y-4">
                        <div class="flex justify-between items-center">
                            <span class="font-semibold text-gray-700">Driver Name:</span>
                            <span class="text-gray-900">${vehicle.driverName}</span>
                        </div>
                        <div class="flex justify-between items-center">
                            <span class="font-semibold text-gray-700">Phone Number:</span>
                            <span class="text-gray-900">${vehicle.driverPhone}</span>
                        </div>
                        <div class="flex justify-between items-center">
                            <span class="font-semibold text-gray-700">Email:</span>
                            <span class="text-gray-900">${vehicle.driverEmail}</span>
                        </div>
                        <div class="flex justify-between items-center">
                            <span class="font-semibold text-gray-700">Account Status:</span>
                            <span class="text-green-600 font-semibold">Active</span>
                        </div>
                    </div>

                    <!-- Driver Photo -->
                    <div class="flex justify-center">
                        <div class="w-32 h-32 rounded-full overflow-hidden border-4 border-green-200">
                            <c:choose>
                                <c:when test="${not empty vehicle.driverPhotoData}">
                                    <img src="${pageContext.request.contextPath}/vehicles/driver-photo/${vehicle.vehicleId}"
                                         alt="${vehicle.driverName}"
                                         class="w-full h-full object-cover">
                                </c:when>
                                <c:otherwise>
                                    <div class="w-full h-full bg-gray-200 flex items-center justify-center">
                                        <i class="fas fa-user text-3xl text-gray-400"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                <!-- Update Vehicle Info -->
                <div class="bg-white rounded-xl shadow-lg p-6 text-center">
                    <div class="w-16 h-16 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-4">
                        <i class="fas fa-edit text-2xl text-blue-600"></i>
                    </div>
                    <h3 class="text-lg font-semibold text-gray-900 mb-2">Update Information</h3>
                    <p class="text-gray-600 text-sm mb-4">Update your vehicle details and availability</p>
                    <a href="${pageContext.request.contextPath}/vehicles/update/${vehicle.vehicleId}"
                       class="w-full inline-block bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition duration-200">
                        <i class="fas fa-pencil-alt mr-2"></i>Edit Vehicle
                    </a>
                </div>

                <!-- Manage Schedule -->
                <div class="bg-white rounded-xl shadow-lg p-6 text-center">
                    <div class="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
                        <i class="fas fa-calendar-alt text-2xl text-green-600"></i>
                    </div>
                    <h3 class="text-lg font-semibold text-gray-900 mb-2">Manage Schedule</h3>
                    <p class="text-gray-600 text-sm mb-4">View and manage your availability and bookings</p>
                    <a href="${pageContext.request.contextPath}/vehicles/admin/schedule"
                       class="w-full inline-block bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition duration-200">
                        <i class="fas fa-calendar mr-2"></i>View Schedule
                    </a>
                </div>

                <!-- Delete Vehicle -->
                <div class="bg-white rounded-xl shadow-lg p-6 text-center">
                    <div class="w-16 h-16 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-4">
                        <i class="fas fa-trash text-2xl text-red-600"></i>
                    </div>
                    <h3 class="text-lg font-semibold text-gray-900 mb-2">Delete Vehicle</h3>
                    <p class="text-gray-600 text-sm mb-4">Permanently remove your vehicle from the system</p>
                    <form action="${pageContext.request.contextPath}/vehicles/delete-permanent/${vehicle.vehicleId}" method="post" class="inline w-full">
                        <button type="submit"
                                onclick="return confirm('WARNING: This will permanently delete your vehicle and all associated data. This action cannot be undone. Are you sure?')"
                                class="w-full bg-red-600 text-white px-4 py-2 rounded-lg hover:bg-red-700 transition duration-200">
                            <i class="fas fa-trash mr-2"></i>Delete Permanently
                        </button>
                    </form>
                </div>
            </div>

            <!-- Quick Stats -->
            <div class="grid grid-cols-1 md:grid-cols-4 gap-6">
                <div class="bg-green-50 rounded-lg p-4 text-center">
                    <div class="text-2xl font-bold text-green-600">${totalSchedules}</div>
                    <div class="text-sm text-green-800">Total Schedules</div>
                </div>
                <div class="bg-blue-50 rounded-lg p-4 text-center">
                    <div class="text-2xl font-bold text-blue-600">${assignedSchedules}</div>
                    <div class="text-sm text-blue-800">Assigned Trips</div>
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
        </c:if>
    </div>
</div>

<%@ include file="../Footer.jsp" %>
</body>
</html>