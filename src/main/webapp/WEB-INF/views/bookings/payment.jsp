<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment - WildTrails</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .payment-method {
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }
        .payment-method.selected {
            border-color: #8b5cf6;
            box-shadow: 0 10px 25px -5px rgba(139, 92, 246, 0.2);
        }
        .payment-method:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1);
        }
        .card-input {
            transition: all 0.3s ease;
        }
        .card-input:focus {
            box-shadow: 0 0 0 3px rgba(139, 92, 246, 0.1);
        }
    </style>
</head>
<body class="bg-gray-50 flex flex-col min-h-screen">
<%@ include file="../Header.jsp" %>

<div class="flex-grow py-8">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <!-- Breadcrumb -->
        <nav class="flex mb-8" aria-label="Breadcrumb">
            <ol class="flex items-center space-x-2">
                <li><a href="${pageContext.request.contextPath}/tours" class="text-gray-500 hover:text-gray-700">Tours</a></li>
                <li><span class="text-gray-400 mx-2">/</span></li>
                <li><a href="${pageContext.request.contextPath}/tours/${tour.tourId}" class="text-gray-500 hover:text-gray-700">${tour.tourName}</a></li>
                <li><span class="text-gray-400 mx-2">/</span></li>
                <li><a href="${pageContext.request.contextPath}/bookings/new?tourId=${tour.tourId}" class="text-gray-500 hover:text-gray-700">Booking</a></li>
                <li><span class="text-gray-400 mx-2">/</span></li>
                <li class="text-gray-900 font-medium">Payment</li>
            </ol>
        </nav>

        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="mb-6 bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded">
                <i class="fas fa-exclamation-triangle mr-2"></i>${error}
            </div>
        </c:if>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            <!-- Left Column - Payment Form -->
            <div class="lg:col-span-2">
                <div class="bg-white rounded-xl shadow-lg overflow-hidden">
                    <div class="p-8">
                        <h1 class="text-3xl font-bold text-gray-900 mb-2">Complete Your Payment</h1>
                        <p class="text-gray-600 mb-8">Choose your preferred payment method to confirm your booking</p>

                        <form id="paymentForm" action="${pageContext.request.contextPath}/bookings/process-payment" method="post">
                            <input type="hidden" name="bookingId" value="${booking.bookingId}">
                            <input type="hidden" name="totalAmount" value="${booking.totalAmount}">

                            <!-- Payment Method Selection -->
                            <div class="mb-8">
                                <h2 class="text-xl font-semibold text-gray-900 mb-4">Select Payment Method</h2>
                                <div class="space-y-4">
                                    <!-- Credit/Debit Card -->
                                    <div class="payment-method bg-white border border-gray-200 rounded-lg p-6 cursor-pointer selected"
                                         data-method="card" onclick="selectPaymentMethod('card')">
                                        <div class="flex items-center justify-between">
                                            <div class="flex items-center space-x-4">
                                                <div class="w-12 h-8 bg-gradient-to-r from-purple-500 to-pink-500 rounded flex items-center justify-center">
                                                    <i class="fas fa-credit-card text-white text-sm"></i>
                                                </div>
                                                <div>
                                                    <h3 class="font-semibold text-gray-900">Credit/Debit Card</h3>
                                                    <p class="text-sm text-gray-600">Pay securely with your card</p>
                                                </div>
                                            </div>
                                            <div class="w-6 h-6 rounded-full border-2 border-purple-600 flex items-center justify-center">
                                                <div class="w-3 h-3 rounded-full bg-purple-600"></div>
                                            </div>
                                        </div>

                                        <!-- Card Details Form -->
                                        <div id="cardDetails" class="mt-6 space-y-4">
                                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                                <div>
                                                    <label class="block text-sm font-medium text-gray-700 mb-2">Card Number</label>
                                                    <input type="text" name="cardNumber" placeholder="1234 5678 9012 3456" maxlength="19"
                                                           class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-purple-600 card-input"
                                                           oninput="formatCardNumber(this)">
                                                </div>
                                                <div>
                                                    <label class="block text-sm font-medium text-gray-700 mb-2">Card Holder Name</label>
                                                    <input type="text" name="cardHolder" placeholder="John Doe"
                                                           class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-purple-600 card-input">
                                                </div>
                                            </div>
                                            <div class="grid grid-cols-2 gap-4">
                                                <div>
                                                    <label class="block text-sm font-medium text-gray-700 mb-2">Expiry Date</label>
                                                    <input type="text" name="expiryDate" placeholder="MM/YY" maxlength="5"
                                                           class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-purple-600 card-input"
                                                           oninput="formatExpiryDate(this)">
                                                </div>
                                                <div>
                                                    <label class="block text-sm font-medium text-gray-700 mb-2">CVV</label>
                                                    <input type="text" name="cvv" placeholder="123" maxlength="3"
                                                           class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-purple-600 card-input">
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Cash on Delivery -->
                                    <div class="payment-method bg-white border border-gray-200 rounded-lg p-6 cursor-pointer"
                                         data-method="cod" onclick="selectPaymentMethod('cod')">
                                        <div class="flex items-center justify-between">
                                            <div class="flex items-center space-x-4">
                                                <div class="w-12 h-8 bg-green-500 rounded flex items-center justify-center">
                                                    <i class="fas fa-money-bill-wave text-white text-sm"></i>
                                                </div>
                                                <div>
                                                    <h3 class="font-semibold text-gray-900">Cash on Delivery</h3>
                                                    <p class="text-sm text-gray-600">Pay when you receive the service</p>
                                                </div>
                                            </div>
                                            <div class="w-6 h-6 rounded-full border-2 border-gray-300 flex items-center justify-center">
                                                <div class="w-3 h-3 rounded-full bg-transparent"></div>
                                            </div>
                                        </div>

                                        <!-- COD Message -->
                                        <div id="codMessage" class="mt-4 hidden">
                                            <div class="bg-green-50 border border-green-200 rounded-lg p-4">
                                                <div class="flex items-center">
                                                    <i class="fas fa-info-circle text-green-500 mr-2"></i>
                                                    <p class="text-sm text-green-700">
                                                        You can pay in cash when you meet our guide at the tour starting point.
                                                    </p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <input type="hidden" name="paymentMethod" id="paymentMethod" value="card">

                            <div class="flex justify-between items-center pt-6 border-t border-gray-200">
                                <a href="${pageContext.request.contextPath}/bookings/new?tourId=${tour.tourId}"
                                   class="text-purple-600 hover:text-purple-700 font-semibold flex items-center">
                                    <i class="fas fa-arrow-left mr-2"></i> Back to Booking
                                </a>
                                <button type="submit"
                                        class="bg-purple-600 text-white px-8 py-3 rounded-lg hover:bg-purple-700 transition duration-200 font-semibold text-lg">
                                    <i class="fas fa-lock mr-2"></i>Complete Payment
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Right Column - Order Summary -->
            <div class="lg:col-span-1">
                <div class="sticky top-8">
                    <!-- Booking Summary -->
                    <div class="bg-white rounded-xl shadow-lg overflow-hidden mb-6">
                        <div class="p-6 border-b border-gray-200">
                            <h3 class="text-lg font-semibold text-gray-900">Booking Summary</h3>
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
                                </div>
                            </div>
                            <div class="space-y-2 text-sm text-gray-600">
                                <div class="flex justify-between">
                                    <span>Booking ID:</span>
                                    <span class="font-mono">${booking.bookingId}</span>
                                </div>
                                <div class="flex justify-between">
                                    <span>Trip Date:</span>
                                    <!-- FIXED: Use LocalDate directly without fmt:formatDate -->
                                    <span>${booking.tripDate}</span>
                                </div>
                                <div class="flex justify-between">
                                    <span>Duration:</span>
                                    <span>${booking.durationDays} days</span>
                                </div>
                                <div class="flex justify-between">
                                    <span>Persons:</span>
                                    <span>${booking.numberOfPersons}</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Price Summary -->
                    <div class="bg-white rounded-xl shadow-lg overflow-hidden">
                        <div class="p-6 border-b border-gray-200">
                            <h3 class="text-lg font-semibold text-gray-900">Payment Summary</h3>
                        </div>
                        <div class="p-6">
                            <div class="space-y-3">
                                <div class="flex justify-between text-gray-600">
                                    <span>Tour Price</span>
                                    <span>Rs. <fmt:formatNumber value="${tour.price * booking.numberOfPersons}" pattern="#,##0.00"/></span>
                                </div>
                                <c:if test="${not empty booking.selectedVehicles}">
                                    <div class="flex justify-between text-gray-600">
                                        <span>Vehicle Cost</span>
                                        <span>Rs. <fmt:formatNumber value="${vehicleCost}" pattern="#,##0.00"/></span>
                                    </div>
                                </c:if>
                                <c:if test="${not empty booking.selectedGuideId}">
                                    <div class="flex justify-between text-gray-600">
                                        <span>Guide Cost</span>
                                        <span>Rs. <fmt:formatNumber value="${guideCost}" pattern="#,##0.00"/></span>
                                    </div>
                                </c:if>
                                <c:if test="${not empty booking.insurancePlan}">
                                    <div class="flex justify-between text-gray-600">
                                        <span>Insurance</span>
                                        <span>Rs. <fmt:formatNumber value="${insuranceCost}" pattern="#,##0.00"/></span>
                                    </div>
                                </c:if>
                                <div class="border-t pt-3 mt-2">
                                    <div class="flex justify-between text-lg font-bold text-gray-900">
                                        <span>Total Amount</span>
                                        <span>Rs. <fmt:formatNumber value="${booking.totalAmount}" pattern="#,##0.00"/></span>
                                    </div>
                                </div>
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
    let selectedPaymentMethod = 'card';

    function selectPaymentMethod(method) {
        selectedPaymentMethod = method;
        document.getElementById('paymentMethod').value = method;

        // Update UI for selected method
        document.querySelectorAll('.payment-method').forEach(pm => {
            const radio = pm.querySelector('.w-6');
            const dot = pm.querySelector('.w-3');

            if (pm.dataset.method === method) {
                pm.classList.add('selected');
                radio.classList.remove('border-gray-300');
                radio.classList.add('border-purple-600');
                dot.classList.remove('bg-transparent');
                dot.classList.add('bg-purple-600');
            } else {
                pm.classList.remove('selected');
                radio.classList.remove('border-purple-600');
                radio.classList.add('border-gray-300');
                dot.classList.remove('bg-purple-600');
                dot.classList.add('bg-transparent');
            }
        });

        // Show/hide card details and COD message
        const cardDetails = document.getElementById('cardDetails');
        const codMessage = document.getElementById('codMessage');

        if (method === 'card') {
            cardDetails.style.display = 'block';
            codMessage.classList.add('hidden');
        } else {
            cardDetails.style.display = 'none';
            codMessage.classList.remove('hidden');
        }
    }

    function formatCardNumber(input) {
        // Remove all non-digit characters
        let value = input.value.replace(/\D/g, '');

        // Add space after every 4 digits
        value = value.replace(/(\d{4})(?=\d)/g, '$1 ');

        // Limit to 16 digits + 3 spaces = 19 characters
        if (value.length > 19) {
            value = value.substring(0, 19);
        }

        input.value = value;
    }

    function formatExpiryDate(input) {
        let value = input.value.replace(/\D/g, '');

        if (value.length >= 2) {
            value = value.substring(0, 2) + '/' + value.substring(2, 4);
        }

        if (value.length > 5) {
            value = value.substring(0, 5);
        }

        input.value = value;
    }

    // Form submission
    document.getElementById('paymentForm').addEventListener('submit', function(e) {
        e.preventDefault();

        if (selectedPaymentMethod === 'card') {
            // Basic validation for card payment
            const cardNumber = document.querySelector('input[name="cardNumber"]').value.replace(/\s/g, '');
            const cardHolder = document.querySelector('input[name="cardHolder"]').value.trim();
            const expiryDate = document.querySelector('input[name="expiryDate"]').value;
            const cvv = document.querySelector('input[name="cvv"]').value;

            if (!cardNumber || cardNumber.length !== 16) {
                alert('Please enter a valid 16-digit card number');
                return;
            }

            if (!cardHolder) {
                alert('Please enter card holder name');
                return;
            }

            if (!expiryDate || expiryDate.length !== 5) {
                alert('Please enter a valid expiry date (MM/YY)');
                return;
            }

            if (!cvv || cvv.length !== 3) {
                alert('Please enter a valid 3-digit CVV');
                return;
            }

            // Simulate payment processing
            showPaymentProcessing();
        }

        // For demo purposes, we'll submit the form after a short delay
        setTimeout(() => {
            this.submit();
        }, 2000);
    });

    function showPaymentProcessing() {
        // You could show a loading spinner here
        console.log('Processing payment...');
    }

    // Initialize on page load
    document.addEventListener('DOMContentLoaded', function() {
        selectPaymentMethod('card');
    });
</script>
</body>
</html>
