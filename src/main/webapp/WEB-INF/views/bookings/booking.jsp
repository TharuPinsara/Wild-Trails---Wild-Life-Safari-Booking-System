<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Tour - ${tour.tourName}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .selection-card {
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }
        .selection-card.selected {
            border-color: #8b5cf6;
            box-shadow: 0 10px 25px -5px rgba(139, 92, 246, 0.2);
        }
        .selection-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body class="bg-gray-50 flex flex-col min-h-screen">
<%@ include file="../Header.jsp" %>

<div class="flex-grow py-8">
    <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
        <!-- Breadcrumb -->
        <nav class="flex mb-8" aria-label="Breadcrumb">
            <ol class="flex items-center space-x-2">
                <li><a href="${pageContext.request.contextPath}/tours" class="text-gray-500 hover:text-gray-700">Tours</a></li>
                <li><span class="text-gray-400 mx-2">/</span></li>
                <li><a href="${pageContext.request.contextPath}/tours/${tour.tourId}" class="text-gray-500 hover:text-gray-700">${tour.tourName}</a></li>
                <li><span class="text-gray-400 mx-2">/</span></li>
                <li class="text-gray-900 font-medium">Book Now</li>
            </ol>
        </nav>

        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="mb-6 bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded">
                <i class="fas fa-exclamation-triangle mr-2"></i>${error}
            </div>
        </c:if>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            <!-- Left Column - Booking Form -->
            <div class="lg:col-span-2">
                <div class="bg-white rounded-xl shadow-lg overflow-hidden">
                    <div class="p-8">
                        <h1 class="text-3xl font-bold text-gray-900 mb-2">Book ${tour.tourName}</h1>
                        <p class="text-gray-600 mb-8">Complete your booking by filling the details below</p>

                        <form id="bookingForm" action="${pageContext.request.contextPath}/bookings/create" method="post">
                            <input type="hidden" name="tourId" value="${tour.tourId}">
                            <input type="hidden" name="totalAmount" id="totalAmountHidden" value="${tour.price}">

                            <!-- FIXED: Corrected parameter names to match controller -->
                            <input type="hidden" name="selectedVehicles" id="selectedVehiclesInput" value="">
                            <input type="hidden" name="selectedGuideId" id="selectedGuideIdInput" value="">
                            <input type="hidden" name="insurancePlanId" id="insurancePlanIdInput" value="">

                            <!-- Trip Details -->
                            <div class="mb-8">
                                <h2 class="text-xl font-semibold text-gray-900 mb-4">Trip Details</h2>
                                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-2">Trip Date *</label>
                                        <input type="date" name="tripDate" id="tripDate" required
                                               min="${java.time.LocalDate.now().plusDays(1)}"
                                               class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-purple-600">
                                        <p class="text-xs text-gray-500 mt-1">Select a future date</p>
                                    </div>
                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-2">Duration (Days) *</label>
                                        <input type="number" name="durationDays" id="durationDays"
                                               value="${tour.durationDays}" min="1" max="30" required
                                               class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-purple-600">
                                    </div>
                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-2">Total Persons *</label>
                                        <input type="number" name="numberOfPersons" id="numberOfPersons"
                                               value="1" min="1" max="50" required readonly
                                               class="w-full px-3 py-2 border border-gray-300 rounded-md bg-gray-100 focus:outline-none focus:ring-2 focus:ring-purple-600">
                                        <p class="text-xs text-gray-500 mt-1">Auto-calculated total</p>
                                    </div>
                                </div>
                            </div>

                            <!-- Person Breakdown -->
                            <div class="mb-8">
                                <h2 class="text-xl font-semibold text-gray-900 mb-4">Person Breakdown</h2>
                                <div class="bg-gray-50 rounded-lg p-6 border border-gray-200">
                                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                                        <div>
                                            <label class="block text-sm font-medium text-gray-700 mb-2">Adults</label>
                                            <div class="flex items-center space-x-2">
                                                <button type="button" onclick="changeAdultCount(-1)" class="w-8 h-8 bg-gray-200 rounded-full flex items-center justify-center hover:bg-gray-300">
                                                    <i class="fas fa-minus text-gray-600 text-xs"></i>
                                                </button>
                                                <input type="number" name="numberOfAdults" id="numberOfAdults"
                                                       value="1" min="0" max="50" required
                                                       class="w-16 px-2 py-2 border border-gray-300 rounded-md text-center focus:outline-none focus:ring-2 focus:ring-purple-600"
                                                       onchange="updateTotalPersons()">
                                                <button type="button" onclick="changeAdultCount(1)" class="w-8 h-8 bg-gray-200 rounded-full flex items-center justify-center hover:bg-gray-300">
                                                    <i class="fas fa-plus text-gray-600 text-xs"></i>
                                                </button>
                                            </div>
                                            <p class="text-xs text-gray-500 mt-1">Full price</p>
                                        </div>

                                        <div>
                                            <label class="block text-sm font-medium text-gray-700 mb-2">Children <span class="text-green-600">(50% off)</span></label>
                                            <div class="flex items-center space-x-2">
                                                <button type="button" onclick="changeChildCount(-1)" class="w-8 h-8 bg-gray-200 rounded-full flex items-center justify-center hover:bg-gray-300">
                                                    <i class="fas fa-minus text-gray-600 text-xs"></i>
                                                </button>
                                                <input type="number" name="numberOfChildren" id="numberOfChildren"
                                                       value="0" min="0" max="50" required
                                                       class="w-16 px-2 py-2 border border-gray-300 rounded-md text-center focus:outline-none focus:ring-2 focus:ring-purple-600"
                                                       onchange="updateTotalPersons()">
                                                <button type="button" onclick="changeChildCount(1)" class="w-8 h-8 bg-gray-200 rounded-full flex items-center justify-center hover:bg-gray-300">
                                                    <i class="fas fa-plus text-gray-600 text-xs"></i>
                                                </button>
                                            </div>
                                            <p class="text-xs text-gray-500 mt-1">Under 12 years</p>
                                        </div>

                                        <div>
                                            <label class="block text-sm font-medium text-gray-700 mb-2">Students <span class="text-blue-600">(20% off)</span></label>
                                            <div class="flex items-center space-x-2">
                                                <button type="button" onclick="changeStudentCount(-1)" class="w-8 h-8 bg-gray-200 rounded-full flex items-center justify-center hover:bg-gray-300">
                                                    <i class="fas fa-minus text-gray-600 text-xs"></i>
                                                </button>
                                                <input type="number" name="numberOfStudents" id="numberOfStudents"
                                                       value="0" min="0" max="50" required
                                                       class="w-16 px-2 py-2 border border-gray-300 rounded-md text-center focus:outline-none focus:ring-2 focus:ring-purple-600"
                                                       onchange="updateTotalPersons()">
                                                <button type="button" onclick="changeStudentCount(1)" class="w-8 h-8 bg-gray-200 rounded-full flex items-center justify-center hover:bg-gray-300">
                                                    <i class="fas fa-plus text-gray-600 text-xs"></i>
                                                </button>
                                            </div>
                                            <p class="text-xs text-gray-500 mt-1">Valid ID required</p>
                                        </div>
                                    </div>

                                    <!-- Summary -->
                                    <div class="mt-4 pt-4 border-t border-gray-200">
                                        <div class="grid grid-cols-2 gap-2 text-sm">
                                            <div class="flex justify-between">
                                                <span class="text-gray-600">Adults:</span>
                                                <span id="adultsSummary">1</span>
                                            </div>
                                            <div class="flex justify-between">
                                                <span class="text-gray-600">Children (50% off):</span>
                                                <span id="childrenSummary">0</span>
                                            </div>
                                            <div class="flex justify-between">
                                                <span class="text-gray-600">Students (20% off):</span>
                                                <span id="studentsSummary">0</span>
                                            </div>
                                            <div class="flex justify-between font-semibold text-gray-900">
                                                <span>Total Persons:</span>
                                                <span id="totalPersonsSummary">1</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Vehicle Selection -->
                            <div class="mb-8" id="vehicleSection">
                                <div class="flex justify-between items-center mb-4">
                                    <h2 class="text-xl font-semibold text-gray-900">Select Vehicles</h2>
                                    <span class="text-sm text-gray-500">(Optional - Select multiple)</span>
                                </div>

                                <!-- Vehicles Container -->
                                <div id="availableVehicles" class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <c:forEach var="vehicle" items="${vehicles}">
                                        <div class="selection-card bg-white border border-gray-200 rounded-lg p-4 cursor-pointer vehicle-option"
                                             data-vehicle-id="${vehicle.vehicleId}"
                                             data-daily-rate="${vehicle.dailyRate}"
                                             onclick="toggleVehicleSelection('${vehicle.vehicleId}', ${vehicle.dailyRate}, this)">
                                            <div class="flex justify-between items-start mb-2">
                                                <div>
                                                    <h3 class="font-semibold text-gray-900">${vehicle.vehicleName}</h3>
                                                    <p class="text-sm text-gray-600">ID: ${vehicle.vehicleId}</p>
                                                </div>
                                                <span class="bg-green-100 text-green-800 text-xs font-medium px-2 py-1 rounded">
                                                        ${vehicle.vehicleType}
                                                </span>
                                            </div>

                                            <div class="space-y-1 text-sm text-gray-600 mb-3">
                                                <div class="flex items-center">
                                                    <i class="fas fa-users mr-2"></i>
                                                    <span>Capacity: ${vehicle.capacity} persons</span>
                                                </div>
                                                <div class="flex items-center">
                                                    <i class="fas fa-user mr-2"></i>
                                                    <span>Driver: ${vehicle.driverName}</span>
                                                </div>
                                                <div class="flex items-center">
                                                    <i class="fas fa-phone mr-2"></i>
                                                    <span>${vehicle.driverPhone}</span>
                                                </div>
                                            </div>

                                            <div class="flex justify-between items-center mt-3 pt-3 border-t border-gray-200">
                                                <span class="text-lg font-bold text-green-600">
                                                    Rs. <fmt:formatNumber value="${vehicle.dailyRate}" pattern="#,##0.00"/>/day
                                                </span>
                                                <div class="flex items-center">
                                                    <div class="w-4 h-4 border-2 border-gray-300 rounded flex items-center justify-center mr-2 vehicle-checkbox">
                                                        <i class="fas fa-check text-white text-xs hidden"></i>
                                                    </div>
                                                    <span class="text-xs text-gray-600">Select</span>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                    <c:if test="${empty vehicles}">
                                        <div class="text-center py-8 border-2 border-dashed border-gray-300 rounded-lg">
                                            <i class="fas fa-car text-4xl text-gray-400 mb-4"></i>
                                            <p class="text-gray-500 text-lg mb-2">No vehicles available</p>
                                            <p class="text-gray-400 text-sm">Please try again later or contact support</p>
                                        </div>
                                    </c:if>
                                </div>
                            </div>

                            <!-- Guide Selection -->
                            <div class="mb-8" id="guideSection">
                                <div class="flex justify-between items-center mb-4">
                                    <h2 class="text-xl font-semibold text-gray-900">Select a Guide</h2>
                                    <span class="text-sm text-gray-500">(Optional)</span>
                                </div>

                                <!-- Guides Container -->
                                <div id="availableGuides" class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <c:forEach var="guide" items="${guides}">
                                        <div class="selection-card bg-white border border-gray-200 rounded-lg p-4 cursor-pointer guide-option"
                                             data-guide-id="${guide.guideId}"
                                             data-daily-rate="${guide.dailyRate}"
                                             onclick="selectGuide('${guide.guideId}', ${guide.dailyRate}, this)">
                                            <div class="flex justify-between items-start mb-2">
                                                <div>
                                                    <h3 class="font-semibold text-gray-900">${guide.name}</h3>
                                                    <p class="text-sm text-gray-600">ID: ${guide.guideId}</p>
                                                </div>
                                                <span class="bg-blue-100 text-blue-800 text-xs font-medium px-2 py-1 rounded">
                                                    ${guide.experienceYears}+ years
                                                </span>
                                            </div>

                                            <div class="space-y-1 text-sm text-gray-600 mb-3">
                                                <div class="flex items-center">
                                                    <i class="fas fa-phone-alt mr-2"></i>
                                                    <span>${guide.phoneNumber}</span>
                                                </div>
                                                <div class="flex items-center">
                                                    <i class="fas fa-language mr-2"></i>
                                                    <span>${guide.languages != null ? guide.languages : 'English'}</span>
                                                </div>
                                                <div class="flex items-center">
                                                    <i class="fas fa-star mr-2"></i>
                                                    <span>${guide.specialization != null ? guide.specialization : 'General Guide'}</span>
                                                </div>
                                            </div>

                                            <div class="flex justify-between items-center mt-3 pt-3 border-t border-gray-200">
                                                <span class="text-lg font-bold text-blue-600">
                                                    Rs. <fmt:formatNumber value="${guide.dailyRate}" pattern="#,##0.00"/>/day
                                                </span>
                                                <div class="flex items-center">
                                                    <div class="w-4 h-4 border-2 border-gray-300 rounded-full flex items-center justify-center mr-2 guide-radio">
                                                        <i class="fas fa-check text-white text-xs hidden"></i>
                                                    </div>
                                                    <span class="text-xs text-gray-600">Select</span>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                    <c:if test="${empty guides}">
                                        <div class="text-center py-8 border-2 border-dashed border-gray-300 rounded-lg">
                                            <i class="fas fa-user text-4xl text-gray-400 mb-4"></i>
                                            <p class="text-gray-500 text-lg mb-2">No guides available</p>
                                            <p class="text-gray-400 text-sm">Please try again later or contact support</p>
                                        </div>
                                    </c:if>
                                </div>
                            </div>

                            <!-- Insurance Selection -->
                            <div class="mb-8">
                                <h2 class="text-xl font-semibold text-gray-900 mb-4">Insurance Plans</h2>
                                <div class="space-y-4" id="insurancePlans">
                                    <c:forEach var="insurance" items="${insurancePlans}">
                                        <div class="selection-card bg-white border border-gray-200 rounded-lg p-4 hover:border-purple-600 transition duration-200 cursor-pointer insurance-option"
                                             data-insurance-id="${insurance.insuranceId}"
                                             data-daily-rate="${insurance.pricePerDayPerPerson}">
                                            <div class="flex items-start space-x-4">
                                                <input type="radio" name="insurancePlanId" value="${insurance.insuranceId}"
                                                       id="insurance_${insurance.insuranceId}" class="mt-1 insurance-radio">
                                                <div class="flex-1">
                                                    <div class="flex justify-between items-start mb-2">
                                                        <div>
                                                            <h3 class="font-semibold text-gray-900">${insurance.companyName} - ${insurance.coverageType}</h3>
                                                            <div class="flex items-center mt-1 space-x-2">
                                                                <span class="px-2 py-1 text-xs rounded-full ${insurance.insuranceType == 'foreign' ? 'bg-blue-100 text-blue-800' : 'bg-green-100 text-green-800'}">
                                                                        ${insurance.insuranceType}
                                                                </span>
                                                                <span class="text-sm text-gray-600">Max ${insurance.maxDays} days</span>
                                                            </div>
                                                        </div>
                                                        <div class="text-right">
                                                            <p class="text-lg font-bold text-purple-600">
                                                                Rs. <fmt:formatNumber value="${insurance.pricePerDayPerPerson}" pattern="#,##0.00"/>
                                                            </p>
                                                            <p class="text-sm text-gray-500">per day/person</p>
                                                        </div>
                                                    </div>
                                                    <c:if test="${not empty insurance.description}">
                                                        <p class="text-sm text-gray-600 mb-2">${insurance.description}</p>
                                                    </c:if>
                                                    <c:if test="${not empty insurance.specialFeatures}">
                                                        <p class="text-sm text-purple-600"><i class="fas fa-star mr-1"></i>${insurance.specialFeatures}</p>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                    <div class="selection-card bg-white border border-gray-200 rounded-lg p-4 hover:border-purple-600 transition duration-200 cursor-pointer insurance-option selected"
                                         data-insurance-id="" data-daily-rate="0">
                                        <div class="flex items-start space-x-4">
                                            <input type="radio" name="insurancePlanId" value="" id="noInsurance" checked class="mt-1 insurance-radio">
                                            <div class="flex-1">
                                                <h3 class="font-semibold text-gray-900">No Insurance</h3>
                                                <p class="text-sm text-gray-600">I don't need insurance coverage</p>
                                                <p class="text-lg font-bold text-gray-600 mt-2">Rs. 0</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Special Requirements -->
                            <div class="mb-8">
                                <label class="block text-sm font-medium text-gray-700 mb-2">Special Requirements</label>
                                <textarea name="specialRequirements" rows="4" placeholder="Any special requirements, dietary restrictions, accessibility needs, or additional notes..."
                                          class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-purple-600"></textarea>
                            </div>

                            <div class="flex justify-end">
                                <button type="submit"
                                        class="bg-purple-600 text-white px-8 py-3 rounded-lg hover:bg-purple-700 transition duration-200 font-semibold text-lg">
                                    <i class="fas fa-lock mr-2"></i>Confirm Booking
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Right Column - Price Summary & Actions -->
            <div class="lg:col-span-1">
                <div class="sticky top-8">
                    <!-- Tour Summary -->
                    <div class="bg-white rounded-xl shadow-lg overflow-hidden mb-6">
                        <div class="p-6 border-b border-gray-200">
                            <h3 class="text-lg font-semibold text-gray-900">Tour Summary</h3>
                        </div>
                        <div class="p-6">
                            <div class="flex items-center space-x-4 mb-4">
                                <c:choose>
                                    <c:when test="${not empty tour.tourPhotoData}">
                                        <img src="${pageContext.request.contextPath}/tours/photo/${tour.tourId}"
                                             alt="${tour.tourName}"
                                             class="w-16 h-16 object-cover rounded-lg">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="w-16 h-16 bg-gray-200 rounded-lg flex items-center justify-center">
                                            <i class="fas fa-mountain text-gray-400"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                <div>
                                    <h4 class="font-semibold text-gray-900">${tour.tourName}</h4>
                                    <p class="text-sm text-gray-600">${tour.destination}</p>
                                    <p class="text-sm text-gray-600">${tour.durationDays} days</p>
                                </div>
                            </div>
                            <div class="space-y-2 text-sm text-gray-600">
                                <c:if test="${tour.includesBreakfast}">
                                    <div class="flex items-center">
                                        <i class="fas fa-check text-green-500 mr-2"></i>
                                        <span>Includes Breakfast</span>
                                    </div>
                                </c:if>
                                <c:if test="${tour.includesLunch}">
                                    <div class="flex items-center">
                                        <i class="fas fa-check text-green-500 mr-2"></i>
                                        <span>Includes Lunch</span>
                                    </div>
                                </c:if>
                                <c:if test="${tour.includesDinner}">
                                    <div class="flex items-center">
                                        <i class="fas fa-check text-green-500 mr-2"></i>
                                        <span>Includes Dinner</span>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <!-- Price Summary -->
                    <div class="bg-white rounded-xl shadow-lg overflow-hidden mb-6">
                        <div class="p-6 border-b border-gray-200">
                            <h3 class="text-lg font-semibold text-gray-900">Price Summary</h3>
                        </div>
                        <div class="p-6">
                            <div class="space-y-3">
                                <div class="flex justify-between text-gray-600">
                                    <span>Adults (<span id="summaryAdults">1</span> persons)</span>
                                    <span>Rs. <span id="adultsPrice">0.00</span></span>
                                </div>
                                <div class="flex justify-between text-green-600">
                                    <span>Children (<span id="summaryChildren">0</span> persons)</span>
                                    <span>Rs. <span id="childrenPrice">0.00</span></span>
                                </div>
                                <div class="flex justify-between text-blue-600">
                                    <span>Students (<span id="summaryStudents">0</span> persons)</span>
                                    <span>Rs. <span id="studentsPrice">0.00</span></span>
                                </div>
                                <div class="flex justify-between text-gray-600 border-t pt-2">
                                    <span>Tour Subtotal</span>
                                    <span>Rs. <span id="tourSubtotal">0.00</span></span>
                                </div>
                                <div class="flex justify-between text-gray-600">
                                    <span>Vehicle Cost</span>
                                    <span>Rs. <span id="vehicleCost">0.00</span></span>
                                </div>
                                <div class="flex justify-between text-gray-600">
                                    <span>Guide Cost</span>
                                    <span>Rs. <span id="guideCost">0.00</span></span>
                                </div>
                                <div class="flex justify-between text-gray-600">
                                    <span>Insurance</span>
                                    <span>Rs. <span id="insuranceCost">0.00</span></span>
                                </div>
                                <div class="border-t pt-3 mt-2">
                                    <div class="flex justify-between text-lg font-bold text-gray-900">
                                        <span>Total Amount</span>
                                        <span>Rs. <span id="totalAmount"><fmt:formatNumber value="${tour.price}" pattern="#,##0.00"/></span></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="bg-white rounded-xl shadow-lg overflow-hidden">
                        <div class="p-6">
                            <div class="space-y-3">
                                <a href="${pageContext.request.contextPath}/tours/${tour.tourId}"
                                   class="w-full flex items-center justify-center px-4 py-3 border border-gray-300 text-gray-700 font-semibold rounded-lg hover:bg-gray-50 transition duration-200">
                                    <i class="fas fa-arrow-left mr-2"></i> Back to Tour
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../Footer.jsp" %>

<script>
    // Global variables - FIXED: Remove commas from formatted numbers
    let basePrice = parseFloat('${tour.price}'.replace(/,/g, ''));
    let selectedVehicles = new Set();
    let selectedGuide = null;
    let selectedInsuranceId = '';

    // Store daily rates in a separate object for reliable access
    let vehicleDailyRates = {};
    let guideDailyRates = {};

    console.log("=== INITIALIZATION ===");
    console.log("Base Price (raw):", '${tour.price}');
    console.log("Base Price (parsed):", basePrice);

    document.addEventListener('DOMContentLoaded', function() {
        const tripDateInput = document.getElementById('tripDate');
        const durationInput = document.getElementById('durationDays');

        // Initialize daily rate mappings
        initializeDailyRates();

        // Set minimum date to tomorrow
        const tomorrow = new Date();
        tomorrow.setDate(tomorrow.getDate() + 1);
        tripDateInput.min = tomorrow.toISOString().split('T')[0];

        // Set default date to tomorrow if not set
        if (!tripDateInput.value) {
            tripDateInput.value = tomorrow.toISOString().split('T')[0];
        }

        // Event listeners
        tripDateInput.addEventListener('change', updatePriceSummary);
        durationInput.addEventListener('change', updatePriceSummary);

        // Insurance selection
        document.querySelectorAll('.insurance-option').forEach(option => {
            option.addEventListener('click', function() {
                document.querySelectorAll('.insurance-option').forEach(opt => opt.classList.remove('selected'));
                this.classList.add('selected');
                const radio = this.querySelector('.insurance-radio');
                radio.checked = true;
                selectedInsuranceId = this.dataset.insuranceId || '';
                updatePriceSummary();
            });
        });

        // Form submission debugging
        document.getElementById('bookingForm').addEventListener('submit', function(e) {
            debugFormData();

            // Ensure hidden fields are properly set before submission
            document.getElementById('selectedGuideIdInput').value = selectedGuide || '';
            document.getElementById('selectedVehiclesInput').value = Array.from(selectedVehicles).join(',');

            console.log("=== FINAL FORM DATA BEFORE SUBMISSION ===");
            console.log("Selected Guide ID:", document.getElementById('selectedGuideIdInput').value);
            console.log("Selected Vehicles:", document.getElementById('selectedVehiclesInput').value);
            console.log("Insurance Plan ID:", document.getElementById('insurancePlanIdInput').value);
        });

        // Initial price calculation
        updatePriceSummary();
    });

    function initializeDailyRates() {
        // Initialize vehicle daily rates
        document.querySelectorAll('.vehicle-option').forEach(vehicle => {
            const vehicleId = vehicle.dataset.vehicleId;
            const dailyRate = parseFloat(vehicle.dataset.dailyRate) || 0;
            vehicleDailyRates[vehicleId] = dailyRate;
            console.log(`Vehicle ${vehicleId} daily rate: ${dailyRate}`);
        });

        // Initialize guide daily rates
        document.querySelectorAll('.guide-option').forEach(guide => {
            const guideId = guide.dataset.guideId;
            const dailyRate = parseFloat(guide.dataset.dailyRate) || 0;
            guideDailyRates[guideId] = dailyRate;
            console.log(`Guide ${guideId} daily rate: ${dailyRate}`);
        });

        console.log("Vehicle Daily Rates:", vehicleDailyRates);
        console.log("Guide Daily Rates:", guideDailyRates);
    }

    // Person count functions
    function changeAdultCount(change) {
        const input = document.getElementById('numberOfAdults');
        let value = parseInt(input.value) + change;
        if (value >= 0 && value <= 50) {
            input.value = value;
            updateTotalPersons();
        }
    }

    function changeChildCount(change) {
        const input = document.getElementById('numberOfChildren');
        let value = parseInt(input.value) + change;
        if (value >= 0 && value <= 50) {
            input.value = value;
            updateTotalPersons();
        }
    }

    function changeStudentCount(change) {
        const input = document.getElementById('numberOfStudents');
        let value = parseInt(input.value) + change;
        if (value >= 0 && value <= 50) {
            input.value = value;
            updateTotalPersons();
        }
    }

    function updateTotalPersons() {
        const adults = parseInt(document.getElementById('numberOfAdults').value) || 0;
        const children = parseInt(document.getElementById('numberOfChildren').value) || 0;
        const students = parseInt(document.getElementById('numberOfStudents').value) || 0;

        const totalPersons = adults + children + students;

        // Update total persons field
        document.getElementById('numberOfPersons').value = totalPersons;

        // Update summary display
        document.getElementById('adultsSummary').textContent = adults;
        document.getElementById('childrenSummary').textContent = children;
        document.getElementById('studentsSummary').textContent = students;
        document.getElementById('totalPersonsSummary').textContent = totalPersons;

        // Update price summary
        updatePriceSummary();
    }

    function toggleVehicleSelection(vehicleId, dailyRate, element) {
        console.log(`Toggling vehicle: ${vehicleId}, Daily Rate: ${dailyRate}`);

        const checkbox = element.querySelector('.vehicle-checkbox');
        const checkIcon = checkbox.querySelector('i');

        if (selectedVehicles.has(vehicleId)) {
            selectedVehicles.delete(vehicleId);
            element.classList.remove('selected');
            checkbox.classList.remove('bg-purple-600', 'border-purple-600');
            checkbox.classList.add('border-gray-300');
            checkIcon.classList.add('hidden');
            console.log(`Removed vehicle: ${vehicleId}`);
        } else {
            selectedVehicles.add(vehicleId);
            element.classList.add('selected');
            checkbox.classList.remove('border-gray-300');
            checkbox.classList.add('bg-purple-600', 'border-purple-600');
            checkIcon.classList.remove('hidden');
            console.log(`Added vehicle: ${vehicleId}`);
        }
        updatePriceSummary();
    }

    function selectGuide(guideId, dailyRate, element) {
        console.log(`Selecting guide: ${guideId}, Daily Rate: ${dailyRate}`);

        // Remove selection from all guides
        document.querySelectorAll('.guide-option').forEach(card => {
            card.classList.remove('selected');
            const radio = card.querySelector('.guide-radio');
            const checkIcon = radio.querySelector('i');
            radio.classList.remove('bg-purple-600', 'border-purple-600');
            radio.classList.add('border-gray-300');
            checkIcon.classList.add('hidden');
        });

        // Add selection to clicked guide
        element.classList.add('selected');
        const radio = element.querySelector('.guide-radio');
        const checkIcon = radio.querySelector('i');
        radio.classList.remove('border-gray-300');
        radio.classList.add('bg-purple-600', 'border-purple-600');
        checkIcon.classList.remove('hidden');

        selectedGuide = guideId;
        console.log("Guide selected and stored:", selectedGuide);

        // Immediately update the hidden field
        document.getElementById('selectedGuideIdInput').value = selectedGuide;
        console.log("Hidden field updated to:", document.getElementById('selectedGuideIdInput').value);

        updatePriceSummary();
    }

    function updatePriceSummary() {
        const adults = parseInt(document.getElementById('numberOfAdults').value) || 0;
        const children = parseInt(document.getElementById('numberOfChildren').value) || 0;
        const students = parseInt(document.getElementById('numberOfStudents').value) || 0;
        const totalPersons = adults + children + students;
        const duration = parseInt(document.getElementById('durationDays').value) || 1;

        console.log("=== PRICE CALCULATION START ===");
        console.log("Adults:", adults, "Children:", children, "Students:", students, "Total Persons:", totalPersons);
        console.log("Duration:", duration);
        console.log("Base Price:", basePrice);
        console.log("Selected Vehicles:", Array.from(selectedVehicles));
        console.log("Selected Guide:", selectedGuide);

        // Calculate tour prices for each category
        const adultsPrice = adults * basePrice;
        const childrenPrice = children * basePrice * 0.5; // 50% discount
        const studentsPrice = students * basePrice * 0.8; // 20% discount
        const tourSubtotal = adultsPrice + childrenPrice + studentsPrice;

        console.log("Adults Price:", adultsPrice);
        console.log("Children Price:", childrenPrice);
        console.log("Students Price:", studentsPrice);
        console.log("Tour Subtotal:", tourSubtotal);

        // Calculate vehicle cost
        let vehicleCost = 0;
        selectedVehicles.forEach(vehicleId => {
            const dailyRate = vehicleDailyRates[vehicleId] || 0;
            vehicleCost += dailyRate * duration;
            console.log(`Vehicle ${vehicleId}: ${dailyRate} * ${duration} = ${dailyRate * duration}`);
        });

        // Calculate guide cost
        let guideCost = 0;
        if (selectedGuide) {
            const dailyRate = guideDailyRates[selectedGuide] || 0;
            guideCost = dailyRate * duration;
            console.log(`Guide ${selectedGuide}: ${dailyRate} * ${duration} = ${guideCost}`);
        }

        // Calculate insurance cost
        let insuranceCost = 0;
        const selectedInsurance = document.querySelector('.insurance-option.selected');
        if (selectedInsurance) {
            const dailyRate = parseFloat(selectedInsurance.dataset.dailyRate) || 0;
            insuranceCost = dailyRate * totalPersons * duration;
            selectedInsuranceId = selectedInsurance.dataset.insuranceId || '';
            console.log(`Insurance: ${dailyRate} * ${totalPersons} * ${duration} = ${insuranceCost}`);
        }

        // Calculate total
        const totalAmount = tourSubtotal + vehicleCost + guideCost + insuranceCost;

        console.log("=== FINAL CALCULATIONS ===");
        console.log("Tour Subtotal:", tourSubtotal);
        console.log("Vehicle Cost:", vehicleCost);
        console.log("Guide Cost:", guideCost);
        console.log("Insurance Cost:", insuranceCost);
        console.log("Total Amount:", totalAmount);

        // Update UI
        document.getElementById('summaryAdults').textContent = adults;
        document.getElementById('summaryChildren').textContent = children;
        document.getElementById('summaryStudents').textContent = students;
        document.getElementById('adultsPrice').textContent = adultsPrice.toFixed(2);
        document.getElementById('childrenPrice').textContent = childrenPrice.toFixed(2);
        document.getElementById('studentsPrice').textContent = studentsPrice.toFixed(2);
        document.getElementById('tourSubtotal').textContent = tourSubtotal.toFixed(2);
        document.getElementById('vehicleCost').textContent = vehicleCost.toFixed(2);
        document.getElementById('guideCost').textContent = guideCost.toFixed(2);
        document.getElementById('insuranceCost').textContent = insuranceCost.toFixed(2);
        document.getElementById('totalAmount').textContent = totalAmount.toFixed(2);

        // Update hidden fields
        document.getElementById('selectedVehiclesInput').value = Array.from(selectedVehicles).join(',');
        document.getElementById('selectedGuideIdInput').value = selectedGuide || '';
        document.getElementById('insurancePlanIdInput').value = selectedInsuranceId || '';
        document.getElementById('totalAmountHidden').value = totalAmount;

        console.log("=== UI UPDATED ===");
        console.log("Adults Price Display:", document.getElementById('adultsPrice').textContent);
        console.log("Children Price Display:", document.getElementById('childrenPrice').textContent);
        console.log("Students Price Display:", document.getElementById('studentsPrice').textContent);
        console.log("Tour Subtotal Display:", document.getElementById('tourSubtotal').textContent);
        console.log("Vehicle Cost Display:", document.getElementById('vehicleCost').textContent);
        console.log("Guide Cost Display:", document.getElementById('guideCost').textContent);
        console.log("Insurance Cost Display:", document.getElementById('insuranceCost').textContent);
        console.log("Total Amount Display:", document.getElementById('totalAmount').textContent);
    }

    // Debug function to check form data
    function debugFormData() {
        console.log("=== FORM DATA DEBUG ===");
        console.log("Tour ID:", document.querySelector('input[name="tourId"]').value);
        console.log("Selected Guide ID:", document.getElementById('selectedGuideIdInput').value);
        console.log("Selected Vehicles:", document.getElementById('selectedVehiclesInput').value);
        console.log("Insurance Plan ID:", document.getElementById('insurancePlanIdInput').value);
        console.log("Total Amount:", document.getElementById('totalAmountHidden').value);
        console.log("Adults:", document.getElementById('numberOfAdults').value);
        console.log("Children:", document.getElementById('numberOfChildren').value);
        console.log("Students:", document.getElementById('numberOfStudents').value);
        console.log("Total Persons:", document.getElementById('numberOfPersons').value);

        // Check if guide is selected in our JavaScript state
        console.log("JavaScript selectedGuide:", selectedGuide);
        console.log("JavaScript selectedVehicles:", Array.from(selectedVehicles));
    }

    // Debug function to check if vehicles and guides are loaded
    function debugData() {
        console.log('Vehicles:', document.querySelectorAll('.vehicle-option').length);
        console.log('Guides:', document.querySelectorAll('.guide-option').length);
        console.log('Insurance:', document.querySelectorAll('.insurance-option').length);
        console.log('Selected vehicles:', Array.from(selectedVehicles));
        console.log('Selected guide:', selectedGuide);
        console.log('Selected insurance:', selectedInsuranceId);

        // Debug data attributes
        document.querySelectorAll('.vehicle-option').forEach((vehicle, index) => {
            console.log(`Vehicle ${index}:`, {
                id: vehicle.dataset.vehicleId,
                dailyRate: vehicle.dataset.dailyRate,
                element: vehicle
            });
        });

        document.querySelectorAll('.guide-option').forEach((guide, index) => {
            console.log(`Guide ${index}:`, {
                id: guide.dataset.guideId,
                dailyRate: guide.dataset.dailyRate,
                element: guide
            });
        });
    }

    // Call debug on load
    window.addEventListener('load', debugData);
</script>
</body>
</html>
