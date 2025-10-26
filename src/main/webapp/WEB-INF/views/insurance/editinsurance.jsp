<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WildTrails - Edit Insurance</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-50">
<%@ include file="../Header.jsp" %>

<div class="min-h-screen py-8">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <!-- Header -->
        <div class="text-center mb-8">
            <h1 class="text-3xl font-bold text-gray-900 mb-2">Edit Insurance Plan</h1>
            <p class="text-gray-600">Update insurance plan details</p>
            <div class="mt-4">
                <a href="${pageContext.request.contextPath}/insurance/admin/dashboard"
                   class="inline-flex items-center text-purple-600 hover:text-purple-700">
                    <i class="fas fa-arrow-left mr-2"></i>Back to Dashboard
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

        <!-- Edit Insurance Form -->
        <div class="bg-white rounded-xl shadow-lg p-8">
            <form action="${pageContext.request.contextPath}/insurance/admin/update/${insurance.insuranceId}" method="post" class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                    <label for="companyName" class="block text-sm font-medium text-gray-700 mb-2">Insurance Company *</label>
                    <input type="text" id="companyName" name="companyName" required
                           value="${insurance.companyName}"
                           class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent"
                           placeholder="e.g., Ceylinco Insurance">
                </div>

                <div>
                    <label for="insuranceType" class="block text-sm font-medium text-gray-700 mb-2">Traveler Type *</label>
                    <select id="insuranceType" name="insuranceType" required
                            class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent">
                        <option value="">Select traveler type</option>
                        <option value="foreign" ${insurance.insuranceType == 'foreign' ? 'selected' : ''}>Foreign Tourist</option>
                        <option value="local" ${insurance.insuranceType == 'local' ? 'selected' : ''}>Local Traveler</option>
                    </select>
                </div>

                <div>
                    <label for="coverageType" class="block text-sm font-medium text-gray-700 mb-2">Coverage Type *</label>
                    <select id="coverageType" name="coverageType" required
                            class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent">
                        <option value="">Select coverage type</option>
                        <option value="full" ${insurance.coverageType == 'full' ? 'selected' : ''}>Full Coverage</option>
                        <option value="half" ${insurance.coverageType == 'half' ? 'selected' : ''}>Half Coverage</option>
                        <option value="basic" ${insurance.coverageType == 'basic' ? 'selected' : ''}>Basic Coverage</option>
                        <option value="premium" ${insurance.coverageType == 'premium' ? 'selected' : ''}>Premium Coverage</option>
                    </select>
                </div>

                <div>
                    <label for="pricePerDayPerPerson" class="block text-sm font-medium text-gray-700 mb-2">Price per Day per Person *</label>
                    <input type="number" id="pricePerDayPerPerson" name="pricePerDayPerPerson" required step="0.01" min="0"
                           value="${insurance.pricePerDayPerPerson}"
                           class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent"
                           placeholder="0.00">
                </div>

                <div>
                    <label for="maxDays" class="block text-sm font-medium text-gray-700 mb-2">Maximum Days *</label>
                    <input type="number" id="maxDays" name="maxDays" required min="1" max="365"
                           value="${insurance.maxDays}"
                           class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent"
                           placeholder="30">
                </div>

                <div class="md:col-span-2">
                    <label for="description" class="block text-sm font-medium text-gray-700 mb-2">Description</label>
                    <textarea id="description" name="description" rows="3"
                              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent"
                              placeholder="Brief description of the insurance plan...">${insurance.description}</textarea>
                </div>

                <div class="md:col-span-2">
                    <label for="specialFeatures" class="block text-sm font-medium text-gray-700 mb-2">Special Features (comma separated)</label>
                    <textarea id="specialFeatures" name="specialFeatures" rows="3"
                              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent"
                              placeholder="Medical coverage, Trip cancellation, Lost baggage...">${insurance.specialFeatures}</textarea>
                </div>

                <div class="md:col-span-2 flex justify-end space-x-4">
                    <a href="${pageContext.request.contextPath}/insurance/admin/dashboard"
                       class="px-6 py-3 border border-gray-300 text-gray-700 font-medium rounded-lg hover:bg-gray-50 transition duration-200">
                        Cancel
                    </a>
                    <button type="submit"
                            class="px-6 py-3 bg-green-600 text-white font-medium rounded-lg hover:bg-green-700 transition duration-200">
                        <i class="fas fa-save mr-2"></i>
                        Update Insurance Plan
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="../Footer.jsp" %>
</body>
</html>