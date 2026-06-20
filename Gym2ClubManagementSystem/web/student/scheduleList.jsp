<%-- 
    Document   : scheduleList
    Created on : 19 Jun 2026, 9:40:44 pm
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    com.lab.dao.ScheduleDAO dao = new com.lab.dao.ScheduleDAO();
    request.setAttribute("schedules", dao.getAllSchedules());
%>
<h2>Class Schedules</h2>
<table class="table table-striped">
    <thead><tr><th>Class</th><th>Trainer</th><th>Date</th><th>Time</th><th>Capacity</th><th>Action</th></tr></thead>
    <tbody>
        <c:forEach var="s" items="${schedules}">
            <tr>
                <td>${s.className}</td>
                <td>${s.trainerID}</td>
                <td>${s.classDate}</td>
                <td>${s.startTime} - ${s.endTime}</td>
                <td>${s.capacity}</td>
                <td>
                    <form action="${pageContext.request.contextPath}/booking" method="post">
                        <input type="hidden" name="action" value="create">
                        <input type="hidden" name="scheduleID" value="${s.scheduleID}">
                        <input type="hidden" name="studentID" value="${sessionScope.user.userID}">
                        <button type="submit" class="btn btn-sm btn-success">Book</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>
<a href="${pageContext.request.contextPath}/student/dashboard.jsp" class="btn btn-secondary">Back</a>
<%@ include file="../footer.jsp" %>
