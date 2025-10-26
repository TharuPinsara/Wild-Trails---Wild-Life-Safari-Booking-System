<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WildTrails Sri Lanka - Register</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            background-image: url('/images/login.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
            margin: 0;
            padding: 0;
        }

        .form-container {
            background-color: rgba(255, 255, 255, 0.6);
            backdrop-filter: blur(8px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .form-container * {
            color: #1a202c;
        }

        .form-container input,
        .form-container select {
            background-color: rgba(255, 255, 255, 0.8);
        }

        @media (max-width: 768px) {
            body {
                background-position: left center;
            }
            .form-container {
                background-color: rgba(255, 255, 255, 0.7);
            }
        }
    </style>
</head>
<body class="min-h-screen flex items-center justify-center p-4">
<div class="form-container w-full max-w-4xl rounded-xl shadow-2xl p-8">
    <!-- Header with Logo -->
    <div class="text-center mb-8">
        <img src="/images/logo.png" alt="WildTrails Logo" class="h-20 mx-auto mb-4">
        <h1 class="text-3xl font-bold text-green-800">WildTrails Sri Lanka</h1>
        <p class="text-gray-800 mt-2 font-medium">Create your account to explore Sri Lanka's wild beauty</p>
    </div>

    <!-- Form Container - All fields visible without scrolling -->
    <div>
        <form action="/userlogin/register" method="post" class="space-y-6">
            <!-- Personal Information -->
            <div>
                <h2 class="text-xl font-semibold text-gray-800 mb-4 pb-2 border-b border-gray-300 flex items-center">
                    <svg class="w-5 h-5 mr-2 text-green-600" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" clip-rule="evenodd" />
                    </svg>
                    Personal Information
                </h2>
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                    <div class="lg:col-span-2">
                        <label for="firstName" class="block text-sm font-medium text-gray-700 mb-1">First Name *</label>
                        <input type="text" id="firstName" name="firstName" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200" required>
                    </div>
                    <div class="lg:col-span-2">
                        <label for="lastName" class="block text-sm font-medium text-gray-700 mb-1">Last Name *</label>
                        <input type="text" id="lastName" name="lastName" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200" required>
                    </div>
                    <div class="lg:col-span-2">
                        <label for="userType" class="block text-sm font-medium text-gray-700 mb-1">User Type *</label>
                        <select id="userType" name="userType" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200" required>
                            <option value="">Select Type</option>
                            <option value="Local">Local Tourist</option>
                            <option value="Foreign">Foreign Tourist</option>
                        </select>
                    </div>
                    <div class="lg:col-span-2">
                        <label for="phoneNumber" class="block text-sm font-medium text-gray-700 mb-1">Phone Number *</label>
                        <input type="tel" id="phoneNumber" name="phoneNumber" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200" required>
                    </div>
                </div>
            </div>

            <!-- Contact Information -->
            <div>
                <h2 class="text-xl font-semibold text-gray-800 mb-4 pb-2 border-b border-gray-300 flex items-center">
                    <svg class="w-5 h-5 mr-2 text-green-600" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M5.05 4.05a7 7 0 119.9 9.9L10 18.9l-4.95-4.95a7 7 0 010-9.9zM10 11a2 2 0 100-4 2 2 0 000 4z" clip-rule="evenodd" />
                    </svg>
                    Contact Information
                </h2>
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                    <div class="lg:col-span-4">
                        <label for="address" class="block text-sm font-medium text-gray-700 mb-1">Address *</label>
                        <input type="text" id="address" name="address" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200" required>
                    </div>
                    <div class="lg:col-span-2">
                        <label for="country" class="block text-sm font-medium text-gray-700 mb-1">Country *</label>
                        <input type="text" id="country" name="country" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200" required>
                    </div>
                    <div class="lg:col-span-2">
                        <label for="city" class="block text-sm font-medium text-gray-700 mb-1">City *</label>
                        <input type="text" id="city" name="city" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200" required>
                    </div>
                </div>
            </div>

            <!-- Login Credentials -->
            <div>
                <h2 class="text-xl font-semibold text-gray-800 mb-4 pb-2 border-b border-gray-300 flex items-center">
                    <svg class="w-5 h-5 mr-2 text-green-600" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd" />
                    </svg>
                    Login Credentials
                </h2>
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                    <div class="lg:col-span-4">
                        <label for="email" class="block text-sm font-medium text-gray-700 mb-1">Email *</label>
                        <input type="email" id="email" name="email" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200" required>
                    </div>
                    <div class="lg:col-span-2">
                        <label for="password" class="block text-sm font-medium text-gray-700 mb-1">Password *</label>
                        <input type="password" id="password" name="password" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200" required>
                    </div>
                    <div class="lg:col-span-2">
                        <label for="confirmPassword" class="block text-sm font-medium text-gray-700 mb-1">Confirm Password *</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200" required>
                    </div>
                </div>
            </div>

            <!-- Terms and Conditions -->
            <div class="flex items-start">
                <div class="flex items-center h-5">
                    <input id="terms" name="terms" type="checkbox" class="w-4 h-4 text-green-600 border-gray-300 rounded focus:ring-green-500" required>
                </div>
                <div class="ml-3 text-sm">
                    <label for="terms" class="font-medium text-gray-700">I agree to the <a href="#" class="text-green-600 hover:text-green-800">Terms and Conditions</a></label>
                </div>
            </div>

            <!-- Submit Button -->
            <button type="submit" class="w-full bg-green-600 text-white py-3 px-4 rounded-lg hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-2 transition duration-200 font-semibold shadow-md">
                Create Account
            </button>
        </form>

        <!-- Login Link -->
        <div class="mt-6 text-center">
            <p class="text-gray-800 font-medium">Already have an account?
                <a href="/userlogin/login" class="text-green-700 hover:text-green-800 font-bold transition duration-200">
                    Login here
                </a>
            </p>
        </div>

        <!-- Error Message -->
        <div id="error-message" class="mt-4 p-4 bg-red-100 border border-red-300 text-red-800 rounded-lg bg-opacity-90 hidden">
            <div class="flex items-center">
                <svg class="w-5 h-5 mr-2" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"/>
                </svg>
                <span id="error-text"></span>
            </div>
        </div>

        <!-- Server Error Message -->
        <% if (request.getAttribute("error") != null) { %>
        <div class="mt-4 p-4 bg-red-100 border border-red-300 text-red-800 rounded-lg bg-opacity-90">
            <div class="flex items-center">
                <svg class="w-5 h-5 mr-2" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"/>
                </svg>
                <span><%= request.getAttribute("error") %></span>
            </div>
        </div>
        <% } %>

        <!-- Server Success Message -->
        <% if (request.getAttribute("success") != null) { %>
        <div class="mt-4 p-4 bg-green-100 border border-green-300 text-green-800 rounded-lg bg-opacity-90">
            <div class="flex items-center">
                <svg class="w-5 h-5 mr-2" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
                </svg>
                <span><%= request.getAttribute("success") %></span>
            </div>
        </div>
        <% } %>
    </div>
</div>

<script>
    // Simple form validation
    document.querySelector('form').addEventListener('submit', function(e) {
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        const errorDiv = document.getElementById('error-message');
        const errorText = document.getElementById('error-text');

        // Clear previous error
        errorDiv.classList.add('hidden');

        // Check if passwords match
        if (password !== confirmPassword) {
            e.preventDefault();
            errorText.textContent = 'Passwords do not match!';
            errorDiv.classList.remove('hidden');

            // Scroll to error message
            errorDiv.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }

        // Check if terms are accepted
        const terms = document.getElementById('terms');
        if (!terms.checked) {
            e.preventDefault();
            errorText.textContent = 'Please accept the Terms and Conditions';
            errorDiv.classList.remove('hidden');
            terms.focus();
        }
    });

    // Add focus styles to inputs
    document.querySelectorAll('input, select').forEach(el => {
        el.addEventListener('focus', function() {
            this.classList.add('ring-2', 'ring-green-200');
        });

        el.addEventListener('blur', function() {
            this.classList.remove('ring-2', 'ring-green-200');
        });
    });
</script>
</body>
</html>