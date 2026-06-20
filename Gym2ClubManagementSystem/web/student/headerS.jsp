<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UniGym - Student Dashboard</title>
    
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <!-- Brand / Logo -->
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/student/dashboard.jsp">
            <i class="fas fa-dumbbell"></i> UniGym
        </a>
        
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <div class="collapse navbar-collapse" id="navbarNav">
            <!-- Left side: Navigation Links -->
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.requestURI.contains('dashboard') ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/student/dashboard.jsp">
                        <i class="fas fa-home"></i> Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.requestURI.contains('scheduleList') ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/student/scheduleList.jsp">
                        <i class="fas fa-calendar"></i> Schedules
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.requestURI.contains('bookingList') ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/student/bookingList.jsp">
                        <i class="fas fa-book"></i> My Bookings
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.requestURI.contains('attendanceList') ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/student/attendanceList.jsp">
                        <i class="fas fa-chart-bar"></i> Attendance
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.requestURI.contains('checkIn') ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/student/checkIn.jsp">
                        <i class="fas fa-sign-in-alt"></i> Check In
                    </a>
                </li>
            </ul>
            
            <!-- Right side: User Info & Actions -->
            <ul class="navbar-nav ms-auto">
                <!-- User Name & Role -->
                <li class="nav-item">
                    <span class="navbar-text text-white">
                        <i class="fas fa-user-circle"></i> 
                        ${sessionScope.user.fullName} 
                        <span class="badge bg-success">${sessionScope.user.role}</span>
                    </span>
                </li>
                
                <!-- Profile -->
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/student/profile.jsp">
                        <i class="fas fa-id-card"></i> Profile
                    </a>
                </li>
                
                <!-- Renew Membership -->
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/student/renewMembership.jsp">
                        <i class="fas fa-sync-alt"></i> Renew
                    </a>
                </li>
                
                <!-- Logout -->
                <li class="nav-item">
                    <a class="nav-link text-danger" href="${pageContext.request.contextPath}/logout">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-4">