<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WildTrails - Finance Management</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-50">
<%@ include file="../Header.jsp" %>

<div class="min-h-screen py-8">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <!-- Header Section -->
        <div class="flex justify-between items-center mb-6">
            <div>
                <h1 class="text-4xl font-bold text-gray-900 mb-4">Finance Management</h1>
                <p class="text-lg text-gray-600">
                    Manage financial reports and generate detailed cost breakdowns for customers
                </p>
            </div>
            <div class="flex items-center space-x-4">
                <span class="text-gray-700">
                    <i class="fas fa-user-shield mr-2"></i>Finance Admin
                </span>
                <a href="${pageContext.request.contextPath}/reports/admin/logout"
                   class="inline-flex items-center px-4 py-2 bg-red-600 text-white font-medium rounded-lg hover:bg-red-700 transition duration-200">
                    <i class="fas fa-sign-out-alt mr-2"></i>Logout
                </a>
            </div>
        </div>

        <!-- Statistics Cards -->
        <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
            <div class="bg-white rounded-lg shadow p-6">
                <div class="flex items-center">
                    <div class="p-3 bg-blue-100 rounded-lg">
                        <i class="fas fa-file-invoice-dollar text-blue-600 text-2xl"></i>
                    </div>
                    <div class="ml-4">
                        <p class="text-sm font-medium text-gray-600">Pending Reports</p>
                        <p class="text-2xl font-bold text-gray-900">${pendingCount}</p>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-lg shadow p-6">
                <div class="flex items-center">
                    <div class="p-3 bg-green-100 rounded-lg">
                        <i class="fas fa-check-circle text-green-600 text-2xl"></i>
                    </div>
                    <div class="ml-4">
                        <p class="text-sm font-medium text-gray-600">Generated Reports</p>
                        <p class="text-2xl font-bold text-gray-900">${generatedCount}</p>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-lg shadow p-6">
                <div class="flex items-center">
                    <div class="p-3 bg-purple-100 rounded-lg">
                        <i class="fas fa-chart-line text-purple-600 text-2xl"></i>
                    </div>
                    <div class="ml-4">
                        <p class="text-sm font-medium text-gray-600">Total Reports</p>
                        <c:set var="totalReports" value="${pendingCount + generatedCount}" />
                        <p class="text-2xl font-bold text-gray-900">${totalReports}</p>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-lg shadow p-6">
                <div class="flex items-center">
                    <div class="p-3 bg-orange-100 rounded-lg">
                        <i class="fas fa-money-bill-wave text-orange-600 text-2xl"></i>
                    </div>
                    <div class="ml-4">
                        <p class="text-sm font-medium text-gray-600">Total Revenue</p>
                        <p class="text-2xl font-bold text-gray-900">Rs. 0.00</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Pending Reports Section -->
        <div class="bg-white rounded-xl shadow-lg overflow-hidden mb-8">
            <div class="px-6 py-4 border-b border-gray-200">
                <h2 class="text-xl font-bold text-gray-900">Pending Report Requests</h2>
                <p class="text-gray-600">Generate detailed financial reports for customers</p>
            </div>

            <div class="p-6">
                <c:if test="${empty pendingReports}">
                    <div class="text-center py-12">
                        <i class="fas fa-check-circle text-6xl text-gray-300 mb-4"></i>
                        <h3 class="text-2xl font-bold text-gray-600 mb-2">No Pending Reports</h3>
                        <p class="text-gray-500">All report requests have been processed.</p>
                    </div>
                </c:if>

                <c:forEach var="report" items="${pendingReports}">
                    <div class="border border-gray-200 rounded-lg p-6 mb-6">
                        <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-4">
                            <div>
                                <h3 class="text-lg font-bold text-gray-900">Report #${report.reportId}</h3>
                                <p class="text-gray-600">
                                    Booking ID: ${report.bookingId} •
                                    Requested:
                                    <fmt:parseDate value="${report.requestDate}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedRequestDate" />
                                    <fmt:formatDate value="${parsedRequestDate}" pattern="MMM d, yyyy 'at' h:mm a"/>
                                </p>
                            </div>
                            <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-yellow-100 text-yellow-800 mt-2 md:mt-0">
                                PENDING
                            </span>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Report Type</label>
                                <p class="text-gray-900">${report.reportType}</p>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">User ID</label>
                                <p class="text-gray-900">${report.userId}</p>
                            </div>
                        </div>

                        <div class="border-t border-gray-200 pt-4">
                            <form id="generateForm-${report.reportId}" onsubmit="generateReport(event, '${report.reportId}')">
                                <div class="mb-4">
                                    <label for="message-${report.reportId}" class="block text-sm font-medium text-gray-700 mb-2">
                                        Message to User
                                    </label>
                                    <textarea
                                            id="message-${report.reportId}"
                                            name="messageToUser"
                                            rows="3"
                                            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent"
                                            placeholder="Add a personalized message for the user..."
                                            required></textarea>
                                </div>

                                <div class="flex justify-end space-x-3">
                                    <button type="button" onclick="viewReportDetails('${report.reportId}')"
                                            class="inline-flex items-center px-4 py-2 bg-blue-600 text-white font-medium rounded-lg hover:bg-blue-700 transition duration-200">
                                        <i class="fas fa-eye mr-2"></i>
                                        View Details
                                    </button>
                                    <button type="submit"
                                            class="inline-flex items-center px-4 py-2 bg-green-600 text-white font-medium rounded-lg hover:bg-green-700 transition duration-200">
                                        <i class="fas fa-file-export mr-2"></i>
                                        Generate & Send Report
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- All Reports Section -->
        <div class="bg-white rounded-xl shadow-lg overflow-hidden">
            <div class="px-6 py-4 border-b border-gray-200">
                <h2 class="text-xl font-bold text-gray-900">All Generated Reports</h2>
                <p class="text-gray-600">View and manage all financial reports</p>
            </div>

            <div class="p-6">
                <c:if test="${empty allReports}">
                    <div class="text-center py-12">
                        <i class="fas fa-file-alt text-6xl text-gray-300 mb-4"></i>
                        <h3 class="text-2xl font-bold text-gray-600 mb-2">No Reports Found</h3>
                        <p class="text-gray-500">No financial reports have been generated yet.</p>
                    </div>
                </c:if>

                <c:if test="${not empty allReports}">
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Report ID</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Booking ID</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">User ID</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Type</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Total Cost</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Generated Date</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                            </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                            <c:forEach var="report" items="${allReports}">
                                <tr>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="text-sm font-medium text-gray-900">${report.reportId}</div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="text-sm text-gray-900">${report.bookingId}</div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="text-sm text-gray-900">${report.userId}</div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="text-sm text-gray-900">${report.reportType}</div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <c:choose>
                                            <c:when test="${report.status == 'GENERATED'}">
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                        GENERATED
                                                    </span>
                                            </c:when>
                                            <c:when test="${report.status == 'PENDING'}">
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">
                                                        PENDING
                                                    </span>
                                            </c:when>
                                            <c:otherwise>
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
                                                            ${report.status}
                                                    </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="text-sm text-gray-900">
                                            <c:if test="${report.totalCost != null}">
                                                Rs. <fmt:formatNumber value="${report.totalCost}" pattern="#,##0.00"/>
                                            </c:if>
                                            <c:if test="${report.totalCost == null}">
                                                -
                                            </c:if>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="text-sm text-gray-900">
                                            <c:if test="${report.generatedDate != null}">
                                                <fmt:parseDate value="${report.generatedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedGeneratedDate" />
                                                <fmt:formatDate value="${parsedGeneratedDate}" pattern="MMM d, yyyy"/>
                                            </c:if>
                                            <c:if test="${report.generatedDate == null}">
                                                -
                                            </c:if>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                        <div class="flex space-x-2">
                                            <button onclick="viewFullReportDetails('${report.reportId}')"
                                                    class="text-blue-600 hover:text-blue-900">
                                                <i class="fas fa-eye"></i> View
                                            </button>
                                            <c:if test="${report.status == 'GENERATED'}">
                                                <button onclick="openEditModalFromTable('${report.reportId}')"
                                                        class="text-green-600 hover:text-green-900">
                                                    <i class="fas fa-edit"></i> Edit
                                                </button>
                                            </c:if>
                                            <button onclick="deleteReport('${report.reportId}')"
                                                    class="text-red-600 hover:text-red-900">
                                                <i class="fas fa-trash"></i> Delete
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<!-- Report Details Modal -->
<div id="reportModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full hidden">
    <div class="relative top-20 mx-auto p-5 border w-11/12 md:w-3/4 lg:w-1/2 shadow-lg rounded-md bg-white">
        <div class="mt-3">
            <div class="flex justify-between items-center mb-4">
                <h3 class="text-xl font-bold text-gray-900">Report Details</h3>
                <button onclick="closeModal()" class="text-gray-400 hover:text-gray-600">
                    <i class="fas fa-times text-2xl"></i>
                </button>
            </div>
            <div id="modalContent" class="mt-2">
                <!-- Content will be loaded here -->
            </div>
        </div>
    </div>
</div>

<!-- Edit Report Modal -->
<div id="editModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full hidden">
    <div class="relative top-20 mx-auto p-5 border w-11/12 md:w-3/4 lg:w-1/2 shadow-lg rounded-md bg-white">
        <div class="mt-3">
            <div class="flex justify-between items-center mb-4">
                <h3 class="text-xl font-bold text-gray-900">Edit Report</h3>
                <button onclick="closeEditModal()" class="text-gray-400 hover:text-gray-600">
                    <i class="fas fa-times text-2xl"></i>
                </button>
            </div>
            <form id="editForm" onsubmit="updateReport(event)">
                <input type="hidden" id="editReportId" name="reportId">
                <div class="space-y-4">
                    <div>
                        <label for="editMessageToUser" class="block text-sm font-medium text-gray-700 mb-2">
                            Message to User
                        </label>
                        <textarea
                                id="editMessageToUser"
                                name="messageToUser"
                                rows="3"
                                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent"
                                placeholder="Update the message for the user..."
                                required></textarea>
                    </div>
                    <div>
                        <label for="editTotalCost" class="block text-sm font-medium text-gray-700 mb-2">
                            Total Cost (Rs.)
                        </label>
                        <input
                                type="number"
                                id="editTotalCost"
                                name="totalCost"
                                step="0.01"
                                min="0"
                                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent"
                                placeholder="Enter total cost"
                                required>
                    </div>
                    <!-- Add Report Content Editor -->
                    <div>
                        <label for="editReportContent" class="block text-sm font-medium text-gray-700 mb-2">
                            Report Content
                        </label>
                        <textarea
                                id="editReportContent"
                                name="reportContent"
                                rows="8"
                                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent font-mono text-sm"
                                placeholder="Edit the report content..."></textarea>
                        <p class="text-xs text-gray-500 mt-1">You can modify the detailed report content here.</p>
                    </div>
                    <div class="flex justify-end space-x-3 pt-4">
                        <button type="button" onclick="closeEditModal()"
                                class="inline-flex items-center px-4 py-2 bg-gray-600 text-white font-medium rounded-lg hover:bg-gray-700 transition duration-200">
                            Cancel
                        </button>
                        <button type="submit"
                                class="inline-flex items-center px-4 py-2 bg-green-600 text-white font-medium rounded-lg hover:bg-green-700 transition duration-200">
                            <i class="fas fa-save mr-2"></i>
                            Update Report
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Generate Report Function
    async function generateReport(event, reportId) {
        event.preventDefault();

        const form = document.getElementById('generateForm-' + reportId);
        const formData = new FormData(form);
        const messageToUser = formData.get('messageToUser');

        try {
            const response = await fetch('${pageContext.request.contextPath}/reports/admin/generate', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'reportId=' + reportId + '&messageToUser=' + encodeURIComponent(messageToUser)
            });

            const result = await response.text();

            if (response.ok) {
                showNotification('Report generated and sent successfully!', 'success');
                setTimeout(() => {
                    location.reload();
                }, 1500);
            } else {
                showNotification('Error: ' + result, 'error');
            }
        } catch (error) {
            showNotification('Network error: ' + error.message, 'error');
        }
    }

    // View Report Details
    async function viewReportDetails(reportId) {
        try {
            const response = await fetch('${pageContext.request.contextPath}/reports/admin/details/' + reportId);
            const report = await response.json();

            const modalContent = document.getElementById('modalContent');

            // Format dates using JavaScript
            const requestDate = report.requestDate ? new Date(report.requestDate).toLocaleString() : 'N/A';
            const generatedDate = report.generatedDate ? new Date(report.generatedDate).toLocaleString() : 'N/A';

            let modalHtml = '<div class="space-y-4">' +
                '<div class="grid grid-cols-2 gap-4">' +
                '<div><strong>Report ID:</strong><p>' + report.reportId + '</p></div>' +
                '<div><strong>Booking ID:</strong><p>' + report.bookingId + '</p></div>' +
                '</div>' +
                '<div class="grid grid-cols-2 gap-4">' +
                '<div><strong>User ID:</strong><p>' + report.userId + '</p></div>' +
                '<div><strong>Report Type:</strong><p>' + report.reportType + '</p></div>' +
                '</div>' +
                '<div><strong>Request Date:</strong><p>' + requestDate + '</p></div>';

            if (report.generatedDate) {
                modalHtml += '<div><strong>Generated Date:</strong><p>' + generatedDate + '</p></div>';
            }

            modalHtml += '<div><strong>Status:</strong>' +
                '<span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ' +
                (report.status === 'GENERATED' ? 'bg-green-100 text-green-800' : 'bg-yellow-100 text-yellow-800') + '">' +
                report.status + '</span></div>';

            if (report.totalCost) {
                modalHtml += '<div><strong>Total Cost:</strong><p>Rs. ' + parseFloat(report.totalCost).toFixed(2) + '</p></div>';
            }

            if (report.messageToUser) {
                modalHtml += '<div><strong>Message to User:</strong><p class="bg-gray-50 p-3 rounded-lg">' + report.messageToUser + '</p></div>';
            }

            if (report.reportContent) {
                modalHtml += '<div><strong>Report Content:</strong><pre class="bg-gray-50 p-3 rounded-lg whitespace-pre-wrap text-sm">' + report.reportContent + '</pre></div>';
            }

            modalHtml += '</div>';

            modalContent.innerHTML = modalHtml;
            document.getElementById('reportModal').classList.remove('hidden');
        } catch (error) {
            showNotification('Error loading report details: ' + error.message, 'error');
        }
    }

    // View Full Report Details (for generated reports)
    async function viewFullReportDetails(reportId) {
        await viewReportDetails(reportId);
    }

    // Open Edit Modal - Updated to include reportContent
    function openEditModal(reportId, messageToUser, totalCost, reportContent) {
        document.getElementById('editReportId').value = reportId;
        document.getElementById('editMessageToUser').value = messageToUser || '';
        document.getElementById('editTotalCost').value = totalCost || '';
        document.getElementById('editReportContent').value = reportContent || '';
        document.getElementById('editModal').classList.remove('hidden');
    }

    // Open Edit Modal from Table - Fetches report details first
    function openEditModalFromTable(reportId) {
        // Fetch report details first to get the current content
        fetch('${pageContext.request.contextPath}/reports/admin/details/' + reportId)
            .then(response => response.json())
            .then(report => {
                openEditModal(
                    report.reportId,
                    report.messageToUser,
                    report.totalCost,
                    report.reportContent
                );
            })
            .catch(error => {
                showNotification('Error loading report details: ' + error.message, 'error');
            });
    }

    // Close Edit Modal
    function closeEditModal() {
        document.getElementById('editModal').classList.add('hidden');
    }

    // Update Report - Modified to include reportContent
    async function updateReport(event) {
        event.preventDefault();

        const formData = new FormData(event.target);
        const reportId = formData.get('reportId');
        const messageToUser = formData.get('messageToUser');
        const totalCost = formData.get('totalCost');
        const reportContent = formData.get('reportContent');

        try {
            const response = await fetch('${pageContext.request.contextPath}/reports/admin/update', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'reportId=' + reportId +
                    '&messageToUser=' + encodeURIComponent(messageToUser) +
                    '&totalCost=' + totalCost +
                    '&reportContent=' + encodeURIComponent(reportContent)
            });

            const result = await response.text();

            if (response.ok) {
                showNotification('Report updated successfully!', 'success');
                closeEditModal();
                setTimeout(() => {
                    location.reload();
                }, 1500);
            } else {
                showNotification('Error: ' + result, 'error');
            }
        } catch (error) {
            showNotification('Network error: ' + error.message, 'error');
        }
    }

    // Delete Report
    async function deleteReport(reportId) {
        if (!confirm('Are you sure you want to delete this report? This action cannot be undone.')) {
            return;
        }

        try {
            const response = await fetch('${pageContext.request.contextPath}/reports/admin/delete', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'reportId=' + reportId
            });

            const result = await response.text();

            if (response.ok) {
                showNotification('Report deleted successfully!', 'success');
                setTimeout(() => {
                    location.reload();
                }, 1500);
            } else {
                showNotification('Error: ' + result, 'error');
            }
        } catch (error) {
            showNotification('Network error: ' + error.message, 'error');
        }
    }

    // Close Modal
    function closeModal() {
        document.getElementById('reportModal').classList.add('hidden');
    }

    // Notification Function
    function showNotification(message, type) {
        const notification = document.createElement('div');
        const bgColor = type === 'success' ? 'bg-green-500' : 'bg-red-500';
        const icon = type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle';

        notification.className = 'fixed top-4 right-4 p-4 rounded-lg shadow-lg text-white font-medium z-50 ' + bgColor;
        notification.innerHTML = '<div class="flex items-center">' +
            '<i class="fas ' + icon + ' mr-2"></i>' +
            '<span>' + message + '</span>' +
            '</div>';

        document.body.appendChild(notification);

        setTimeout(() => {
            notification.remove();
        }, 3000);
    }

    // Close modals when clicking outside
    document.getElementById('reportModal').addEventListener('click', function(event) {
        if (event.target === this) {
            closeModal();
        }
    });

    document.getElementById('editModal').addEventListener('click', function(event) {
        if (event.target === this) {
            closeEditModal();
        }
    });
</script>
</body>
</html>