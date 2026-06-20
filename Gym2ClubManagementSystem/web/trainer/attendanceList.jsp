<%-- 
    Document   : attendanceList.jsp
    Created on : 19 Jun 2026, 9:45:20 pm
    Author     : ASUS
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ include file="/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    com.lab.dao.AttendanceDAO dao = new com.lab.dao.AttendanceDAO();
    request.setAttribute("attendances", dao.getAllAttendance());
%>
<h2>Attendance Records</h2>
<table class="table">
    <thead><tr><th>Student</th><th>Schedule</th><th>Check In</th><th>Status</th></tr></thead>
    <tbody>
        <c:forEach var="a" items="${attendances}">
            <tr>
                <td>${a.studentID}</td>
                <td>${a.scheduleID}</td>
                <td>${a.checkInTime}</td>
                <td>${a.attendanceStatus}</td>
            </tr>
        </c:forEach>
    </tbody>
</table>
<a href="${pageContext.request.contextPath}/trainer/dashboard.jsp" class="btn btn-secondary">Back</a>
<%@ include file="/footer.jsp" %>