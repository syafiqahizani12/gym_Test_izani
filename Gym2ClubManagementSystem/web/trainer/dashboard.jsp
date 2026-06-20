<%-- 
    Document   : dashboard
    Created on : 19 Jun 2026, 9:42:29 pm
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/header.jsp" %>
<h2>Trainer Dashboard</h2>
<div class="row">
    <div class="col-md-6"><div class="card"><div class="card-body"><h5>My Schedules</h5><a href="${pageContext.request.contextPath}/trainer/scheduleList.jsp" class="btn btn-primary">View</a></div></div></div>
    <div class="col-md-6"><div class="card"><div class="card-body"><h5>Mark Attendance</h5><a href="${pageContext.request.contextPath}/trainer/attendanceForm.jsp" class="btn btn-primary">Mark</a></div></div></div>
</div>
<%@ include file="/footer.jsp" %>