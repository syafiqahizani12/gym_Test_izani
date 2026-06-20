<%-- 
    Document   : index
    Created on : 26 May 2026, 5:02:48 pm
    Author     : DELL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Gym Club Management System</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index_style.css">
    </head>

    <body>
        <c:set var="isLoggedIn" value="${not empty sessionScope.user}" />
        <nav class="navbar navbar-expand-lg navbar-dark custom-navbar fixed-top">
            <div class="container">

                <a class="navbar-brand fw-bold" href="#">
                    UniGym
                </a>

                <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                        data-bs-target="#navbarContent">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="collapse navbar-collapse" id="navbarContent">

                    <ul class="navbar-nav ms-auto align-items-center">

                        <li class="nav-item">
                            <a class="nav-link" href="#membership">Membership</a>
                        </li>

                        <li class="nav-item">
                            <a class="nav-link" href="#features">Features</a>
                        </li>

                        <li class="nav-item">
                            <a class="nav-link" href="#trainer">Trainers</a>
                        </li>

                        <li class="nav-item ms-3">
                            <c:choose>
                                <c:when test="${isLoggedIn}">
                            <div class="dropdown">
                                <button class="btn btn-login dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="fa fa-user-circle me-1"></i> Hi, ${sessionScope.user.fullName}
                                </button>
                                <ul class="dropdown-menu dropdown-menu-dark">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/student/dashboard.jsp">My Dashboard</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">Logout</a></li>
                                </ul>
                            </div>
                                </c:when>
                                <c:otherwise>
                            <a class="btn btn-login" href="login.jsp">
                                Login
                            </a>
                                </c:otherwise>
                            </c:choose>
                        </li>

                    </ul>

                </div>
            </div>
        </nav>

        <section class="hero-section">

            <div class="overlay"></div>

            <div class="container hero-content">

                <div class="row align-items-center">

                    <div class="col-lg-6">

                        <h1 class="hero-title">
                            Transform Your Fitness Journey
                        </h1>

                        <p class="hero-text">
                            Manage gym attendance, bookings, memberships,
                            and trainer schedules in one smart platform.
                        </p>

                        <div class="hero-buttons">

                            <c:choose>
                                <c:when test="${isLoggedIn}">
                            <a href="${pageContext.request.contextPath}/student/dashboard.jsp" class="btn btn-main">
                                Go to Dashboard &rarr;
                            </a>
                                </c:when>
                                <c:otherwise>
                            <a href="login.jsp" class="btn btn-main">
                                Get Started
                            </a>
                                </c:otherwise>
                            </c:choose>

                            <a href="#membership" class="btn btn-outline-light">
                                Explore Plans
                            </a>

                        </div>

                    </div>

                </div>

            </div>

        </section>

        <section class="features-section" id="features">

            <div class="container">

                <div class="section-title text-center">
                    <h2>Why Choose UniGym?</h2>
                    <p>Everything you need in one gym management platform.</p>
                </div>

                <div class="row g-4 mt-4">

                    <div class="col-md-4">
                        <div class="feature-card">

                            <i class="fa-solid fa-dumbbell feature-icon"></i>

                            <h4>Attendance Tracking</h4>

                            <p>
                                Easily monitor gym attendance and check-ins.
                            </p>

                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="feature-card">

                            <i class="fa-solid fa-calendar-check feature-icon"></i>

                            <h4>Class Booking</h4>

                            <p>
                                Book workout sessions and trainer appointments online.
                            </p>

                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="feature-card">

                            <i class="fa-solid fa-chart-line feature-icon"></i>

                            <h4>Performance Analytics</h4>

                            <p>
                                View attendance statistics and activity reports.
                            </p>

                        </div>
                    </div>

                </div>

            </div>

        </section>

        <section class="membership-section" id="membership">

            <div class="container">

                <div class="section-title text-center">
                    <h2>Membership Plans</h2>
                    <p>Flexible plans for every student lifestyle.</p>
                </div>

                <div class="row g-4 mt-4">

                    <div class="col-lg-4">
                        <div class="membership-card">

                            <h3>Basic</h3>

                            <div class="price">
                                RM39<span>/month</span>
                            </div>

                            <ul>
                                <li>Gym Access</li>
                                <li>Attendance Tracking</li>
                                <li>Locker Access</li>
                            </ul>

                            <c:choose>
                                <c:when test="${isLoggedIn}">
                            <a href="${pageContext.request.contextPath}/student/dashboard.jsp" class="btn btn-plan">Manage Plan</a>
                                </c:when>
                                <c:otherwise>
                            <a href="${pageContext.request.contextPath}/register.jsp?plan=Basic&amount=39.00" class="btn btn-plan">Join Now</a>
                                </c:otherwise>
                            </c:choose>

                        </div>
                    </div>

                    <div class="col-lg-4">
                        <div class="membership-card premium-card">

                            <div class="popular-badge">
                                Popular
                            </div>

                            <h3>Premium</h3>

                            <div class="price">
                                RM79<span>/month</span>
                            </div>

                            <ul>
                                <li>Unlimited Classes</li>
                                <li>Trainer Sessions</li>
                                <li>Priority Booking</li>
                            </ul>

                            <c:choose>
                                <c:when test="${isLoggedIn}">
                            <a href="${pageContext.request.contextPath}/student/dashboard.jsp" class="btn btn-plan">Manage Plan</a>
                                </c:when>
                                <c:otherwise>
                            <a href="${pageContext.request.contextPath}/register.jsp?plan=Premium&amount=79.00" class="btn btn-plan">Join Now</a>
                                </c:otherwise>
                            </c:choose>

                        </div>
                    </div>

                    <div class="col-lg-4">
                        <div class="membership-card">

                            <h3>Elite</h3>

                            <div class="price">
                                RM129<span>/month</span>
                            </div>

                            <ul>
                                <li>VIP Lounge</li>
                                <li>Personal Trainer</li>
                                <li>Full Facility Access</li>
                            </ul>

                            <c:choose>
                                <c:when test="${isLoggedIn}">
                            <a href="${pageContext.request.contextPath}/student/dashboard.jsp" class="btn btn-plan">Manage Plan</a>
                                </c:when>
                                <c:otherwise>
                            <a href="${pageContext.request.contextPath}/register.jsp?plan=Elite&amount=129.00" class="btn btn-plan">Join Now</a>
                                </c:otherwise>
                            </c:choose>

                        </div>
                    </div>

                </div>

            </div>

        </section>

        <section class="trainer-section" id="trainer">

            <div class="container">

                <div class="section-title text-center">
                    <h2>Professional Trainers</h2>
                    <p>Train with certified fitness experts.</p>
                </div>

                <div class="row g-4 mt-4">

                    <div class="col-md-4">
                        <div class="trainer-card">

                            <img src="https://images.unsplash.com/photo-1567013127542-490d757e6349?q=80&w=800"
                                 class="img-fluid">

                            <div class="trainer-info">
                                <h5>Muhammad Aidil</h5>
                                <p>Strength Coach</p>
                            </div>

                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="trainer-card">

                            <img src="https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80&w=800"
                                 class="img-fluid">

                            <div class="trainer-info">
                                <h5>Sarah Lee</h5>
                                <p>Fitness Trainer</p>
                            </div>

                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="trainer-card">

                            <img src="https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?q=80&w=800"
                                 class="img-fluid">

                            <div class="trainer-info">
                                <h5>Hazim Ihsan</h5>
                                <p>Cardio Specialist</p>
                            </div>

                        </div>
                    </div>

                </div>

            </div>

        </section>

        <footer class="footer">

            <div class="container text-center">

                <h4>UniGym Management System</h4>

                <p>
                    Smart gym management solution for university students.
                </p>

                <div class="social-icons">

                    <i class="fa-brands fa-facebook"></i>
                    <i class="fa-brands fa-instagram"></i>
                    <i class="fa-brands fa-x-twitter"></i>

                </div>

            </div>
            <%
                String needRegister = request.getParameter("needRegister");
                String needPlan = request.getParameter("needPlan");

                if ("true".equals(needRegister)) {
            %>
            <script>
                alert("⚠️ You need to choose a plan and register first!\nPlease select a membership plan and create an account.");
                window.location.href = "#membership";
            </script>
            <%
            } else if ("true".equals(needPlan)) {
            %>
            <script>
                alert("⚠️ You don't have an active membership.\nPlease choose a plan and subscribe to continue.");
                window.location.href = "#membership";
            </script>
            <%
                }
            %>

        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    </body>
</html>
