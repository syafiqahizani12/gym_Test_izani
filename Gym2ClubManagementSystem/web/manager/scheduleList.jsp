<%-- 
    Document   : scheduleList
    Created on : 19 Jun 2026, 9:47:11 pm
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    com.lab.dao.ScheduleDAO dao = new com.lab.dao.ScheduleDAO();
    request.setAttribute("schedules", dao.getAllSchedules());
%>
<h2>Manage Schedules</h2>
<c:if test="${param.result == 'saved'}"><div class="alert alert-success">Schedule saved successfully.</div></c:if>
<c:if test="${param.result == 'failed'}"><div class="alert alert-danger">Schedule was not saved. Check the server log for the database error.</div></c:if>
<a href="${pageContext.request.contextPath}/manager/scheduleForm.jsp" class="btn btn-primary mb-3">Add New</a>
<table class="table table-striped">
    <thead><tr><th>ID</th><th>Class</th><th>Plan</th><th>Trainer</th><th>Date</th><th>Time</th><th>Availability</th><th>Actions</th></tr></thead>
    <tbody>
        <c:forEach var="s" items="${schedules}">
            <tr>
                <td>${s.scheduleID}</td>
                <td>${s.className}</td>
                <td><span class="plan-tier plan-tier-${s.planType.toLowerCase()}">${s.planType}</span></td>
                <td>${s.trainerName}</td>
                <td>${s.classDate}</td>
                <td>${s.startTime} - ${s.endTime}</td>
                <td><c:choose><c:when test="${s.full}"><span class="badge bg-danger">Full</span></c:when><c:otherwise><span class="badge bg-success">${s.capacity} spaces</span></c:otherwise></c:choose></td>
                <td>
                    <a href="${pageContext.request.contextPath}/schedule?action=edit&id=${s.scheduleID}" class="btn btn-sm btn-warning">Edit</a>
                    <a href="${pageContext.request.contextPath}/schedule?action=delete&id=${s.scheduleID}" class="btn btn-sm btn-danger" onclick="return confirm('Delete?')">Delete</a>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>
<a href="${pageContext.request.contextPath}/manager/dashboard.jsp" class="btn btn-secondary">Back</a>
<%@ include file="/footer.jsp" %>
