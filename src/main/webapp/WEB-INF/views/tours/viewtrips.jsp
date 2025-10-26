<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WildTrails - View All Tours</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-50 flex flex-col min-h-screen">
<%@ include file="../Header.jsp" %>

<div class="flex-grow py-8">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <!-- Header Section -->
        <div class="text-center mb-12">
            <h1 class="text-4xl font-bold text-gray-900 mb-4">All Tour Packages</h1>
            <p class="text-lg text-gray-600 max-w-3xl mx-auto">
                Manage and add more information to existing tour packages.
            </p>
            <div class="mt-6 flex justify-center space-x-4">
                <a href="${pageContext.request.contextPath}/tours/add"
                   class="inline-flex items-center px-6 py-3 bg-purple-600 text-white font-semibold rounded-lg hover:bg-purple-700 transition duration-200">
                    <i class="fas fa-plus mr-2"></i>
                    Add New Tour
                </a>
                <a href="${pageContext.request.contextPath}/tours"
                   class="inline-flex items-center px-6 py-3 bg-green-600 text-white font-semibold rounded-lg hover:bg-green-700 transition duration-200">
                    <i class="fas fa-eye mr-2"></i>
                    View Public Page
                </a>
                <a href="${pageContext.request.contextPath}/tours/logout"
                   class="inline-flex items-center px-6 py-3 bg-red-600 text-white font-semibold rounded-lg hover:bg-red-700 transition duration-200">
                    <i class="fas fa-sign-out-alt mr-2"></i>
                    Logout
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

        <!-- Tours Table -->
        <div class="bg-white rounded-xl shadow-lg overflow-hidden">
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                    <tr>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tour ID</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tour Name</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Duration</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Destination</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Price</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                    </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                    <c:forEach var="tour" items="${tours}">
                        <tr class="hover:bg-gray-50">
                            <td class="px-6 py-4 whitespace-nowrap">
                                <span class="bg-purple-100 text-purple-800 text-xs font-medium px-2 py-1 rounded">${tour.tourId}</span>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <div class="flex items-center">
                                    <c:if test="${not empty tour.tourPhotoData}">
                                        <img src="${pageContext.request.contextPath}/tours/photo/${tour.tourId}"
                                             alt="${tour.tourName}"
                                             class="h-10 w-10 rounded-full object-cover mr-3">
                                    </c:if>
                                    <div>
                                        <div class="text-sm font-medium text-gray-900">${tour.tourName}</div>
                                        <div class="text-sm text-gray-500">
                                            <c:if test="${tour.includesBreakfast}"><span class="text-green-600">B</span></c:if>
                                            <c:if test="${tour.includesLunch}"><span class="text-yellow-600">L</span></c:if>
                                            <c:if test="${tour.includesDinner}"><span class="text-red-600">D</span></c:if>
                                        </div>
                                    </div>
                                </div>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                    <span class="bg-blue-100 text-blue-800 text-sm font-medium px-2 py-1 rounded">
                                        ${tour.durationDays} ${tour.durationDays == 1 ? 'Day' : 'Days'}
                                    </span>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${tour.destination}</td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                                Rs. <fmt:formatNumber value="${tour.price}" pattern="#,##0.00"/>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium space-x-2">
                                <a href="${pageContext.request.contextPath}/tours/${tour.tourId}"
                                   class="text-blue-600 hover:text-blue-900">
                                    <i class="fas fa-eye mr-1"></i>View
                                </a>
                                <a href="${pageContext.request.contextPath}/tours/${tour.tourId}/add-info"
                                   class="text-green-600 hover:text-green-900">
                                    <i class="fas fa-edit mr-1"></i>Add Info
                                </a>
                                <button onclick="confirmDelete('${tour.tourId}', '${tour.tourName}')"
                                        class="text-red-600 hover:text-red-900">
                                    <i class="fas fa-trash mr-1"></i>Delete
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Empty State -->
        <c:if test="${empty tours}">
            <div class="text-center py-12">
                <i class="fas fa-mountain text-6xl text-gray-300 mb-4"></i>
                <h3 class="text-2xl font-bold text-gray-600 mb-2">No Tours Available</h3>
                <p class="text-gray-500 mb-6">You haven't added any tours yet.</p>
                <a href="${pageContext.request.contextPath}/tours/add"
                   class="inline-flex items-center px-6 py-3 bg-purple-600 text-white font-semibold rounded-lg hover:bg-purple-700 transition duration-200">
                    <i class="fas fa-plus mr-2"></i>
                    Add First Tour
                </a>
            </div>
        </c:if>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div id="deleteModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full hidden">
    <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
        <div class="mt-3">
            <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-red-100">
                <i class="fas fa-exclamation-triangle text-red-600 text-xl"></i>
            </div>
            <div class="mt-3 text-center">
                <h3 class="text-lg font-medium text-gray-900">Delete Tour</h3>
                <div class="mt-2 px-7 py-3">
                    <p class="text-sm text-gray-500" id="deleteMessage">
                        Are you sure you want to delete this tour? This action cannot be undone.
                    </p>
                </div>
                <div class="flex justify-center space-x-3 mt-4">
                    <button id="cancelDelete"
                            class="px-4 py-2 bg-gray-300 text-gray-700 text-sm font-medium rounded-md hover:bg-gray-400 focus:outline-none focus:ring-2 focus:ring-gray-300">
                        Cancel
                    </button>
                    <form id="deleteForm" method="post" class="inline">
                        <button type="submit"
                                class="px-4 py-2 bg-red-600 text-white text-sm font-medium rounded-md hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-red-500">
                            Delete
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function confirmDelete(tourId, tourName) {
        const modal = document.getElementById('deleteModal');
        const message = document.getElementById('deleteMessage');
        const form = document.getElementById('deleteForm');

        // Update the message
        message.textContent = 'Are you sure you want to delete "' + tourName + '"? This action cannot be undone.';

        // Update the form action
        form.action = '${pageContext.request.contextPath}/tours/' + tourId + '/delete';

        // Show the modal
        modal.classList.remove('hidden');

        // Add event listener for cancel button
        document.getElementById('cancelDelete').onclick = function() {
            modal.classList.add('hidden');
        };

        // Close modal when clicking outside
        modal.onclick = function(event) {
            if (event.target === modal) {
                modal.classList.add('hidden');
            }
        };
    }
</script>

<%@ include file="../Footer.jsp" %>
</body>
</html>