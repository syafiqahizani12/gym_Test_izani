<%-- 
    Document   : attendanceForm
    Created on : 19 Jun 2026, 9:45:47 pm
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    com.lab.dao.ScheduleDAO schedDao = new com.lab.dao.ScheduleDAO();
    com.lab.model.User user = (com.lab.model.User) session.getAttribute("user");
    request.setAttribute("schedules", schedDao.getSchedulesByTrainer(user.getUserId()));
%>
<h2>Mark Attendance</h2>
<c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
<form action="${pageContext.request.contextPath}/attendance" method="post">
    <input type="hidden" name="action" value="mark">
    <div class="mb-3">
        <label>Schedule</label>
        <select name="scheduleID" class="form-control" required>
            <option value="">Select Schedule</option>
            <c:forEach var="s" items="${schedules}">
                <option value="${s.scheduleID}">${s.className} - ${s.classDate} ${s.startTime}</option>
            </c:forEach>
        </select>
    </div>
    <div class="mb-3">
        <label>Student ID</label>
        <input type="number" name="studentID" class="form-control" required>
    </div>
    <div class="mb-3">
        <label>Status</label>
        <select name="attendanceStatus" class="form-control">
            <option value="Present">Present</option>
            <option value="Absent">Absent</option>
        </select>
    </div>
    <button type="submit" class="btn btn-primary">Mark</button>
    <a href="${pageContext.request.contextPath}/trainer/dashboard.jsp" class="btn btn-secondary">Back</a>
</form>
<%@ include file="/footer.jsp" %>
