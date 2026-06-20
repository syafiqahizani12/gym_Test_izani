<%-- 
    Document   : dashboard
    Created on : 19 Jun 2026, 9:45:58 pm
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/header.jsp" %>
<h2>Manager Dashboard</h2>
<div class="row">
    <div class="col-md-3 mb-3"><div class="card"><div class="card-body"><h5>Memberships</h5><a href="${pageContext.request.contextPath}/manager/membershipList.jsp" class="btn btn-primary">Manage</a></div></div></div>
    <div class="col-md-3 mb-3"><div class="card"><div class="card-body"><h5>Trainers</h5><a href="${pageContext.request.contextPath}/manager/trainerList.jsp" class="btn btn-primary">Manage</a></div></div></div>
    <div class="col-md-3 mb-3"><div class="card"><div class="card-body"><h5>Schedules</h5><a href="${pageContext.request.contextPath}/manager/scheduleList.jsp" class="btn btn-primary">Manage</a></div></div></div>
    <div class="col-md-3 mb-3"><div class="card"><div class="card-body"><h5>Bookings</h5><a href="${pageContext.request.contextPath}/manager/bookingList.jsp" class="btn btn-primary">View</a></div></div></div>
    <div class="col-md-3 mb-3"><div class="card"><div class="card-body"><h5>Attendance Reports</h5><a href="${pageContext.request.contextPath}/manager/attendanceReport.jsp" class="btn btn-primary">View</a></div></div></div>
</div>
<%@ include file="/footer.jsp" %>
