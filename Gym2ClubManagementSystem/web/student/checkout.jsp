<%-- 
    Document   : checkout
    Created on : Jun 20, 2026, 2:04:52 PM
    Author     : batrisyia aliza
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String plan = request.getParameter("plan") != null ? request.getParameter("plan") : "Basic";
    String price = "39.00";
    if(plan.equalsIgnoreCase("Premium")) price = "79.00";
    if(plan.equalsIgnoreCase("Elite")) price = "129.00";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Secure Membership Checkout</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../css/dashboard.css">
    <link rel="stylesheet" href="../css/student_style.css">
</head>
<body>

<header class="dashboard-header">
    <div class="logo">UniGym</div>
    <nav>
        <a href="student_attendance.jsp">Dashboard</a>
        <a href="#" class="active-nav">Membership</a>
    </nav>
    <div class="profile-section">Student Account</div>
</header>

<div class="container main-content mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6 checkin-box" style="text-align: left; padding: 40px;">
            <h2 class="text-center mb-4" style="color:#22c55e;">Checkout via QR</h2>
            <p class="text-center text-muted">Scan the bank QR below to pay <strong>RM <%= price %></strong> for <strong><%= plan %> Tier</strong>.</p>
            
            <div class="text-center">
                <img src="https://api.qrserver.com/v1/create-qr-code/?size=220x220&data=PROD-BANK-UNIGYM-RM<%=price%>" class="qr-image img-thumbnail my-3">
            </div>

            <form action="../PaymentServlet" method="POST" enctype="multipart/form-data" class="mt-4">
                <input type="hidden" name="planName" value="<%= plan %>">
                <input type="hidden" name="amount" value="<%= price %>">
                
                <div class="mb-3">
                    <label class="form-label text-white">Upload Payment Slip Proof (PNG/JPG):</label>
                    <input type="file" name="proofImage" class="form-control bg-dark text-white border-secondary" accept="image/png, image/jpeg" required>
                </div>
                
                <button type="submit" class="btn btn-success w-100 mt-2 fw-bold" style="background:#22c55e; border-radius:15px; padding:12px;">
                    Submit Transaction Reference
                </button>
            </form>
        </div>
    </div>
</div>

</body>
</html>