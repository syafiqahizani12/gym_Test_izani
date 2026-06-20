<%-- 
    Document   : scheduleList
    Created on : 19 Jun 2026, 9:44:45 pm
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    com.lab.dao.ScheduleDAO dao = new com.lab.dao.ScheduleDAO();
    com.lab.model.User user = (com.lab.model.User) session.getAttribute("user");
    request.setAttribute("schedules", dao.getSchedulesByTrainer(user.getUserId()));
%>
<h2>My Schedules</h2>
<table class="table">
    <thead><tr><th>Class</th><th>Plan</th><th>Date</th><th>Time</th><th>Availability</th></tr></thead>
    <tbody>
        <c:forEach var="s" items="${schedules}">
            <tr>
                <td>${s.className}</td>
                <td><span class="plan-tier plan-tier-${s.planType.toLowerCase()}">${s.planType}</span></td>
                <td>${s.classDate}</td>
                <td>${s.startTime} - ${s.endTime}</td>
                <td><c:choose><c:when test="${s.full}"><span class="badge bg-danger">Full</span></c:when><c:otherwise><span class="badge bg-success">${s.capacity} spaces</span></c:otherwise></c:choose></td>
            </tr>
        </c:forEach>
    </tbody>
</table>
<a href="${pageContext.request.contextPath}/trainer/dashboard.jsp" class="btn btn-secondary">Back</a>
<%@ include file="/footer.jsp" %>
