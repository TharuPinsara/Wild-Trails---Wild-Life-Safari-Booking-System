<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WildTrails - Guide Sightings</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-50">
<%@ include file="../Header.jsp" %>

<div class="min-h-screen py-8">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <!-- Header Section -->
        <div class="text-center mb-12">
            <h1 class="text-4xl font-bold text-gray-900 mb-4">Wildlife Sightings</h1>
            <p class="text-lg text-gray-600 max-w-3xl mx-auto">
                Explore all wildlife sightings recorded by our expert guides. Track animal movements,
                species diversity, and recent wildlife activity across different locations.
            </p>
        </div>

        <!-- Selected Guide Header -->
        <c:if test="${not empty selectedGuideName}">
            <div class="mb-6 p-4 bg-blue-50 border border-blue-200 rounded-lg">
                <div class="flex items-center justify-between">
                    <div>
                        <h2 class="text-xl font-semibold text-blue-800">${selectedGuideName} Sightings</h2>
                        <p class="text-blue-600">Viewing sightings for this specific guide</p>
                    </div>
                    <c:if test="${not empty selectedGuideId}">
                        <a href="${pageContext.request.contextPath}/guides/sightings"
                           class="inline-flex items-center px-4 py-2 bg-white text-blue-600 border border-blue-300 rounded-lg hover:bg-blue-50 transition duration-200">
                            <i class="fas fa-arrow-left mr-2"></i>
                            View All Sightings
                        </a>
                    </c:if>
                </div>
            </div>
        </c:if>

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

        <!-- Stats Section -->
        <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
            <div class="bg-white rounded-lg shadow p-6">
                <div class="flex items-center">
                    <div class="p-3 bg-blue-100 rounded-lg">
                        <i class="fas fa-binoculars text-blue-600 text-xl"></i>
                    </div>
                    <div class="ml-4">
                        <p class="text-sm font-medium text-gray-600">Total Sightings</p>
                        <p class="text-2xl font-bold text-gray-900">${totalSightings}</p>
                    </div>
                </div>
            </div>
            <div class="bg-white rounded-lg shadow p-6">
                <div class="flex items-center">
                    <div class="p-3 bg-green-100 rounded-lg">
                        <i class="fas fa-calendar-day text-green-600 text-xl"></i>
                    </div>
                    <div class="ml-4">
                        <p class="text-sm font-medium text-gray-600">Today's Sightings</p>
                        <p class="text-2xl font-bold text-gray-900">${todaySightings}</p>
                    </div>
                </div>
            </div>
            <div class="bg-white rounded-lg shadow p-6">
                <div class="flex items-center">
                    <div class="p-3 bg-purple-100 rounded-lg">
                        <i class="fas fa-paw text-purple-600 text-xl"></i>
                    </div>
                    <div class="ml-4">
                        <p class="text-sm font-medium text-gray-600">Animal Types</p>
                        <p class="text-2xl font-bold text-gray-900">${animalTypesCount}</p>
                    </div>
                </div>
            </div>
            <div class="bg-white rounded-lg shadow p-6">
                <div class="flex items-center">
                    <div class="p-3 bg-orange-100 rounded-lg">
                        <i class="fas fa-users text-orange-600 text-xl"></i>
                    </div>
                    <div class="ml-4">
                        <p class="text-sm font-medium text-gray-600">Active Guides</p>
                        <p class="text-2xl font-bold text-gray-900">${activeGuidesCount}</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filters and Search -->
        <div class="bg-white rounded-lg shadow p-6 mb-8">
            <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                <div class="flex flex-col md:flex-row md:items-center gap-4">
                    <div>
                        <label for="animalType" class="block text-sm font-medium text-gray-700 mb-1">Animal Type</label>
                        <select id="animalType" onchange="filterSightings()"
                                class="border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                            <option value="">All Animals</option>
                            <c:forEach var="type" items="${animalTypes}">
                                <option value="${type}">${type}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div>
                        <label for="guideFilter" class="block text-sm font-medium text-gray-700 mb-1">Guide</label>
                        <select id="guideFilter" onchange="filterSightings()"
                                class="border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                            <option value="">All Guides</option>
                            <c:forEach var="guide" items="${guides}">
                                <option value="${guide.guideId}" ${guide.guideId == selectedGuideId ? 'selected' : ''}>${guide.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="flex-1 max-w-md">
                    <label for="search" class="block text-sm font-medium text-gray-700 mb-1">Search</label>
                    <input type="text" id="search" placeholder="Search by species, location..."
                           onkeyup="filterSightings()"
                           class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
            </div>
        </div>

        <!-- Sightings Grid -->
        <div class="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-6" id="sightingsContainer">
            <c:forEach var="sighting" items="${sightings}">
                <div class="bg-white rounded-xl shadow-lg overflow-hidden hover:shadow-xl transition duration-300 sighting-card"
                     data-animal-type="${sighting.animalType}"
                     data-guide-id="${sighting.guideId}"
                     data-species="${sighting.species}"
                     data-location="${sighting.location}">
                    <!-- Sighting ID Badge -->
                    <div class="absolute top-4 right-4 bg-blue-100 text-blue-800 text-xs font-medium px-2 py-1 rounded z-10">
                            ${sighting.sightId}
                    </div>

                    <!-- Sighting Photo -->
                    <div class="h-64 overflow-hidden relative">
                        <c:choose>
                            <c:when test="${sighting.hasPhoto()}">
                                <img src="${sighting.photoDataUrl}"
                                     alt="${sighting.animalType} - ${sighting.species}"
                                     class="w-full h-full object-cover transition duration-300 hover:scale-105">
                            </c:when>
                            <c:otherwise>
                                <div class="w-full h-full bg-gray-200 flex items-center justify-center">
                                    <i class="fas fa-camera text-4xl text-gray-400"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <!-- Guide Info Overlay -->
                        <div class="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black/70 to-transparent p-4">
                            <div class="flex items-center text-white">
                                <i class="fas fa-user mr-2"></i>
                                <span class="font-medium">
                                    <c:forEach var="guide" items="${guides}">
                                        <c:if test="${guide.guideId == sighting.guideId}">
                                            ${guide.name}
                                        </c:if>
                                    </c:forEach>
                                </span>
                            </div>
                        </div>
                    </div>

                    <!-- Sighting Details -->
                    <div class="p-6">
                        <div class="flex justify-between items-start mb-3">
                            <h3 class="text-xl font-bold text-gray-900">${sighting.animalType}</h3>
                            <span class="bg-green-100 text-green-800 text-sm font-medium px-3 py-1 rounded-full">
                                    ${sighting.species}
                            </span>
                        </div>

                        <div class="space-y-2 mb-4">
                            <div class="flex items-center text-gray-600">
                                <i class="fas fa-map-marker-alt mr-2 text-blue-600"></i>
                                <span>${not empty sighting.location ? sighting.location : 'Unknown Location'}</span>
                            </div>
                            <div class="flex items-center text-gray-600">
                                <i class="fas fa-clock mr-2 text-blue-600"></i>
                                <span>
                                    <!-- Custom date formatting for LocalDateTime -->
                                    <c:set var="sightingDate" value="${sighting.sightingDate}" />
                                    <c:out value="${sightingDate.month.toString().substring(0, 1).concat(sightingDate.month.toString().substring(1).toLowerCase())}
                                        ${sightingDate.dayOfMonth}, ${sightingDate.year} ${sightingDate.hour}:${sightingDate.minute < 10 ? '0' : ''}${sightingDate.minute}" />
                                </span>
                            </div>
                            <c:if test="${not empty sighting.coordinates}">
                                <div class="flex items-center text-gray-600">
                                    <i class="fas fa-location-dot mr-2 text-blue-600"></i>
                                    <span class="text-sm font-mono">${sighting.coordinates}</span>
                                </div>
                            </c:if>
                        </div>

                        <!-- Special Details -->
                        <c:if test="${not empty sighting.specialDetails}">
                            <div class="mb-4 p-3 bg-yellow-50 border border-yellow-200 rounded-lg">
                                <p class="text-sm text-yellow-800">
                                    <i class="fas fa-info-circle mr-1"></i>
                                        ${sighting.specialDetails}
                                </p>
                            </div>
                        </c:if>

                        <!-- Action Buttons -->
                        <c:if test="${sessionScope.guideId == sighting.guideId}">
                            <div class="flex space-x-2 mt-4 pt-4 border-t border-gray-200">
                                <a href="${pageContext.request.contextPath}/guides/sightings/edit/${sighting.id}"
                                   class="flex-1 bg-blue-600 text-white text-center py-2 px-4 rounded-lg hover:bg-blue-700 transition duration-200 text-sm">
                                    <i class="fas fa-edit mr-1"></i>Edit
                                </a>
                                <form action="${pageContext.request.contextPath}/guides/sightings/delete/${sighting.id}"
                                      method="post"
                                      onsubmit="return confirm('Are you sure you want to delete this sighting?')"
                                      class="flex-1">
                                    <button type="submit"
                                            class="w-full bg-red-600 text-white py-2 px-4 rounded-lg hover:bg-red-700 transition duration-200 text-sm">
                                        <i class="fas fa-trash mr-1"></i>Delete
                                    </button>
                                </form>
                            </div>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Empty State -->
        <c:if test="${empty sightings}">
            <div class="text-center py-12">
                <i class="fas fa-binoculars text-6xl text-gray-300 mb-4"></i>
                <h3 class="text-2xl font-bold text-gray-600 mb-2">No Sightings Recorded</h3>
                <p class="text-gray-500 mb-6">No wildlife sightings have been recorded yet.</p>
                <c:if test="${not empty sessionScope.guideId}">
                    <a href="${pageContext.request.contextPath}/guides/dashboard"
                       class="inline-flex items-center px-6 py-3 bg-blue-600 text-white font-semibold rounded-lg hover:bg-blue-700 transition duration-200">
                        <i class="fas fa-plus mr-2"></i>
                        Record First Sighting
                    </a>
                </c:if>
            </div>
        </c:if>
    </div>
</div>

<script>
    function filterSightings() {
        const animalType = document.getElementById('animalType').value.toLowerCase();
        const guideId = document.getElementById('guideFilter').value;
        const search = document.getElementById('search').value.toLowerCase();
        const cards = document.querySelectorAll('.sighting-card');

        let visibleCount = 0;

        cards.forEach(card => {
            const cardAnimalType = card.getAttribute('data-animal-type').toLowerCase();
            const cardGuideId = card.getAttribute('data-guide-id');
            const cardSpecies = card.getAttribute('data-species').toLowerCase();
            const cardLocation = card.getAttribute('data-location').toLowerCase();

            const matchesAnimalType = !animalType || cardAnimalType.includes(animalType);
            const matchesGuide = !guideId || cardGuideId === guideId;
            const matchesSearch = !search ||
                cardSpecies.includes(search) ||
                cardLocation.includes(search) ||
                cardAnimalType.includes(search);

            if (matchesAnimalType && matchesGuide && matchesSearch) {
                card.style.display = 'block';
                visibleCount++;
            } else {
                card.style.display = 'none';
            }
        });

        // Show empty state if no cards visible
        const emptyState = document.querySelector('.empty-state');
        if (visibleCount === 0 && cards.length > 0) {
            if (!emptyState) {
                const sightingsContainer = document.getElementById('sightingsContainer');
                const emptyDiv = document.createElement('div');
                emptyDiv.className = 'col-span-full text-center py-12 empty-state';
                emptyDiv.innerHTML = `
                <i class="fas fa-search text-6xl text-gray-300 mb-4"></i>
                <h3 class="text-2xl font-bold text-gray-600 mb-2">No Matching Sightings</h3>
                <p class="text-gray-500 mb-6">No sightings match your current filters.</p>
                <button onclick="clearFilters()" class="inline-flex items-center px-6 py-3 bg-blue-600 text-white font-semibold rounded-lg hover:bg-blue-700 transition duration-200">
                    <i class="fas fa-times mr-2"></i>
                    Clear Filters
                </button>
            `;
                sightingsContainer.appendChild(emptyDiv);
            }
        } else if (emptyState) {
            emptyState.remove();
        }
    }

    function clearFilters() {
        document.getElementById('animalType').value = '';
        document.getElementById('guideFilter').value = '';
        document.getElementById('search').value = '';
        filterSightings();
    }

    // Initialize filters on page load
    document.addEventListener('DOMContentLoaded', function() {
        filterSightings();
    });
</script>

<%@ include file="../Footer.jsp" %>
</body>
</html>