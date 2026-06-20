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
    com.lab.model.User trainer = (com.lab.model.User) session.getAttribute("user");
    request.setAttribute("attendances", dao.getAttendanceByTrainer(trainer.getUserId()));
%>
<h2>Attendance Records</h2>
<c:if test="${param.mark == 'success'}"><div class="alert alert-success">Attendance updated successfully.</div></c:if>
<div class="table-responsive"><table class="table">
    <thead><tr><th>Student</th><th>Schedule</th><th>Check In</th><th>Status</th></tr></thead>
    <tbody>
        <c:forEach var="a" items="${attendances}">
            <tr>
                <td>${a.studentName}</td>
                <td>${a.scheduleName}</td>
                <td>${a.checkInTime}</td>
                <td>${a.attendanceStatus}</td>
            </tr>
        </c:forEach>
        <c:if test="${empty attendances}"><tr><td colspan="4" class="empty-state">No attendance has been recorded for your booked participants.</td></tr></c:if>
    </tbody>
</table></div>
<a href="${pageContext.request.contextPath}/trainer/dashboard.jsp" class="btn btn-secondary">Back</a>
<%@ include file="/footer.jsp" %>
