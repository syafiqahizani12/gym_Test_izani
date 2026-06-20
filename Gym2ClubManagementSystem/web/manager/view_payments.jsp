<%-- 
    Document   : view_payments
    Created on : Jun 20, 2026, 2:05:52 PM
    Author     : batrisyia aliza
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.lab.model.Payment"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment Reconciliation Logs</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/dashboard.css">
</head>
<body>

<header class="dashboard-header">
    <div class="logo">UniGym Admin Panel</div>
    <div class="profile-section">Gym Manager</div>
</header>

<div class="main-content container-fluid mt-4">
    <div class="table-section text-white" style="background:#1e293b; padding:30px; border-radius:20px;">
        <h3 class="mb-4" style="color:#22c55e;">Incoming Membership Payment Validations</h3>
        
        <table class="table table-dark table-hover align-middle custom-table">
            <thead>
                <tr>
                    <th>Transaction ID</th>
                    <th>Student Name</th>
                    <th>Selected Plan</th>
                    <th>Amount Paid</th>
                    <th>Submission Timestamp</th>
                    <th>Payment Slip Proof</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Payment> payments = (List<Payment>) request.getAttribute("paymentList");
                    if (payments != null && !payments.isEmpty()) {
                        for (Payment p : payments) {
                %>
                <tr>
                    <td>PAY-00<%= p.getPaymentId() %></td>
                    <td><%= p.getStudentName() %></td>
                    <td><span class="badge bg-secondary"><%= p.getPlanName() %></span></td>
                    <td class="text-success fw-bold">RM <%= String.format("%.2f", p.getAmount()) %></td>
                    <td><%= p.getPaymentDate() %></td>
                    <td>
                        <a href="uploads/<%= p.getProofImage() %>" target="_blank">
                            <img src="uploads/<%= p.getProofImage() %>" alt="Slip Proof" style="width:70px; height:70px; object-fit:cover; border-radius:8px; border:1px solid #22c55e;">
                        </a>
                    </td>
                    <td><span class="badge bg-warning text-dark"><%= p.getStatus() %></span></td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="7" class="text-center text-muted">No transactions pending confirmation.</td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>