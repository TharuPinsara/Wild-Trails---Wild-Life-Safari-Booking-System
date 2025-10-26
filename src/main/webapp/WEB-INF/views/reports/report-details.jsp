<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WildTrails - Report Details</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-50">
<%@ include file="../Header.jsp" %>

<div class="min-h-screen py-8">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <!-- Header Section -->
        <div class="text-center mb-8">
            <h1 class="text-3xl font-bold text-gray-900 mb-2">Financial Report</h1>
            <p class="text-lg text-gray-600">Detailed cost breakdown and booking information</p>
        </div>

        <!-- Report Card -->
        <div class="bg-white rounded-xl shadow-lg overflow-hidden">
            <!-- Report Header -->
            <div class="bg-gradient-to-r from-green-600 to-blue-600 p-6 text-white">
                <div class="flex flex-col md:flex-row md:items-center md:justify-between">
                    <div>
                        <h2 class="text-2xl font-bold">Report #${report.reportId}</h2>
                        <p class="text-green-100">
                            Generated on:
                            <c:if test="${not empty report.generatedDate}">
                                <fmt:parseDate value="${report.generatedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedGeneratedDate" />
                                <fmt:formatDate value="${parsedGeneratedDate}" pattern="MMMM d, yyyy 'at' h:mm a"/>
                            </c:if>
                        </p>
                    </div>
                    <div class="mt-4 md:mt-0">
                        <span class="inline-flex items-center px-4 py-2 bg-white bg-opacity-20 rounded-full text-sm font-medium">
                            <i class="fas fa-file-invoice-dollar mr-2"></i>
                            ${report.reportType}
                        </span>
                    </div>
                </div>
            </div>

            <!-- Report Content -->
            <div class="p-6">
                <!-- Status Badge -->
                <div class="flex justify-between items-center mb-6">
                    <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium
                        ${report.status eq 'GENERATED' ? 'bg-green-100 text-green-800' :
                          report.status eq 'PENDING' ? 'bg-yellow-100 text-yellow-800' :
                          'bg-red-100 text-red-800'}">
                        <c:choose>
                            <c:when test="${report.status eq 'GENERATED'}">
                                <i class="fas fa-check-circle mr-1"></i>
                            </c:when>
                            <c:when test="${report.status eq 'PENDING'}">
                                <i class="fas fa-clock mr-1"></i>
                            </c:when>
                            <c:otherwise>
                                <i class="fas fa-times-circle mr-1"></i>
                            </c:otherwise>
                        </c:choose>
                        ${report.status}
                    </span>

                    <c:if test="${report.status eq 'GENERATED'}">
                        <div class="flex space-x-2">
                            <button onclick="window.print()"
                                    class="inline-flex items-center px-3 py-2 bg-blue-600 text-white text-sm font-medium rounded-lg hover:bg-blue-700 transition duration-200">
                                <i class="fas fa-print mr-1"></i>
                                Print
                            </button>
                        </div>
                    </c:if>
                </div>

                <!-- Financial Summary -->
                <c:if test="${report.status eq 'GENERATED'}">
                    <div class="bg-green-50 border border-green-200 rounded-lg p-6 mb-6">
                        <div class="text-center">
                            <p class="text-green-700 text-sm font-medium mb-2">TOTAL COST</p>
                            <p class="text-4xl font-bold text-green-800">
                                Rs.<fmt:formatNumber value="${report.totalCost}" pattern="#,##0.00"/>
                            </p>
                            <p class="text-green-600 mt-2">All inclusive - No hidden charges</p>
                        </div>
                    </div>

                    <!-- Message from Finance Officer -->
                    <c:if test="${not empty report.messageToUser}">
                        <div class="bg-blue-50 border border-blue-200 rounded-lg p-4 mb-6">
                            <div class="flex">
                                <i class="fas fa-comment-alt text-blue-600 text-xl mr-3 mt-1"></i>
                                <div>
                                    <h4 class="font-semibold text-blue-800 mb-1">Message from Finance Team</h4>
                                    <p class="text-blue-700">${report.messageToUser}</p>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <!-- Report Content -->
                    <div class="bg-gray-50 rounded-lg p-6">
                        <h3 class="text-xl font-bold text-gray-900 mb-4">Detailed Report</h3>
                        <div class="whitespace-pre-line text-gray-700 leading-relaxed">
                                ${report.reportContent}
                        </div>
                    </div>
                </c:if>

                <c:if test="${report.status eq 'PENDING'}">
                    <div class="text-center py-8">
                        <i class="fas fa-clock text-6xl text-yellow-400 mb-4"></i>
                        <h3 class="text-xl font-bold text-gray-700 mb-2">Report Processing</h3>
                        <p class="text-gray-600 max-w-md mx-auto">
                            Your financial report is being carefully prepared by our finance team.
                            We're calculating all costs and preparing a detailed breakdown for you.
                        </p>
                        <p class="text-gray-500 text-sm mt-4">
                            Requested on:
                            <fmt:parseDate value="${report.requestDate}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedRequestDate" />
                            <fmt:formatDate value="${parsedRequestDate}" pattern="MMMM d, yyyy 'at' h:mm a"/>
                        </p>
                    </div>
                </c:if>

                <!-- Action Buttons -->
                <div class="flex justify-between items-center mt-8 pt-6 border-t border-gray-200">
                    <a href="${pageContext.request.contextPath}/reports/myreports"
                       class="inline-flex items-center px-4 py-2 bg-gray-600 text-white font-medium rounded-lg hover:bg-gray-700 transition duration-200">
                        <i class="fas fa-arrow-left mr-2"></i>
                        Back to Reports
                    </a>

                    <a href="${pageContext.request.contextPath}/bookings/mybookings"
                       class="inline-flex items-center px-4 py-2 bg-green-600 text-white font-medium rounded-lg hover:bg-green-700 transition duration-200">
                        <i class="fas fa-calendar-alt mr-2"></i>
                        View My Bookings
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../Footer.jsp" %>

<script>
    function downloadReport() {
        // In a real implementation, this would generate and download a PDF
        alert('PDF download feature would generate a formatted version of this report');
        // Example: window.location.href = '${pageContext.request.contextPath}/reports/${report.reportId}/download';
    }

    // Print styles
    const style = document.createElement('style');
    style.innerHTML = `
        @media print {
            .bg-gray-50 { background: white !important; }
            .shadow-lg { box-shadow: none !important; }
            .rounded-xl { border-radius: 0 !important; }
            .p-6 { padding: 1rem !important; }
            .mb-6 { margin-bottom: 1rem !important; }
            .bg-gradient-to-r { background: #2563eb !important; }
            button { display: none !important; }
            a { display: none !important; }
            .border-t { border-top: 1px solid #e5e7eb !important; }
        }
    `;
    document.head.appendChild(style);
</script>
</body>
</html>