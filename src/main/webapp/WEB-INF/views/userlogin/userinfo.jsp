<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WildTrails - My Profile</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-50">
<%@ include file="../Header.jsp" %>

<div class="min-h-screen py-8">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <!-- Header -->
        <div class="text-center mb-8">
            <h1 class="text-3xl font-bold text-gray-900 mb-2">My Profile</h1>
            <p class="text-gray-600">Manage your account information</p>
            <a href="${pageContext.request.contextPath}/homepage/index.html"
               class="inline-flex items-center text-green-600 hover:text-green-700 mt-4">
                <i class="fas fa-arrow-left mr-2"></i>
                Back to Homepage
            </a>
        </div>

        <!-- User Information Card -->
        <div class="bg-white rounded-xl shadow-lg overflow-hidden">
            <!-- Profile Header -->
            <div class="bg-green-600 px-6 py-8">
                <div class="flex items-center">
                    <div class="w-20 h-20 bg-white bg-opacity-20 rounded-full flex items-center justify-center">
                        <i class="fas fa-user text-white text-3xl"></i>
                    </div>
                    <div class="ml-6">
                        <h2 class="text-2xl font-bold text-white">${user.firstName} ${user.lastName}</h2>
                        <p class="text-green-100">${user.userType} Traveler</p>
                        <p class="text-green-100 text-sm mt-1">Member since ${user.createdDate != null ? user.createdDate : 'Recently'}</p>
                    </div>
                </div>
            </div>

            <!-- User Details -->
            <div class="p-6">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <!-- Personal Information -->
                    <div>
                        <h3 class="text-lg font-semibold text-gray-900 mb-4 border-b pb-2">Personal Information</h3>
                        <div class="space-y-4">
                            <div class="flex justify-between">
                                <span class="font-medium text-gray-700">First Name:</span>
                                <span class="text-gray-900">${user.firstName}</span>
                            </div>
                            <div class="flex justify-between">
                                <span class="font-medium text-gray-700">Last Name:</span>
                                <span class="text-gray-900">${user.lastName}</span>
                            </div>
                            <div class="flex justify-between">
                                <span class="font-medium text-gray-700">User Type:</span>
                                <span class="text-gray-900 capitalize">${user.userType}</span>
                            </div>
                            <div class="flex justify-between">
                                <span class="font-medium text-gray-700">Country:</span>
                                <span class="text-gray-900">${user.country}</span>
                            </div>
                        </div>
                    </div>

                    <!-- Contact Information -->
                    <div>
                        <h3 class="text-lg font-semibold text-gray-900 mb-4 border-b pb-2">Contact Information</h3>
                        <div class="space-y-4">
                            <div class="flex justify-between">
                                <span class="font-medium text-gray-700">Email:</span>
                                <span class="text-gray-900">${user.email}</span>
                            </div>
                            <div class="flex justify-between">
                                <span class="font-medium text-gray-700">Phone:</span>
                                <span class="text-gray-900">${user.phoneNumber}</span>
                            </div>
                            <div class="flex justify-between">
                                <span class="font-medium text-gray-700">Address:</span>
                                <span class="text-gray-900">${user.address}</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Account Status -->
                <div class="mt-8 p-4 bg-green-50 rounded-lg">
                    <div class="flex items-center">
                        <i class="fas fa-check-circle text-green-500 text-xl mr-3"></i>
                        <div>
                            <h4 class="font-semibold text-green-800">Account Status</h4>
                            <p class="text-green-700 text-sm">Your account is active and in good standing</p>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="mt-8 flex flex-wrap gap-4 justify-center">
                    <a href="${pageContext.request.contextPath}/homepage/index.html"
                       class="inline-flex items-center px-6 py-3 bg-green-600 text-white font-medium rounded-lg hover:bg-green-700 transition duration-200">
                        <i class="fas fa-home mr-2"></i>
                        Go to Homepage
                    </a>
                    <a href="${pageContext.request.contextPath}/tours"
                       class="inline-flex items-center px-6 py-3 bg-blue-600 text-white font-medium rounded-lg hover:bg-blue-700 transition duration-200">
                        <i class="fas fa-map-marked-alt mr-2"></i>
                        Browse Tours
                    </a>
                    <a href="${pageContext.request.contextPath}/userlogin/logout"
                       class="inline-flex items-center px-6 py-3 bg-red-600 text-white font-medium rounded-lg hover:bg-red-700 transition duration-200">
                        <i class="fas fa-sign-out-alt mr-2"></i>
                        Logout
                    </a>
                </div>
            </div>
        </div>

        <!-- Quick Stats (Optional - can be used for future features) -->
        <div class="mt-8 grid grid-cols-1 md:grid-cols-3 gap-6">
            <div class="bg-white rounded-lg p-6 text-center shadow-md">
                <div class="w-12 h-12 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-3">
                    <i class="fas fa-calendar-check text-green-600 text-xl"></i>
                </div>
                <div class="text-2xl font-bold text-gray-900">0</div>
                <div class="text-sm text-gray-600">Booked Tours</div>
            </div>
            <div class="bg-white rounded-lg p-6 text-center shadow-md">
                <div class="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-3">
                    <i class="fas fa-car text-blue-600 text-xl"></i>
                </div>
                <div class="text-2xl font-bold text-gray-900">0</div>
                <div class="text-sm text-gray-600">Vehicle Bookings</div>
            </div>
            <div class="bg-white rounded-lg p-6 text-center shadow-md">
                <div class="w-12 h-12 bg-purple-100 rounded-full flex items-center justify-center mx-auto mb-3">
                    <i class="fas fa-shield-alt text-purple-600 text-xl"></i>
                </div>
                <div class="text-2xl font-bold text-gray-900">0</div>
                <div class="text-sm text-gray-600">Insurance Plans</div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../Footer.jsp" %>
</body>
</html>