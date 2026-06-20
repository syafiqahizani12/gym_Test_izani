<%-- 
    Document   : register
    Created on : 7 Jun 2026, 1:11:57 pm
    Author     : ASUS
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Register | UniGym</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login_style.css">

    </head>

    <body>

        <div class="login-container">

            <!-- LEFT SIDE -->
            <div class="left-panel">
                <div class="overlay"></div>
                <div class="left-content">
                    <h1>Start Your Fitness Journey</h1>
                    <p>Create an account to access gym booking, attendance, and membership features.</p>
                </div>
            </div>

            <!-- RIGHT SIDE -->
            <div class="right-panel">
                <div class="login-box">

                    <h2>Create Account</h2>
                    <p class="subtitle">Register to join UniGym</p>

                    <c:if test="${param.error == 'duplicate'}"><div class="alert alert-danger">Email already exists. Please use another email.</div></c:if>
                    <c:if test="${param.error == 'validation'}"><div class="alert alert-danger">Complete all fields and use a password with at least six characters.</div></c:if>
                    <c:if test="${param.error == 'noplan'}"><div class="alert alert-danger">Select a membership plan before registering.</div></c:if>
                    <c:if test="${param.error == 'other'}"><div class="alert alert-danger">Registration could not be completed. Please try again.</div></c:if>

                    <!-- REGISTER FORM -->
                    <form action="${pageContext.request.contextPath}/register" method="POST" id="registerForm">
                        <input type="hidden" name="plan" id="selectedPlan" value="${param.plan}">
                        <input type="hidden" name="amount" id="selectedAmount" value="${param.amount}">

                        <!-- FULL NAME -->
                        <div class="input-group-custom">
                            <i class="fa-solid fa-user"></i>
                            <input type="text"
                                   name="fullName"
                                   placeholder="Full Name"
                                   required>
                        </div>

                        <!-- EMAIL -->
                        <div class="input-group-custom">
                            <i class="fa-solid fa-envelope"></i>
                            <input type="email"
                                   name="email"
                                   placeholder="Email"
                                   required>
                        </div>

                        <!-- PHONE -->
                        <div class="input-group-custom">
                            <i class="fa-solid fa-phone"></i>
                            <input type="text"
                                   name="phone"
                                   placeholder="Phone Number"
                                   required>
                        </div>

                        <!-- PASSWORD -->
                        <div class="input-group-custom">
                            <i class="fa-solid fa-lock"></i>
                            <input type="password"
                                   name="password"
                                   placeholder="Password"
                                   minlength="6"
                                   required>
                        </div>

                        <!-- PLAN SELECTION -->
                        <div class="mt-4 mb-3">
                            <label class="fw-bold form-section-label">Select Your Plan</label>

                            <!-- Basic Plan -->
                            <label class="plan-radio-label">
                                <input type="radio" name="planRadio" value="Basic" 
                                       class="plan-radio" 
                                       onclick="selectPlan('Basic', '39.00')"
                                       ${param.plan == 'Basic' ? 'checked' : ''}>
                                <div class="plan-selection-card">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <h4 class="mb-0">Basic</h4>
                                        <div class="price">RM39<span>/month</span></div>
                                    </div>
                                    <ul>
                                        <li>✅ Gym Access</li>
                                        <li>✅ Attendance Tracking</li>
                                        <li>✅ Locker Access</li>
                                    </ul>
                                </div>
                            </label>

                            <!-- Premium Plan -->
                            <label class="plan-radio-label">
                                <input type="radio" name="planRadio" value="Premium" 
                                       class="plan-radio" 
                                       onclick="selectPlan('Premium', '79.00')"
                                       ${param.plan == 'Premium' ? 'checked' : ''}>
                                <div class="plan-selection-card featured">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <h4 class="mb-0">
                                            Premium
                                            <span class="plan-badge popular">⭐ Popular</span>
                                        </h4>
                                        <div class="price">RM79<span>/month</span></div>
                                    </div>
                                    <ul>
                                        <li>✅ Unlimited Classes</li>
                                        <li>✅ Trainer Sessions</li>
                                        <li>✅ Priority Booking</li>
                                    </ul>
                                </div>
                            </label>

                            <!-- Elite Plan -->
                            <label class="plan-radio-label">
                                <input type="radio" name="planRadio" value="Elite" 
                                       class="plan-radio" 
                                       onclick="selectPlan('Elite', '129.00')"
                                       ${param.plan == 'Elite' ? 'checked' : ''}>
                                <div class="plan-selection-card">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <h4 class="mb-0">Elite</h4>
                                        <div class="price">RM129<span>/month</span></div>
                                    </div>
                                    <ul>
                                        <li>✅ VIP Lounge</li>
                                        <li>✅ Personal Trainer</li>
                                        <li>✅ Full Facility Access</li>
                                    </ul>
                                </div>
                            </label>
                        </div>

                        <!-- Error Message -->
                        <div id="planError" class="alert alert-danger">
                            Please select a membership plan.
                        </div>

                        <!-- BUTTON -->
                        <button type="submit" class="btn-login" onclick="return validatePlan()">Register</button>

                    </form>

                    <!-- BACK TO LOGIN -->
                    <div class="register-text">
                        Already have an account?
                        <a href="${pageContext.request.contextPath}/login.jsp">Login</a>
                    </div>

                </div>
            </div>

        </div>

        <!-- JavaScript for Plan Selection -->
        <script>
            function selectPlan(plan, amount) {
                document.getElementById('selectedPlan').value = plan;
                document.getElementById('selectedAmount').value = amount;
                document.getElementById('planError').classList.remove('visible');

                // Highlight selected card
                document.querySelectorAll('.plan-selection-card').forEach(card => {
                    card.classList.remove('selected');
                });
                const selectedCard = document.querySelector('input[name="planRadio"]:checked');
                if (selectedCard) {
                    selectedCard.closest('.plan-radio-label').querySelector('.plan-selection-card').classList.add('selected');
                }
            }

            function validatePlan() {
                const plan = document.getElementById('selectedPlan').value;
                if (!plan || plan === '') {
                    document.getElementById('planError').classList.add('visible');
                    document.getElementById('planError').textContent = 'Please select a membership plan before registering.';
                    return false;
                }
                return true;
            }

            // Auto-select if plan came from URL parameter
            document.addEventListener('DOMContentLoaded', function () {
                const planParam = '${param.plan}';
                const amountParam = '${param.amount}';

                if (planParam && amountParam) {
                    document.getElementById('selectedPlan').value = planParam;
                    document.getElementById('selectedAmount').value = amountParam;

                    // Auto-select the radio button
                    const radios = document.querySelectorAll('input[name="planRadio"]');
                    radios.forEach(radio => {
                        if (radio.value === planParam) {
                            radio.checked = true;
                            radio.closest('.plan-radio-label').querySelector('.plan-selection-card').classList.add('selected');
                        }
                    });
                }
            });
        </script>

    </body>
</html>
