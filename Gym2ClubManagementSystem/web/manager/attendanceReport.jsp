<%-- 
    Document   : attendanceReport
    Created on : 19 Jun 2026, 9:48:10 pm
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    com.lab.dao.AttendanceDAO dao = new com.lab.dao.AttendanceDAO();
    request.setAttribute("attendances", dao.getAllAttendance());
%>
<h2>Attendance Reports</h2>
<table class="table">
    <thead><tr><th>Student</th><th>Schedule</th><th>Check In</th><th>Check Out</th><th>Status</th></tr></thead>
    <tbody>
        <c:forEach var="a" items="${attendances}">
            <tr>
                <td>${a.studentName}</td>
                <td>${a.scheduleName}</td>
                <td>${a.checkInTime}</td>
                <td>${a.checkOutTime}</td>
                <td>${a.attendanceStatus}</td>
            </tr>
        </c:forEach>
    </tbody>
</table>
<a href="${pageContext.request.contextPath}/manager/dashboard.jsp" class="btn btn-secondary">Back</a>
<%@ include file="/footer.jsp" %>
