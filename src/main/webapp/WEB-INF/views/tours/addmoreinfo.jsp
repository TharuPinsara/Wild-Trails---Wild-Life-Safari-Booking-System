<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WildTrails - Add More Info</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-50 flex flex-col min-h-screen">
<%@ include file="../Header.jsp" %>

<div class="flex-grow py-8">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <!-- Header -->
        <div class="text-center mb-8">
            <h1 class="text-3xl font-bold text-gray-900 mb-2">Add More Information</h1>
            <p class="text-gray-600">Add detailed information for: ${tour.tourName}</p>
            <div class="mt-4 space-x-4">
                <a href="${pageContext.request.contextPath}/tours/view"
                   class="inline-flex items-center text-purple-600 hover:text-purple-700">
                    <i class="fas fa-arrow-left mr-2"></i>Back to Tours
                </a>
                <a href="${pageContext.request.contextPath}/tours/${tour.tourId}"
                   class="inline-flex items-center text-blue-600 hover:text-blue-700">
                    <i class="fas fa-eye mr-2"></i>View Tour
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

        <!-- More Info Form -->
        <div class="bg-white rounded-xl shadow-lg p-8">
            <form action="${pageContext.request.contextPath}/tours/${tour.tourId}/add-info" method="post" class="space-y-6">
                <div>
                    <label for="description" class="block text-sm font-medium text-gray-700 mb-2">Tour Description</label>
                    <textarea id="description" name="description" rows="4"
                              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent transition duration-200"
                              placeholder="Provide a detailed description of the tour...">${moreInfo.description}</textarea>
                </div>

                <div>
                    <label for="placesToVisit" class="block text-sm font-medium text-gray-700 mb-2">Places to Visit</label>
                    <textarea id="placesToVisit" name="placesToVisit" rows="3"
                              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent transition duration-200"
                              placeholder="List all the places included in this tour...">${moreInfo.placesToVisit}</textarea>
                </div>

                <div>
                    <label for="itinerary" class="block text-sm font-medium text-gray-700 mb-2">Detailed Itinerary</label>
                    <textarea id="itinerary" name="itinerary" rows="5"
                              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent transition duration-200"
                              placeholder="Provide a day-by-day itinerary...">${moreInfo.itinerary}</textarea>
                </div>

                <div>
                    <label for="includedServices" class="block text-sm font-medium text-gray-700 mb-2">Included Services</label>
                    <textarea id="includedServices" name="includedServices" rows="3"
                              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent transition duration-200"
                              placeholder="List all services included in the package...">${moreInfo.includedServices}</textarea>
                </div>

                <div>
                    <label for="excludedServices" class="block text-sm font-medium text-gray-700 mb-2">Excluded Services</label>
                    <textarea id="excludedServices" name="excludedServices" rows="3"
                              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent transition duration-200"
                              placeholder="List services not included in the package...">${moreInfo.excludedServices}</textarea>
                </div>

                <div>
                    <label for="importantNotes" class="block text-sm font-medium text-gray-700 mb-2">Important Notes</label>
                    <textarea id="importantNotes" name="importantNotes" rows="3"
                              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent transition duration-200"
                              placeholder="Add any important notes or requirements...">${moreInfo.importantNotes}</textarea>
                </div>

                <div class="flex justify-end space-x-4 pt-6">
                    <a href="${pageContext.request.contextPath}/tours/view"
                       class="px-6 py-3 border border-gray-300 text-gray-700 font-medium rounded-lg hover:bg-gray-50 transition duration-200">
                        Cancel
                    </a>
                    <button type="submit"
                            class="px-6 py-3 bg-purple-600 text-white font-medium rounded-lg hover:bg-purple-700 transition duration-200">
                        <i class="fas fa-save mr-2"></i>
                        Save Information
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="../Footer.jsp" %>
</body>
</html>