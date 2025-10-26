<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WildTrails - Edit Sighting</title>
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
                    <h1 class="text-xl font-bold">Edit Sighting</h1>
                    <p class="text-green-100 text-sm">Welcome back, ${guide.name}!</p>
                </div>
            </div>
            <div class="flex items-center space-x-4">
                <a href="${pageContext.request.contextPath}/guides/dashboard"
                   class="bg-green-700 hover:bg-green-800 px-4 py-2 rounded-lg transition duration-200">
                    <i class="fas fa-arrow-left mr-2"></i>Back to Dashboard
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
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
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

        <!-- Edit Sighting Form -->
        <div class="bg-white rounded-xl shadow-lg p-6">
            <h2 class="text-2xl font-bold text-gray-900 mb-6">Edit Sighting</h2>

            <!-- Current Photo -->
            <c:if test="${sighting.hasPhoto()}">
                <div class="mb-6">
                    <label class="block text-sm font-medium text-gray-700 mb-2">Current Photo</label>
                    <div class="flex items-center space-x-4">
                        <img src="data:image/jpeg;base64,${sighting.base64Photo}"
                             alt="${sighting.species}"
                             class="w-48 h-48 rounded-lg object-cover border border-gray-300">
                        <div class="text-sm text-gray-600">
                            <p class="font-medium">Current photo</p>
                            <p class="text-xs mt-1">Upload a new photo below to replace this one</p>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- CHANGED: Form action to use SightingController -->
            <form action="${pageContext.request.contextPath}/guides/sightings/update" method="POST" enctype="multipart/form-data" class="space-y-6" onsubmit="return validateForm()">
                <input type="hidden" name="sightId" value="${sighting.id}">

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                        <label for="animalType" class="block text-sm font-medium text-gray-700 mb-2">Animal Type *</label>
                        <select id="animalType" name="animalType" required
                                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent">
                            <option value="">Select Animal Type</option>
                            <option value="Elephant" ${sighting.animalType == 'Elephant' ? 'selected' : ''}>Elephant</option>
                            <option value="Leopard" ${sighting.animalType == 'Leopard' ? 'selected' : ''}>Leopard</option>
                            <option value="Sloth Bear" ${sighting.animalType == 'Sloth Bear' ? 'selected' : ''}>Sloth Bear</option>
                            <option value="Deer" ${sighting.animalType == 'Deer' ? 'selected' : ''}>Deer</option>
                            <option value="Monkey" ${sighting.animalType == 'Monkey' ? 'selected' : ''}>Monkey</option>
                            <option value="Bird" ${sighting.animalType == 'Bird' ? 'selected' : ''}>Bird</option>
                            <option value="Reptile" ${sighting.animalType == 'Reptile' ? 'selected' : ''}>Reptile</option>
                            <option value="Other" ${sighting.animalType == 'Other' ? 'selected' : ''}>Other</option>
                        </select>
                    </div>

                    <div>
                        <label for="species" class="block text-sm font-medium text-gray-700 mb-2">Species/Name *</label>
                        <input type="text" id="species" name="species" required
                               value="${sighting.species}"
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent"
                               placeholder="e.g., Asian Elephant, Sri Lankan Leopard">
                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                        <label for="coordinates" class="block text-sm font-medium text-gray-700 mb-2">Coordinates *</label>
                        <input type="text" id="coordinates" name="coordinates" required
                               value="${sighting.coordinates}"
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent"
                               placeholder="e.g., 6.5543, 80.3321">
                    </div>

                    <div>
                        <label for="location" class="block text-sm font-medium text-gray-700 mb-2">Location Name</label>
                        <input type="text" id="location" name="location"
                               value="${sighting.location}"
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent"
                               placeholder="e.g., Yala Zone 1, Udawalawe Park">
                    </div>
                </div>

                <div>
                    <label for="specialDetails" class="block text-sm font-medium text-gray-700 mb-2">Special Details</label>
                    <textarea id="specialDetails" name="specialDetails" rows="4"
                              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent"
                              placeholder="Describe the sighting, behavior, group size, etc...">${sighting.specialDetails}</textarea>
                </div>

                <div>
                    <label for="sightingPhoto" class="block text-sm font-medium text-gray-700 mb-2">
                        ${sighting.hasPhoto() ? 'Update Sighting Photo' : 'Upload Sighting Photo'}
                        <span class="text-gray-500 text-sm">${sighting.hasPhoto() ? '(Leave empty to keep current photo)' : ''}</span>
                    </label>
                    <input type="file" id="sightingPhoto" name="sightingPhoto" accept="image/*"
                           class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent"
                           onchange="previewImage(this)">

                    <!-- Image Preview Container -->
                    <div id="imagePreviewContainer" class="mt-3 hidden">
                        <p class="text-sm font-medium text-gray-700 mb-2">New Photo Preview:</p>
                        <div class="border border-gray-300 rounded-lg p-3 bg-gray-50">
                            <img id="imagePreview" class="max-w-full max-h-64 mx-auto rounded-lg" src="" alt="Image preview">
                        </div>
                        <button type="button" id="removeImageBtn" class="mt-2 px-3 py-1 bg-red-500 text-white text-sm rounded hover:bg-red-600 transition duration-200">
                            <i class="fas fa-times mr-1"></i>Remove New Image
                        </button>
                    </div>
                </div>

                <div class="flex justify-end space-x-4 pt-6">
                    <a href="${pageContext.request.contextPath}/guides/dashboard"
                       class="px-6 py-3 border border-gray-300 text-gray-700 font-medium rounded-lg hover:bg-gray-50 transition duration-200">
                        Cancel
                    </a>
                    <button type="submit"
                            class="px-6 py-3 bg-green-600 text-white font-medium rounded-lg hover:bg-green-700 transition duration-200">
                        <i class="fas fa-save mr-2"></i>
                        Update Sighting
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function validateForm() {
        const animalType = document.getElementById('animalType').value;
        const species = document.getElementById('species').value;
        const coordinates = document.getElementById('coordinates').value;

        if (!animalType || !species || !coordinates) {
            alert('Please fill in all required fields: Animal Type, Species, and Coordinates.');
            return false;
        }

        // Basic coordinate validation
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