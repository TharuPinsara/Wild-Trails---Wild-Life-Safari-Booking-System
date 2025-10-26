<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WildTrails - My Reports</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-50">
<%@ include file="../Header.jsp" %>

<div class="min-h-screen py-8">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <!-- Header Section -->
        <div class="text-center mb-12">
            <h1 class="text-4xl font-bold text-gray-900 mb-4">My Financial Reports</h1>
            <p class="text-lg text-gray-600 max-w-3xl mx-auto">
                View and download your detailed financial reports
            </p>
        </div>

        <!-- Reports List -->
        <div class="space-y-6">
            <c:forEach var="report" items="${reports}">
                <div class="bg-white rounded-xl shadow-lg overflow-hidden">
                    <div class="p-6">
                        <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-4">
                            <div>
                                <h3 class="text-xl font-bold text-gray-900">Report #${report.reportId}</h3>
                                <p class="text-gray-600">
                                    Booking ID: ${report.bookingId} •
                                    Requested:
                                    <fmt:parseDate value="${report.requestDate}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedRequestDate" />
                                    <fmt:formatDate value="${parsedRequestDate}" pattern="MMMM d, yyyy 'at' h:mm a"/>
                                </p>
                            </div>
                            <div class="mt-2 md:mt-0">
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
                            </div>
                        </div>

                        <c:if test="${report.status eq 'GENERATED'}">
                            <div class="bg-green-50 border border-green-200 rounded-lg p-4 mb-4">
                                <div class="flex items-center">
                                    <i class="fas fa-check-circle text-green-600 text-xl mr-3"></i>
                                    <div>
                                        <h4 class="font-semibold text-green-800">Report Ready</h4>
                                        <p class="text-green-700 text-sm">
                                            Generated on:
                                            <fmt:parseDate value="${report.generatedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedGeneratedDate" />
                                            <fmt:formatDate value="${parsedGeneratedDate}" pattern="MMMM d, yyyy 'at' h:mm a"/>
                                        </p>
                                        <c:if test="${not empty report.messageToUser}">
                                            <p class="text-green-700 mt-1">${report.messageToUser}</p>
                                        </c:if>
                                    </div>
                                </div>
                            </div>

                            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
                                <div class="bg-gray-50 rounded-lg p-4">
                                    <h4 class="font-semibold text-gray-900 mb-2">Total Cost</h4>
                                    <p class="text-2xl font-bold text-green-600">
                                        Rs.<fmt:formatNumber value="${report.totalCost}" pattern="#,##0.00"/>
                                    </p>
                                </div>

                                <div class="bg-gray-50 rounded-lg p-4">
                                    <h4 class="font-semibold text-gray-900 mb-2">Report Type</h4>
                                    <p class="text-lg text-gray-700">${report.reportType}</p>
                                </div>

                                <div class="bg-gray-50 rounded-lg p-4">
                                    <h4 class="font-semibold text-gray-900 mb-2">Finance Officer</h4>
                                    <p class="text-lg text-gray-700">ID: ${report.financeOfficerId}</p>
                                </div>
                            </div>
                        </c:if>

                        <c:if test="${report.status eq 'PENDING'}">
                            <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-4 mb-4">
                                <div class="flex items-center">
                                    <i class="fas fa-clock text-yellow-600 text-xl mr-3"></i>
                                    <div>
                                        <h4 class="font-semibold text-yellow-800">Report Pending</h4>
                                        <p class="text-yellow-700 text-sm">
                                            Your financial report is being processed by our finance team.
                                            You will receive a notification when it's ready.
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </c:if>

                        <div class="flex justify-end space-x-3">
                            <a href="${pageContext.request.contextPath}/reports/${report.reportId}"
                               class="inline-flex items-center px-4 py-2 bg-blue-600 text-white font-medium rounded-lg hover:bg-blue-700 transition duration-200">
                                <i class="fas fa-eye mr-2"></i>
                                View Details
                            </a>

                            <c:if test="${report.status eq 'GENERATED'}">
                                <button type="button" onclick="downloadReport('${report.reportId}')"
                                        class="inline-flex items-center px-4 py-2 bg-green-600 text-white font-medium rounded-lg hover:bg-green-700 transition duration-200">
                                    <i class="fas fa-download mr-2"></i>
                                    Download PDF
                                </button>

                                <button type="button" onclick="printReport('${report.reportId}')"
                                        class="inline-flex items-center px-4 py-2 bg-purple-600 text-white font-medium rounded-lg hover:bg-purple-700 transition duration-200">
                                    <i class="fas fa-print mr-2"></i>
                                    Print Report
                                </button>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Empty State -->
        <c:if test="${empty reports}">
            <div class="text-center py-12">
                <i class="fas fa-file-invoice-dollar text-6xl text-gray-300 mb-4"></i>
                <h3 class="text-2xl font-bold text-gray-600 mb-2">No Reports Found</h3>
                <p class="text-gray-500 mb-6">You haven't requested any financial reports yet.</p>
                <a href="${pageContext.request.contextPath}/bookings/mybookings"
                   class="inline-flex items-center px-6 py-3 bg-green-600 text-white font-semibold rounded-lg hover:bg-green-700 transition duration-200">
                    <i class="fas fa-arrow-left mr-2"></i>
                    Go to My Bookings
                </a>
            </div>
        </c:if>
    </div>
</div>

<%@ include file="../Footer.jsp" %>

<script>
    function downloadReport(reportId) {
        // In a real implementation, this would generate and download a PDF
        alert('PDF download feature would be implemented here for report: ' + reportId);
        // Example implementation:
        // window.location.href = '${pageContext.request.contextPath}/reports/' + reportId + '/download';
    }

    function printReport(reportId) {
        // In a real implementation, this would open a print-friendly version
        alert('Print feature would be implemented here for report: ' + reportId);
        // Example implementation:
        // window.open('${pageContext.request.contextPath}/reports/' + reportId + '/print', '_blank');
    }
</script>
</body>
</html>