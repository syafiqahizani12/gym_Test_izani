<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UniGym Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/index.jsp">
            <i class="fa-solid fa-dumbbell"></i> UniGym
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavbar" aria-controls="mainNavbar" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="mainNavbar">
            <ul class="navbar-nav me-auto">
                <c:choose>
                    <c:when test="${sessionScope.user.role == 'Member'}">
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/student/dashboard.jsp"><i class="fa-solid fa-gauge"></i> Dashboard</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/student/membershipDetails.jsp"><i class="fa-solid fa-id-card"></i> Membership</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/student/checkIn.jsp"><i class="fa-solid fa-right-to-bracket"></i> Check-In</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/student/scheduleList.jsp"><i class="fa-solid fa-calendar-days"></i> Classes</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/student/bookingList.jsp"><i class="fa-solid fa-bookmark"></i> Bookings</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/student/paymentHistory.jsp"><i class="fa-solid fa-receipt"></i> Payments</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/student/profile.jsp"><i class="fa-solid fa-user"></i> Profile</a></li>
                    </c:when>
                    <c:when test="${sessionScope.user.role == 'Trainer'}">
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/trainer/dashboard.jsp"><i class="fa-solid fa-gauge"></i> Dashboard</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/trainer/scheduleList.jsp"><i class="fa-solid fa-calendar-days"></i> My Schedules</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/trainer/attendanceForm.jsp"><i class="fa-solid fa-clipboard-check"></i> Mark Attendance</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/trainer/attendanceList.jsp"><i class="fa-solid fa-list-check"></i> Records</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/trainer/profile.jsp"><i class="fa-solid fa-user"></i> Profile</a></li>
                    </c:when>
                    <c:when test="${sessionScope.user.role == 'Manager'}">
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/manager/dashboard.jsp"><i class="fa-solid fa-gauge"></i> Dashboard</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/manager/membershipList.jsp"><i class="fa-solid fa-id-card"></i> Memberships</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/manager/view_payments.jsp"><i class="fa-solid fa-receipt"></i> Payments</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/manager/trainerList.jsp"><i class="fa-solid fa-user-tie"></i> Trainers</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/manager/scheduleList.jsp"><i class="fa-solid fa-calendar-plus"></i> Schedules</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/manager/bookingList.jsp"><i class="fa-solid fa-book-open"></i> Bookings</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/manager/attendanceReport.jsp"><i class="fa-solid fa-chart-column"></i> Attendance</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/manager/profile.jsp"><i class="fa-solid fa-user"></i> Profile</a></li>
                    </c:when>
                </c:choose>
            </ul>
            <ul class="navbar-nav ms-auto align-items-lg-center">
                <c:if test="${not empty sessionScope.user}">
                    <li class="nav-item">
                        <span class="navbar-text">
                            ${sessionScope.user.fullName}
                            <span class="badge bg-success">${sessionScope.user.role}</span>
                        </span>
                    </li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-arrow-right-from-bracket"></i> Logout</a></li>
                </c:if>
            </ul>
        </div>
    </div>
</nav>
<main class="container py-4">
