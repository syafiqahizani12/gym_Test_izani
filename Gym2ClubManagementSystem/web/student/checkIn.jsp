<%-- 
    Document   : checkIn
    Created on : 19 Jun 2026
    Author     : ASUS
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ include file="../header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    com.lab.model.User user = (com.lab.model.User) session.getAttribute("user");
    com.lab.dao.AttendanceDAO dao = new com.lab.dao.AttendanceDAO();
    com.lab.dao.ScheduleDAO schedDao = new com.lab.dao.ScheduleDAO();
    request.setAttribute("schedules", schedDao.getAllSchedules());
%>

<h2>Check In</h2>

<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>

<form action="${pageContext.request.contextPath}/attendance" method="post">
    <input type="hidden" name="action" value="checkin">
    <input type="hidden" name="studentID" value="${sessionScope.user.userId}">
    
    <div class="mb-3">
        <label>Select Class</label>
        <select name="scheduleID" class="form-control" required>
            <option value="">Select a class</option>
            <c:forEach var="s" items="${schedules}">
                <option value="${s.scheduleID}">${s.className} - ${s.classDate} ${s.startTime}</option>
            </c:forEach>
        </select>
    </div>
    
    <button type="submit" class="btn btn-success">Check In</button>
    <a href="${pageContext.request.contextPath}/student/dashboard.jsp" class="btn btn-secondary">Back</a>
</form>

<%@ include file="../footer.jsp" %>