<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WildTrails - Add New Tour</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-50 flex flex-col min-h-screen">
<%@ include file="../Header.jsp" %>

<div class="flex-grow py-8">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">

        <c:if test="${empty sessionScope.adminLoggedIn}">
            <!-- Login Form -->
            <div class="max-w-md mx-auto bg-white rounded-xl shadow-lg p-8">
                <div class="text-center mb-8">
                    <h1 class="text-2xl font-bold text-gray-900 mb-2">Admin Login</h1>
                    <p class="text-gray-600">Access tour management system</p>
                </div>

                <c:if test="${not empty error}">
                    <div class="mb-6 p-4 bg-red-100 border border-red-400 text-red-700 rounded-lg">
                        <div class="flex items-center">
                            <i class="fas fa-exclamation-circle mr-2"></i>
                                ${error}
                        </div>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/tours/add" method="post" class="space-y-6">
                    <div>
                        <label for="username" class="block text-sm font-medium text-gray-700 mb-2">Username *</label>
                        <input type="text" id="username" name="username" required
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent transition duration-200"
                               placeholder="Enter admin username">
                    </div>

                    <div>
                        <label for="password" class="block text-sm font-medium text-gray-700 mb-2">Password *</label>
                        <input type="password" id="password" name="password" required
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent transition duration-200"
                               placeholder="Enter admin password">
                    </div>

                    <input type="hidden" name="login" value="true">

                    <div class="flex justify-end space-x-4 pt-6">
                        <a href="${pageContext.request.contextPath}/tours"
                           class="px-6 py-3 border border-gray-300 text-gray-700 font-medium rounded-lg hover:bg-gray-50 transition duration-200">
                            Cancel
                        </a>
                        <button type="submit"
                                class="px-6 py-3 bg-purple-600 text-white font-medium rounded-lg hover:bg-purple-700 transition duration-200">
                            <i class="fas fa-sign-in-alt mr-2"></i>
                            Login
                        </button>
                    </div>
                </form>
            </div>
        </c:if>

        <c:if test="${not empty sessionScope.adminLoggedIn}">
            <!-- Tour Form (Visible only after login) -->
            <div class="text-center mb-8">
                <h1 class="text-3xl font-bold text-gray-900 mb-2">Add New Tour Package</h1>
                <p class="text-gray-600">Create a new safari tour package for customers</p>
                <div class="mt-4 space-x-4">
                    <a href="${pageContext.request.contextPath}/tours/view"
                       class="inline-flex items-center text-blue-600 hover:text-blue-700">
                        <i class="fas fa-list mr-2"></i>View All Trips
                    </a>
                    <a href="${pageContext.request.contextPath}/tours"
                       class="inline-flex items-center text-purple-600 hover:text-purple-700">
                        <i class="fas fa-arrow-left mr-2"></i>Back to Tours
                    </a>
                    <a href="${pageContext.request.contextPath}/tours/logout"
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

            <div class="bg-white rounded-xl shadow-lg p-8">
                <form action="${pageContext.request.contextPath}/tours/add" method="post" class="space-y-6" enctype="multipart/form-data">
                    <!-- Basic Information -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label for="tourName" class="block text-sm font-medium text-gray-700 mb-2">Tour Name *</label>
                            <input type="text" id="tourName" name="tourName" required
                                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent transition duration-200"
                                   placeholder="e.g., Yala National Park Safari">
                        </div>

                        <div>
                            <label for="durationDays" class="block text-sm font-medium text-gray-700 mb-2">Duration (Days) *</label>
                            <select id="durationDays" name="durationDays" required
                                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent transition duration-200">
                                <option value="">Select duration</option>
                                <option value="1">1 Day</option>
                                <option value="2">2 Days</option>
                                <option value="3">3 Days</option>
                                <option value="4">4 Days</option>
                                <option value="5">5 Days</option>
                                <option value="7">7 Days</option>
                            </select>
                        </div>

                        <div class="md:col-span-2">
                            <label for="destination" class="block text-sm font-medium text-gray-700 mb-2">Destination *</label>
                            <input type="text" id="destination" name="destination" required
                                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent transition duration-200"
                                   placeholder="e.g., Yala National Park, Udawalawe, Wilpattu">
                        </div>

                        <div>
                            <label for="price" class="block text-sm font-medium text-gray-700 mb-2">Price (Rs.) *</label>
                            <input type="number" id="price" name="price" required step="0.01" min="0"
                                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent transition duration-200"
                                   placeholder="5000.00">
                        </div>
                    </div>

                    <!-- Meal Inclusions -->
                    <div class="border-b border-gray-200 pb-6">
                        <h2 class="text-xl font-bold text-gray-900 mb-4">Meal Inclusions</h2>
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                            <div class="flex items-center">
                                <input type="checkbox" id="includesBreakfast" name="includesBreakfast" value="true"
                                       class="h-4 w-4 text-purple-600 border-gray-300 rounded">
                                <label for="includesBreakfast" class="ml-2 text-sm text-gray-700">Breakfast Included</label>
                            </div>
                            <div class="flex items-center">
                                <input type="checkbox" id="includesLunch" name="includesLunch" value="true"
                                       class="h-4 w-4 text-purple-600 border-gray-300 rounded">
                                <label for="includesLunch" class="ml-2 text-sm text-gray-700">Lunch Included</label>
                            </div>
                            <div class="flex items-center">
                                <input type="checkbox" id="includesDinner" name="includesDinner" value="true"
                                       class="h-4 w-4 text-purple-600 border-gray-300 rounded">
                                <label for="includesDinner" class="ml-2 text-sm text-gray-700">Dinner Included</label>
                            </div>
                        </div>
                    </div>

                    <!-- Photo Upload -->
                    <div>
                        <label for="tourPhotoFile" class="block text-sm font-medium text-gray-700 mb-2">Tour Photo</label>
                        <input type="file" id="tourPhotoFile" name="tourPhotoFile" accept="image/*"
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent transition duration-200">
                        <p class="text-sm text-gray-500 mt-1">Upload a photo for the tour (JPEG, PNG, etc.)</p>
                    </div>

                    <!-- Special Features -->
                    <div>
                        <label for="specialFeatures" class="block text-sm font-medium text-gray-700 mb-2">Special Features</label>
                        <textarea id="specialFeatures" name="specialFeatures" rows="4"
                                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent transition duration-200"
                                  placeholder="Describe special features, highlights, or unique aspects of this tour..."></textarea>
                    </div>

                    <!-- Submit Button -->
                    <div class="flex justify-end space-x-4 pt-6">
                        <a href="${pageContext.request.contextPath}/tours"
                           class="px-6 py-3 border border-gray-300 text-gray-700 font-medium rounded-lg hover:bg-gray-50 transition duration-200">
                            Cancel
                        </a>
                        <button type="submit"
                                class="px-6 py-3 bg-purple-600 text-white font-medium rounded-lg hover:bg-purple-700 transition duration-200">
                            <i class="fas fa-save mr-2"></i>
                            Add Tour
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