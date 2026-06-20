<%-- 
    Document   : attendanceList
    Created on : 19 Jun 2026, 9:43:21 pm
    Author     : ASUS
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ include file="/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    com.lab.dao.AttendanceDAO dao = new com.lab.dao.AttendanceDAO();
    com.lab.model.User user = (com.lab.model.User) session.getAttribute("user");
    request.setAttribute("attendances", dao.getAttendanceByStudent(user.getUserId()));
%>

<h2>My Attendance History</h2>

<table class="table">
    <thead>
        <tr>
            <th>Schedule</th>
            <th>Check In</th>
            <th>Check Out</th>
            <th>Status</th>
            <th>Action</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="a" items="${attendances}">
            <tr>
                <td>${a.scheduleID}</td>
                <td>${a.checkInTime}</td>
                <td>${a.checkOutTime}</td>
                <td>${a.attendanceStatus}</td>
                <td>
                    <c:if test="${a.checkOutTime == null && a.attendanceStatus == 'Present'}">
                        <form action="${pageContext.request.contextPath}/attendance" method="post">
                            <input type="hidden" name="action" value="checkout">
                            <input type="hidden" name="attendanceID" value="${a.attendanceID}">
                            <button type="submit" class="btn btn-sm btn-warning">Check Out</button>
                        </form>
                    </c:if>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>

<a href="${pageContext.request.contextPath}/student/dashboard.jsp" class="btn btn-secondary">Back</a>

<%@ include file="/footer.jsp" %>