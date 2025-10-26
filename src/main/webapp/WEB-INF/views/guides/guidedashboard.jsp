<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.time.ZoneId" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WildTrails - Guide Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-50">
<!-- Guide Header -->
<header class="bg-green-600 text-white shadow-lg">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center py-4">
            <div class="flex items-center space-x-4">
                <c:if test="${not empty guide.photoData}">
                    <img src="${pageContext.request.contextPath}/guides/photo/${guide.guideId}"
                         alt="${guide.name}"
                         class="h-10 w-10 rounded-full object-cover">
                </c:if>
                <div>
                    <h1 class="text-xl font-bold">Guide Dashboard</h1>
                    <p class="text-green-100 text-sm">Welcome back, ${guide.name}!</p>
                </div>
            </div>
            <div class="flex items-center space-x-4">
                <span class="bg-green-700 px-3 py-1 rounded-full text-sm">
                    ${guide.guideId}
                </span>
                <a href="${pageContext.request.contextPath}/guides/schedule"
                   class="bg-green-700 hover:bg-green-800 px-4 py-2 rounded-lg transition duration-200">
                    <i class="fas fa-calendar-alt mr-2"></i>Schedule
                </a>
                <a href="${pageContext.request.contextPath}/guides/logout"
                   class="bg-green-700 hover:bg-green-800 px-4 py-2 rounded-lg transition duration-200">
                    <i class="fas fa-sign-out-alt mr-2"></i>Logout
                </a>
            </div>
        </div>
    </div>
</header>

<div class="min-h-screen py-8">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
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

        <!-- Dashboard Stats -->
        <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
            <div class="bg-white rounded-lg shadow p-6">
                <div class="flex items-center">
                    <div class="p-3 bg-blue-100 rounded-lg">
                        <i class="fas fa-binoculars text-blue-600 text-xl"></i>
                    </div>
                    <div class="ml-4">
                        <p class="text-sm font-medium text-gray-600">Total Sightings</p>
                        <p class="text-2xl font-semibold text-gray-900">${sightingsCount}</p>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-lg shadow p-6">
                <div class="flex items-center">
                    <div class="p-3 bg-green-100 rounded-lg">
                        <i class="fas fa-calendar-check text-green-600 text-xl"></i>
                    </div>
                    <div class="ml-4">
                        <p class="text-sm font-medium text-gray-600">Today's Sightings</p>
                        <p class="text-2xl font-semibold text-gray-900">${todaySightingsCount}</p>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-lg shadow p-6">
                <div class="flex items-center">
                    <div class="p-3 bg-purple-100 rounded-lg">
                        <i class="fas fa-star text-purple-600 text-xl"></i>
                    </div>
                    <div class="ml-4">
                        <p class="text-sm font-medium text-gray-600">Experience</p>
                        <p class="text-2xl font-semibold text-gray-900">${guide.experienceYears}+ years</p>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-lg shadow p-6">
                <div class="flex items-center">
                    <div class="p-3 bg-yellow-100 rounded-lg">
                        <i class="fas fa-money-bill-wave text-yellow-600 text-xl"></i>
                    </div>
                    <div class="ml-4">
                        <p class="text-sm font-medium text-gray-600">Daily Rate</p>
                        <p class="text-2xl font-semibold text-gray-900">
                            Rs.<fmt:formatNumber value="${guide.dailyRate}" pattern="#,##0.00"/>
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            <!-- Guide Profile -->
            <div class="lg:col-span-1">
                <div class="bg-white rounded-xl shadow-lg overflow-hidden">
                    <div class="p-6">
                        <h2 class="text-2xl font-bold text-gray-900 mb-4">My Profile</h2>

                        <!-- Guide Photo -->
                        <div class="text-center mb-6">
                            <c:choose>
                                <c:when test="${not empty guide.photoData}">
                                    <img src="${pageContext.request.contextPath}/guides/photo/${guide.guideId}"
                                         alt="${guide.name}"
                                         class="w-32 h-32 rounded-full mx-auto object-cover border-4 border-green-200">
                                </c:when>
                                <c:otherwise>
                                    <div class="w-32 h-32 rounded-full mx-auto bg-gray-200 flex items-center justify-center border-4 border-green-200">
                                        <i class="fas fa-user text-4xl text-gray-400"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Guide Details -->
                        <div class="space-y-3">
                            <div>
                                <label class="text-sm font-medium text-gray-600">Full Name</label>
                                <p class="font-semibold">${guide.name}</p>
                            </div>

                            <div>
                                <label class="text-sm font-medium text-gray-600">Phone</label>
                                <p class="font-semibold">${guide.phoneNumber}</p>
                            </div>

                            <c:if test="${not empty guide.email}">
                                <div>
                                    <label class="text-sm font-medium text-gray-600">Email</label>
                                    <p class="font-semibold">${guide.email}</p>
                                </div>
                            </c:if>

                            <div>
                                <label class="text-sm font-medium text-gray-600">Specialization</label>
                                <p class="font-semibold">${not empty guide.specialization ? guide.specialization : 'General Wildlife'}</p>
                            </div>

                            <div>
                                <label class="text-sm font-medium text-gray-600">Languages</label>
                                <p class="font-semibold">${not empty guide.languages ? guide.languages : 'English, Sinhala'}</p>
                            </div>

                            <c:if test="${not empty guide.availableTrips}">
                                <div>
                                    <label class="text-sm font-medium text-gray-600">Available Trips</label>
                                    <p class="font-semibold">${guide.availableTrips}</p>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Content -->
            <div class="lg:col-span-2 space-y-8">
                <!-- Add New Sighting Form -->
                <div class="bg-white rounded-xl shadow-lg p-6">
                    <h2 class="text-2xl font-bold text-gray-900 mb-4">Add New Sighting</h2>
                    <form action="${pageContext.request.contextPath}/guides/sightings/add" method="POST" enctype="multipart/form-data" class="space-y-4" onsubmit="return validateSightingForm()">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div>
                                <label for="animalType" class="block text-sm font-medium text-gray-700 mb-2">Animal Type *</label>
                                <select id="animalType" name="animalType" required
                                        class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent">
                                    <option value="">Select Animal Type</option>
                                    <option value="Elephant">Elephant</option>
                                    <option value="Leopard">Leopard</option>
                                    <option value="Sloth Bear">Sloth Bear</option>
                                    <option value="Deer">Deer</option>
                                    <option value="Monkey">Monkey</option>
                                    <option value="Bird">Bird</option>
                                    <option value="Reptile">Reptile</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>

                            <div>
                                <label for="species" class="block text-sm font-medium text-gray-700 mb-2">Species/Name *</label>
                                <input type="text" id="species" name="species" required
                                       class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent"
                                       placeholder="e.g., Asian Elephant, Sri Lankan Leopard">
                            </div>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div>
                                <label for="coordinates" class="block text-sm font-medium text-gray-700 mb-2">Coordinates *</label>
                                <input type="text" id="coordinates" name="coordinates" required
                                       class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent"
                                       placeholder="e.g., 6.5543, 80.3321">
                            </div>

                            <div>
                                <label for="location" class="block text-sm font-medium text-gray-700 mb-2">Location Name</label>
                                <input type="text" id="location" name="location"
                                       class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent"
                                       placeholder="e.g., Yala Zone 1, Udawalawe Park">
                            </div>
                        </div>

                        <div>
                            <label for="specialDetails" class="block text-sm font-medium text-gray-700 mb-2">Special Details</label>
                            <textarea id="specialDetails" name="specialDetails" rows="3"
                                      class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent"
                                      placeholder="Describe the sighting, behavior, group size, etc..."></textarea>
                        </div>

                        <div>
                            <label for="sightingPhoto" class="block text-sm font-medium text-gray-700 mb-2">Upload Sighting Photo</label>
                            <input type="file" id="sightingPhoto" name="sightingPhoto" accept="image/*"
                                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent"
                                   onchange="previewImage(this)">

                            <!-- Image Preview Container -->
                            <div id="imagePreviewContainer" class="mt-3 hidden">
                                <p class="text-sm font-medium text-gray-700 mb-2">Image Preview:</p>
                                <div class="border border-gray-300 rounded-lg p-3 bg-gray-50">
                                    <img id="imagePreview" class="max-w-full max-h-64 mx-auto rounded-lg" src="" alt="Image preview">
                                </div>
                                <button type="button" id="removeImageBtn" class="mt-2 px-3 py-1 bg-red-500 text-white text-sm rounded hover:bg-red-600 transition duration-200">
                                    <i class="fas fa-times mr-1"></i>Remove Image
                                </button>
                            </div>
                        </div>

                        <div class="flex justify-end">
                            <button type="submit"
                                    class="px-6 py-3 bg-green-600 text-white font-medium rounded-lg hover:bg-green-700 transition duration-200">
                                <i class="fas fa-plus mr-2"></i>
                                Add Sighting
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Recent Sightings -->
                <div class="bg-white rounded-xl shadow-lg p-6">
                    <div class="flex justify-between items-center mb-4">
                        <h2 class="text-2xl font-bold text-gray-900">Recent Sightings</h2>
                        <span class="bg-green-100 text-green-800 text-sm font-medium px-3 py-1 rounded-full">
                            ${sightingsCount} total
                        </span>
                    </div>

                    <c:if test="${not empty recentSightings}">
                        <div class="space-y-4">
                            <c:forEach var="sighting" items="${recentSightings}">
                                <div class="border border-gray-200 rounded-lg p-4 hover:shadow-md transition duration-200">
                                    <div class="flex items-start justify-between">
                                        <div class="flex-1">
                                            <div class="flex justify-between items-start mb-2">
                                                <h3 class="font-semibold text-gray-900">${sighting.animalType} - ${sighting.species}</h3>
                                                <div class="flex space-x-2">
                                                    <a href="${pageContext.request.contextPath}/guides/sightings/edit/${sighting.id}"
                                                       class="text-blue-600 hover:text-blue-800 text-sm">
                                                        <i class="fas fa-edit mr-1"></i>Edit
                                                    </a>
                                                    <form action="${pageContext.request.contextPath}/guides/sightings/delete/${sighting.id}"
                                                          method="POST" class="inline" onsubmit="return confirm('Are you sure you want to delete this sighting?');">
                                                        <button type="submit" class="text-red-600 hover:text-red-800 text-sm">
                                                            <i class="fas fa-trash mr-1"></i>Delete
                                                        </button>
                                                    </form>
                                                </div>
                                            </div>
                                            <div class="grid grid-cols-1 md:grid-cols-3 gap-2 text-sm text-gray-600 mt-2">
                                                <div>
                                                    <i class="fas fa-map-marker-alt mr-1 text-green-600"></i>
                                                        ${sighting.coordinates}
                                                </div>
                                                <div>
                                                    <i class="fas fa-calendar mr-1 text-blue-600"></i>
                                                    <!-- Fixed: Using substring to format LocalDateTime -->
                                                        ${fn:substring(sighting.sightingDate.toString(), 0, 16)}
                                                </div>
                                                <div>
                                                    <i class="fas fa-location-dot mr-1 text-purple-600"></i>
                                                        ${not empty sighting.location ? sighting.location : 'Not specified'}
                                                </div>
                                            </div>
                                            <c:if test="${not empty sighting.specialDetails}">
                                                <p class="text-sm text-gray-700 mt-2 bg-gray-50 p-2 rounded">
                                                    <i class="fas fa-info-circle mr-1 text-yellow-600"></i>
                                                        ${sighting.specialDetails}
                                                </p>
                                            </c:if>
                                        </div>
                                        <!-- In the Recent Sightings section -->
                                        <c:if test="${not empty sighting.photoData}">
                                            <div class="ml-4">
                                                <img src="data:image/jpeg;base64,${sighting.base64Photo}"
                                                     alt="${sighting.species}"
                                                     class="w-20 h-20 rounded-lg object-cover border border-gray-300"
                                                     onerror="this.style.display='none'">
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>

                    <c:if test="${empty recentSightings}">
                        <div class="text-center py-8 text-gray-500">
                            <i class="fas fa-binoculars text-4xl mb-3"></i>
                            <p>No sightings recorded yet.</p>
                            <p class="text-sm">Add your first sighting using the form above!</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Auto-fill current date and time
    document.addEventListener('DOMContentLoaded', function() {
        const now = new Date();
        const localDateTime = now.toISOString().slice(0, 16);
        // Remove this line as there's no sightTime field in your form
        // document.getElementById('sightTime').value = localDateTime;
    });

    // Form validation
    function validateSightingForm() {
        const animalType = document.getElementById('animalType').value;
        const species = document.getElementById('species').value;
        const coordinates = document.getElementById('coordinates').value;

        if (!animalType || !species || !coordinates) {
            alert('Please fill in all required fields: Animal Type, Species, and Coordinates.');
            return false;
        }

        // Basic coordinate validation (simple format check)
        const coordRegex = /^-?\d+\.?\d*,\s*-?\d+\.?\d*$/;
        if (!coordRegex.test(coordinates)) {
            alert('Please enter coordinates in the format: latitude, longitude (e.g., 6.5543, 80.3321)');
            return false;
        }

        return true;
    }

    // Image preview functionality
    function previewImage(input) {
        const previewContainer = document.getElementById('imagePreviewContainer');
        const preview = document.getElementById('imagePreview');
        const removeBtn = document.getElementById('removeImageBtn');

        if (input.files && input.files[0]) {
            const reader = new FileReader();

            reader.onload = function(e) {
                preview.src = e.target.result;
                previewContainer.classList.remove('hidden');
            };

            reader.readAsDataURL(input.files[0]);
        } else {
            previewContainer.classList.add('hidden');
            preview.src = '';
        }
    }

    // Remove image preview
    document.addEventListener('DOMContentLoaded', function() {
        const removeBtn = document.getElementById('removeImageBtn');
        if (removeBtn) {
            removeBtn.addEventListener('click', function() {
                const fileInput = document.getElementById('sightingPhoto');
                const previewContainer = document.getElementById('imagePreviewContainer');
                const preview = document.getElementById('imagePreview');

                fileInput.value = '';
                preview.src = '';
                previewContainer.classList.add('hidden');
            });
        }
    });
</script>
</body>
</html>