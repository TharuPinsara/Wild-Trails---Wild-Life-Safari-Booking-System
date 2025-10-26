<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WildTrails Sri Lanka - Login</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .bg-login {
            background-image: url('/images/login.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }

        /* Make the entire page background the image */
        body {
            background-image: url('/images/login.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
            margin: 0;
            padding: 0;
        }

        .login-form-container {
            background-color: rgba(255, 255, 255, 0.6); /* Very transparent */
            backdrop-filter: blur(8px); /* Blur effect for readability */
            border: 1px solid rgba(255, 255, 255, 0.2); /* Subtle border */
        }

        /* Ensure form elements are readable */
        .login-form-container * {
            color: #1a202c; /* Dark text for contrast */
        }

        .login-form-container input {
            background-color: rgba(255, 255, 255, 0.8); /* Slightly opaque inputs */
        }

        @media (max-width: 768px) {
            body {
                background-position: left center;
            }
            .login-form-container {
                background-color: rgba(255, 255, 255, 0.15); /* Slightly more opaque on mobile */
            }
        }
    </style>
</head>
<body class="min-h-screen flex items-center justify-center p-4">
<!-- Check if user is already logged in -->
<c:if test="${not empty sessionScope.userLoggedIn}">
    <script>
        window.location.href = "${pageContext.request.contextPath}/homepage/index.html";
    </script>
</c:if>

<!-- Single container approach - form centered on background -->
<div class="login-form-container max-w-md w-full rounded-xl shadow-2xl p-8">
    <!-- Logo -->
    <div class="text-center mb-8">
        <img src="/images/logo.png" alt="WildTrails Logo" class="h-20 mx-auto mb-4">
        <h1 class="text-3xl font-bold text-green-800">WildTrails Sri Lanka</h1>
        <p class="text-gray-800 mt-2 font-medium">Login to your wildlife safari account</p>
    </div>

    <form action="/userlogin/login" method="post">
        <div class="mb-4">
            <label for="email" class="block text-gray-800 text-sm font-bold mb-2">Email Address</label>
            <input type="email" id="email" name="email"
                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200"
                   placeholder="Enter your email"
                   required>
        </div>

        <div class="mb-6">
            <label for="password" class="block text-gray-800 text-sm font-bold mb-2">Password</label>
            <input type="password" id="password" name="password"
                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition duration-200"
                   placeholder="Enter your password"
                   required>
        </div>

        <button type="submit"
                class="w-full bg-green-600 text-white py-3 px-4 rounded-lg hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-2 transition duration-200 font-semibold shadow-md">
            Sign In to Your Account
        </button>
    </form>

    <div class="mt-6 text-center">
        <p class="text-gray-800 font-medium">New to WildTrails?
            <a href="/userlogin/register" class="text-green-700 hover:text-green-800 font-bold transition duration-200">
                Create an account
            </a>
        </p>
    </div>

    <!-- Messages -->
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
</body>
</html>