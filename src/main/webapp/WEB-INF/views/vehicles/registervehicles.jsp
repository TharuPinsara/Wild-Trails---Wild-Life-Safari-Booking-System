<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WildTrails - Register Vehicle</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-50">
<%@ include file="../Header.jsp" %>

<div class="min-h-screen py-8">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <!-- Header -->
        <div class="text-center mb-8">
            <h1 class="text-3xl font-bold text-gray-900 mb-2">Register New Vehicle</h1>
            <p class="text-gray-600">Add a new safari vehicle to our fleet</p>
            <a href="${pageContext.request.contextPath}/vehicles" class="inline-flex items-center text-green-600 hover:text-green-700 mt-4">
                <i class="fas fa-arrow-left mr-2"></i>
                Back to Vehicles List
            </a>
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

        <!-- Registration Form -->
        <div class="bg-white rounded-xl shadow-lg p-8">
            <form action="${pageContext.request.contextPath}/vehicles/register" method="post" class="space-y-6" enctype="multipart/form-data" onsubmit="return validateForm()">
                <!-- Driver Information -->
                <div class="border-b border-gray-200 pb-6">
                    <h2 class="text-xl font-bold text-gray-900 mb-4">Driver Information</h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label for="driverName" class="block text-sm font-medium text-gray-700 mb-2">Driver Name *</label>
                            <input type="text" id="driverName" name="driverName" required
                                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200"
                                   placeholder="Enter driver's full name">
                        </div>

                        <div>
                            <label for="driverPhone" class="block text-sm font-medium text-gray-700 mb-2">Driver Phone *</label>
                            <input type="tel" id="driverPhone" name="driverPhone" required
                                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200"
                                   placeholder="+94 XXX XXX XXX">
                        </div>

                        <div>
                            <label for="driverEmail" class="block text-sm font-medium text-gray-700 mb-2">Driver Email</label>
                            <input type="email" id="driverEmail" name="driverEmail"
                                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200"
                                   placeholder="driver@email.com">
                            <p class="text-xs text-gray-500 mt-1">Email is optional but recommended for driver login</p>
                        </div>

                        <div>
                            <label for="password" class="block text-sm font-medium text-gray-700 mb-2">Driver Password *</label>
                            <input type="password" id="password" name="password" required minlength="8"
                                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200"
                                   placeholder="Enter driver password (min. 8 characters)">
                            <p class="text-xs text-gray-500 mt-1">Password must be at least 8 characters long</p>
                        </div>

                        <div>
                            <label for="confirmPassword" class="block text-sm font-medium text-gray-700 mb-2">Confirm Password *</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" required
                                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200"
                                   placeholder="Confirm password">
                            <div id="passwordError" class="text-red-500 text-xs mt-1 hidden">Passwords do not match</div>
                        </div>

                        <div>
                            <label for="driverPhotoFile" class="block text-sm font-medium text-gray-700 mb-2">Driver Photo</label>
                            <input type="file" id="driverPhotoFile" name="driverPhotoFile" accept="image/*"
                                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200">
                        </div>
                    </div>
                </div>

                <!-- Vehicle Information -->
                <div class="border-b border-gray-200 pb-6">
                    <h2 class="text-xl font-bold text-gray-900 mb-4">Vehicle Information</h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label for="vehicleName" class="block text-sm font-medium text-gray-700 mb-2">Vehicle Name *</label>
                            <input type="text" id="vehicleName" name="vehicleName" required
                                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200"
                                   placeholder="e.g., Safari Jeep 001">
                        </div>

                        <div>
                            <label for="vehicleType" class="block text-sm font-medium text-gray-700 mb-2">Vehicle Type *</label>
                            <select id="vehicleType" name="vehicleType" required
                                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200">
                                <option value="">Select vehicle type</option>
                                <option value="4WD Jeep">4WD Jeep</option>
                                <option value="Safari Truck">Safari Truck</option>
                                <option value="Land Cruiser">Land Cruiser</option>
                                <option value="Mini Van">Mini Van</option>
                                <option value="Open Safari Vehicle">Open Safari Vehicle</option>
                                <option value="Luxury Safari Vehicle">Luxury Safari Vehicle</option>
                            </select>
                        </div>

                        <div>
                            <label for="capacity" class="block text-sm font-medium text-gray-700 mb-2">Passenger Capacity *</label>
                            <select id="capacity" name="capacity" required
                                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200">
                                <option value="">Select capacity</option>
                                <option value="2">2 Passengers</option>
                                <option value="4" selected>4 Passengers</option>
                                <option value="6">6 Passengers</option>
                                <option value="8">8 Passengers</option>
                                <option value="10">10 Passengers</option>
                                <option value="12">12 Passengers</option>
                                <option value="15">15 Passengers</option>
                            </select>
                        </div>

                        <div>
                            <label for="dailyRate" class="block text-sm font-medium text-gray-700 mb-2">Daily Rate (Rs.) *</label>
                            <input type="number" id="dailyRate" name="dailyRate" required step="0.01" min="0"
                                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200"
                                   placeholder="100.00">
                        </div>

                        <div>
                            <label for="vehicleReady" class="block text-sm font-medium text-gray-700 mb-2">Vehicle Status *</label>
                            <select id="vehicleReady" name="vehicleReady" required
                                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200">
                                <option value="true">Ready for Service</option>
                                <option value="false">Not Available</option>
                            </select>
                        </div>

                        <div class="md:col-span-2">
                            <label for="vehiclePhotoFile" class="block text-sm font-medium text-gray-700 mb-2">Vehicle Photo</label>
                            <input type="file" id="vehiclePhotoFile" name="vehiclePhotoFile" accept="image/*"
                                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200">
                        </div>
                    </div>
                </div>

                <!-- Inclusions -->
                <div class="border-b border-gray-200 pb-6">
                    <h2 class="text-xl font-bold text-gray-900 mb-4">Vehicle Inclusions</h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div class="flex items-center">
                            <input type="checkbox" id="gps" name="inclusions" value="GPS Navigation" class="h-4 w-4 text-green-600 border-gray-300 rounded">
                            <label for="gps" class="ml-2 text-sm text-gray-700">GPS Navigation</label>
                        </div>
                        <div class="flex items-center">
                            <input type="checkbox" id="cooler" name="inclusions" value="Cooler Box" class="h-4 w-4 text-green-600 border-gray-300 rounded">
                            <label for="cooler" class="ml-2 text-sm text-gray-700">Cooler Box</label>
                        </div>
                        <div class="flex items-center">
                            <input type="checkbox" id="binoculars" name="inclusions" value="Binoculars" class="h-4 w-4 text-green-600 border-gray-300 rounded">
                            <label for="binoculars" class="ml-2 text-sm text-gray-700">Binoculars</label>
                        </div>
                        <div class="flex items-center">
                            <input type="checkbox" id="firstaid" name="inclusions" value="First Aid Kit" class="h-4 w-4 text-green-600 border-gray-300 rounded">
                            <label for="firstaid" class="ml-2 text-sm text-gray-700">First Aid Kit</label>
                        </div>
                        <div class="flex items-center">
                            <input type="checkbox" id="charger" name="inclusions" value="USB Charger" class="h-4 w-4 text-green-600 border-gray-300 rounded">
                            <label for="charger" class="ml-2 text-sm text-gray-700">USB Charger</label>
                        </div>
                        <div class="flex items-center">
                            <input type="checkbox" id="insurance" name="inclusions" value="Full Insurance" class="h-4 w-4 text-green-600 border-gray-300 rounded">
                            <label for="insurance" class="ml-2 text-sm text-gray-700">Full Insurance</label>
                        </div>
                        <div class="flex items-center">
                            <input type="checkbox" id="guide_seat" name="inclusions" value="Guide Seat" class="h-4 w-4 text-green-600 border-gray-300 rounded">
                            <label for="guide_seat" class="ml-2 text-sm text-gray-700">Guide Seat</label>
                        </div>
                        <div class="flex items-center">
                            <input type="checkbox" id="roof_hatch" name="inclusions" value="Roof Hatch" class="h-4 w-4 text-green-600 border-gray-300 rounded">
                            <label for="roof_hatch" class="ml-2 text-sm text-gray-700">Roof Hatch</label>
                        </div>
                    </div>
                </div>

                <!-- Special Features -->
                <div>
                    <h2 class="text-xl font-bold text-gray-900 mb-4">Special Features</h2>
                    <div>
                        <label for="specialFeatures" class="block text-sm font-medium text-gray-700 mb-2">Additional Features & Description</label>
                        <textarea id="specialFeatures" name="specialFeatures" rows="4"
                                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200"
                                  placeholder="Describe any special features, certifications, or unique aspects of this vehicle..."></textarea>
                    </div>
                </div>

                <!-- Submit Button -->
                <div class="flex justify-end space-x-4 pt-6">
                    <a href="${pageContext.request.contextPath}/vehicles/admin"
                       class="px-6 py-3 border border-gray-300 text-gray-700 font-medium rounded-lg hover:bg-gray-50 transition duration-200">
                        Cancel
                    </a>
                    <button type="submit"
                            class="px-6 py-3 bg-green-600 text-white font-medium rounded-lg hover:bg-green-700 transition duration-200">
                        <i class="fas fa-save mr-2"></i>
                        Register Vehicle
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Form validation and enhancement
    document.addEventListener('DOMContentLoaded', function() {
        // Add focus styles
        const inputs = document.querySelectorAll('input, select, textarea');
        inputs.forEach(input => {
            input.addEventListener('focus', function() {
                this.classList.add('ring-2', 'ring-green-200');
            });
            input.addEventListener('blur', function() {
                this.classList.remove('ring-2', 'ring-green-200');
            });
        });

        // Password confirmation validation
        const password = document.getElementById('password');
        const confirmPassword = document.getElementById('confirmPassword');
        const passwordError = document.getElementById('passwordError');

        function validatePassword() {
            if (password.value !== confirmPassword.value) {
                confirmPassword.setCustomValidity("Passwords don't match");
                confirmPassword.classList.add('border-red-500');
                passwordError.classList.remove('hidden');
                return false;
            } else {
                confirmPassword.setCustomValidity('');
                confirmPassword.classList.remove('border-red-500');
                passwordError.classList.add('hidden');
                return true;
            }
        }

        function validatePasswordLength() {
            if (password.value.length < 8) {
                password.setCustomValidity("Password must be at least 8 characters");
                password.classList.add('border-red-500');
                return false;
            } else {
                password.setCustomValidity('');
                password.classList.remove('border-red-500');
                return true;
            }
        }

        password.addEventListener('input', validatePasswordLength);
        password.addEventListener('change', validatePassword);
        confirmPassword.addEventListener('input', validatePassword);
    });

    function validateForm() {
        const password = document.getElementById('password');
        const confirmPassword = document.getElementById('confirmPassword');

        // Validate password length
        if (password.value.length < 8) {
            alert('Password must be at least 8 characters long');
            password.focus();
            return false;
        }

        // Validate password match
        if (password.value !== confirmPassword.value) {
            alert('Passwords do not match');
            confirmPassword.focus();
            return false;
        }

        return true;
    }
</script>
<%@ include file="../Footer.jsp" %>
</body>
</html>