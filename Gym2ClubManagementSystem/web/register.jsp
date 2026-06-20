<%-- 
    Document   : register
    Created on : 7 Jun 2026, 1:11:57 pm
    Author     : ASUS
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Register | UniGym</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
        <link rel="stylesheet" href="css/login_style.css">

        <style>
            .plan-selection-card {
                background: #1e293b;
                border-radius: 15px;
                padding: 20px;
                margin-bottom: 15px;
                border: 2px solid transparent;
                transition: all 0.3s ease;
                cursor: pointer;
                color: white;
            }
            .plan-selection-card:hover {
                border-color: #22c55e;
                transform: scale(1.02);
            }
            .plan-selection-card.selected {
                border-color: #22c55e;
                background: #2d3748;
            }
            .plan-selection-card .price {
                font-size: 24px;
                font-weight: bold;
                color: #22c55e;
            }
            .plan-selection-card .price span {
                font-size: 14px;
                color: #94a3b8;
            }
            .plan-selection-card ul {
                list-style: none;
                padding: 0;
                margin: 10px 0 0 0;
            }
            .plan-selection-card ul li {
                color: #cbd5e1;
                font-size: 14px;
                padding: 3px 0;
            }
            .plan-selection-card .plan-radio {
                display: none;
            }
            .plan-radio:checked + .plan-selection-card {
                border-color: #22c55e;
                background: #2d3748;
                box-shadow: 0 0 20px rgba(34, 197, 94, 0.2);
            }
            .plan-badge {
                display: inline-block;
                padding: 2px 12px;
                border-radius: 12px;
                font-size: 11px;
                font-weight: 600;
                margin-left: 10px;
            }
            .plan-badge.popular {
                background: #22c55e;
                color: white;
            }
        </style>
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

                    <!-- REGISTER FORM -->
                    <form action="${pageContext.request.contextPath}/register" method="POST" id="registerForm">
                        <input type="hidden" name="plan" id="selectedPlan" value="<%= request.getParameter("plan") != null ? request.getParameter("plan") : ""%>">
                        <input type="hidden" name="amount" id="selectedAmount" value="<%= request.getParameter("amount") != null ? request.getParameter("amount") : ""%>">

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
                                   required>
                        </div>

                        <!-- PLAN SELECTION -->
                        <div class="mt-4 mb-3">
                            <label class="fw-bold" style="color: white;">Select Your Plan</label>

                            <!-- Basic Plan -->
                            <label class="plan-radio-label">
                                <input type="radio" name="planRadio" value="Basic" 
                                       class="plan-radio" 
                                       onclick="selectPlan('Basic', '39.00')"
                                       <%= request.getParameter("plan") != null && request.getParameter("plan").equals("Basic") ? "checked" : ""%>>
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
                                       <%= request.getParameter("plan") != null && request.getParameter("plan").equals("Premium") ? "checked" : ""%>>
                                <div class="plan-selection-card" style="border-color: #22c55e;">
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
                                       <%= request.getParameter("plan") != null && request.getParameter("plan").equals("Elite") ? "checked" : ""%>>
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
                        <div id="planError" class="alert alert-danger" style="display: none; font-size: 14px; padding: 8px 12px;">
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
                document.getElementById('planError').style.display = 'none';

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
                    document.getElementById('planError').style.display = 'block';
                    document.getElementById('planError').textContent = '⚠️ Please select a membership plan before registering.';
                    return false;
                }
                return true;
            }

            // Auto-select if plan came from URL parameter
            document.addEventListener('DOMContentLoaded', function () {
                const planParam = '<%= request.getParameter("plan") != null ? request.getParameter("plan") : ""%>';
                const amountParam = '<%= request.getParameter("amount") != null ? request.getParameter("amount") : ""%>';

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

        <%
            String error = request.getParameter("error");
            if ("duplicate".equals(error)) {
        %>
        <script>
            alert("Email already exists! Please use another email.");
        </script>
        <%
        } else if ("other".equals(error)) {
        %>
        <script>
            alert("Something went wrong. Please try again.");
        </script>
        <%
        } else if ("noplan".equals(error)) {
        %>
        <script>
            alert("⚠️ Please select a membership plan before registering.");
        </script>
        <%
            }
        %>
        <%
            System.out.println("=== REGISTER.JSP DEBUG ===");
            System.out.println("plan param: " + request.getParameter("plan"));
            System.out.println("amount param: " + request.getParameter("amount"));
        %>
    </body>
</html>