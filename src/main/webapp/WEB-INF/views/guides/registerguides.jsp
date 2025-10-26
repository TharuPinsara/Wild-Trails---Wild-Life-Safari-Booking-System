<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WildTrails - Register Guide</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-50">
<%@ include file="../Header.jsp" %>

<div class="min-h-screen py-8">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <!-- Header -->
        <div class="text-center mb-8">
            <h1 class="text-3xl font-bold text-gray-900 mb-2">Register New Guide</h1>
            <p class="text-gray-600">Add a new expert guide to our wildlife safari team</p>
            <a href="${pageContext.request.contextPath}/guides" class="inline-flex items-center text-green-600 hover:text-green-700 mt-4">
                <i class="fas fa-arrow-left mr-2"></i>
                Back to Guides List
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
            <form action="${pageContext.request.contextPath}/guides/register" method="post" class="space-y-6" enctype="multipart/form-data">
                <!-- Personal Information -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                        <label for="name" class="block text-sm font-medium text-gray-700 mb-2">Full Name *</label>
                        <input type="text" id="name" name="name" required
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200"
                               placeholder="Enter guide's full name">
                    </div>

                    <div>
                        <label for="phoneNumber" class="block text-sm font-medium text-gray-700 mb-2">Phone Number *</label>
                        <input type="tel" id="phoneNumber" name="phoneNumber" required
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200"
                               placeholder="+94 XXX XXX XXX">
                    </div>

                    <div>
                        <label for="email" class="block text-sm font-medium text-gray-700 mb-2">Email Address</label>
                        <input type="email" id="email" name="email"
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200"
                               placeholder="guide@email.com">
                    </div>

                    <div>
                        <label for="experienceYears" class="block text-sm font-medium text-gray-700 mb-2">Years of Experience *</label>
                        <select id="experienceYears" name="experienceYears" required
                                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200">
                            <option value="">Select experience</option>
                            <option value="1">1-2 years</option>
                            <option value="3">3-5 years</option>
                            <option value="6">6-10 years</option>
                            <option value="11">10+ years</option>
                        </select>
                    </div>
                </div>

                <!-- Specialization & Languages -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Specialization *</label>
                        <div class="grid grid-cols-1 gap-3 p-4 border border-gray-300 rounded-lg">
                            <div class="flex items-center">
                                <input type="checkbox" id="mammal_tracking" name="specialization" value="Mammal Tracking" class="h-4 w-4 text-green-600 border-gray-300 rounded">
                                <label for="mammal_tracking" class="ml-2 text-sm text-gray-700">Mammal Tracking</label>
                            </div>
                            <div class="flex items-center">
                                <input type="checkbox" id="bird_watching" name="specialization" value="Bird Watching" class="h-4 w-4 text-green-600 border-gray-300 rounded">
                                <label for="bird_watching" class="ml-2 text-sm text-gray-700">Bird Watching</label>
                            </div>
                            <div class="flex items-center">
                                <input type="checkbox" id="elephant_behavior" name="specialization" value="Elephant Behavior" class="h-4 w-4 text-green-600 border-gray-300 rounded">
                                <label for="elephant_behavior" class="ml-2 text-sm text-gray-700">Elephant Behavior</label>
                            </div>
                            <div class="flex items-center">
                                <input type="checkbox" id="leopard_tracking" name="specialization" value="Leopard Tracking" class="h-4 w-4 text-green-600 border-gray-300 rounded">
                                <label for="leopard_tracking" class="ml-2 text-sm text-gray-700">Leopard Tracking</label>
                            </div>
                            <div class="flex items-center">
                                <input type="checkbox" id="photography_guide" name="specialization" value="Photography Guide" class="h-4 w-4 text-green-600 border-gray-300 rounded">
                                <label for="photography_guide" class="ml-2 text-sm text-gray-700">Photography Guide</label>
                            </div>
                            <div class="flex items-center">
                                <input type="checkbox" id="botany_expert" name="specialization" value="Botany Expert" class="h-4 w-4 text-green-600 border-gray-300 rounded">
                                <label for="botany_expert" class="ml-2 text-sm text-gray-700">Botany Expert</label>
                            </div>
                            <div class="flex items-center">
                                <input type="checkbox" id="reptile_specialist" name="specialization" value="Reptile Specialist" class="h-4 w-4 text-green-600 border-gray-300 rounded">
                                <label for="reptile_specialist" class="ml-2 text-sm text-gray-700">Reptile Specialist</label>
                            </div>
                            <div class="flex items-center">
                                <input type="checkbox" id="night_safari" name="specialization" value="Night Safari Expert" class="h-4 w-4 text-green-600 border-gray-300 rounded">
                                <label for="night_safari" class="ml-2 text-sm text-gray-700">Night Safari Expert</label>
                            </div>
                            <div class="flex items-center">
                                <input type="checkbox" id="cultural_guide" name="specialization" value="Cultural Guide" class="h-4 w-4 text-green-600 border-gray-300 rounded">
                                <label for="cultural_guide" class="ml-2 text-sm text-gray-700">Cultural Guide</label>
                            </div>
                            <div class="flex items-center">
                                <input type="checkbox" id="adventure_guide" name="specialization" value="Adventure Guide" class="h-4 w-4 text-green-600 border-gray-300 rounded">
                                <label for="adventure_guide" class="ml-2 text-sm text-gray-700">Adventure Guide</label>
                            </div>
                        </div>
                        <p class="text-sm text-gray-500 mt-1">Tick the specializations that apply</p>
                    </div>

                    <div>
                        <label for="languages" class="block text-sm font-medium text-gray-700 mb-2">Languages Spoken</label>
                        <input type="text" id="languages" name="languages"
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200"
                               placeholder="English, Sinhala, Tamil">
                    </div>
                </div>

                <!-- Pricing & Trips -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                        <label for="dailyRate" class="block text-sm font-medium text-gray-700 mb-2">Daily Rate (Rs.) *</label>
                        <input type="number" id="dailyRate" name="dailyRate" required step="0.01" min="0"
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200"
                               placeholder="50.00">
                    </div>

                    <div>
                        <label for="availableTrips" class="block text-sm font-medium text-gray-700 mb-2">Available Trips</label>
                        <input type="text" id="availableTrips" name="availableTrips"
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200"
                               placeholder="Yala, Udawalawe, Minneriya">
                    </div>
                </div>

                <!-- Password -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                        <label for="password" class="block text-sm font-medium text-gray-700 mb-2">Password *</label>
                        <input type="password" id="password" name="password" required
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200"
                               placeholder="Enter guide password">
                    </div>

                    <div>
                        <label for="confirmPassword" class="block text-sm font-medium text-gray-700 mb-2">Confirm Password *</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" required
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200"
                               placeholder="Confirm password">
                    </div>
                </div>

                <!-- Opportunities & Photo Upload -->
                <div class="grid grid-cols-1 gap-6">
                    <div>
                        <label for="opportunities" class="block text-sm font-medium text-gray-700 mb-2">Special Opportunities</label>
                        <textarea id="opportunities" name="opportunities" rows="3"
                                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200"
                                  placeholder="Describe special skills, certifications, or unique opportunities this guide offers..."></textarea>
                    </div>

                    <div>
                        <label for="photoFile" class="block text-sm font-medium text-gray-700 mb-2">Upload Photo</label>
                        <input type="file" id="photoFile" name="photoFile" accept="image/*"
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200">
                        <p class="text-sm text-gray-500 mt-1">Upload a profile photo for the guide (JPEG, PNG, etc.)</p>
                    </div>
                </div>

                <!-- Submit Button -->
                <div class="flex justify-end space-x-4 pt-6">
                    <a href="${pageContext.request.contextPath}/guides"
                       class="px-6 py-3 border border-gray-300 text-gray-700 font-medium rounded-lg hover:bg-gray-50 transition duration-200">
                        Cancel
                    </a>
                    <button type="submit"
                            class="px-6 py-3 bg-green-600 text-white font-medium rounded-lg hover:bg-green-700 transition duration-200">
                        <i class="fas fa-save mr-2"></i>
                        Register Guide
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

        function validatePassword() {
            if (password.value !== confirmPassword.value) {
                confirmPassword.setCustomValidity("Passwords don't match");
                confirmPassword.classList.add('border-red-500');
            } else {
                confirmPassword.setCustomValidity('');
                confirmPassword.classList.remove('border-red-500');
            }
        }

        password.addEventListener('change', validatePassword);
        confirmPassword.addEventListener('keyup', validatePassword);

        // Specialization validation - at least one checkbox should be checked
        const form = document.querySelector('form');
        const checkboxes = document.querySelectorAll('input[name="specialization"]');

        form.addEventListener('submit', function(e) {
            const checked = Array.from(checkboxes).some(checkbox => checkbox.checked);
            if (!checked) {
                e.preventDefault();
                alert('Please select at least one specialization');
            }
        });
    });
</script>
<%@ include file="../Footer.jsp" %>
</body>
</html>