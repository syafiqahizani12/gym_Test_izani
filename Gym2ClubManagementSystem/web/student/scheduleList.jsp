<%-- 
    Document   : scheduleList
    Created on : 19 Jun 2026, 9:40:44 pm
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    com.lab.dao.ScheduleDAO dao = new com.lab.dao.ScheduleDAO();
    com.lab.model.User user = (com.lab.model.User) session.getAttribute("user");
    com.lab.model.Membership membership = new com.lab.dao.MembershipDAO().getMembershipByStudentId(user.getUserId());
    request.setAttribute("membership", membership);
    request.setAttribute("schedules", membership == null ? java.util.Collections.emptyList() : dao.getSchedulesByPlan(membership.getMembershipType()));
%>
<div class="page-heading">
    <div><h2>Class Schedules</h2><p>Classes available for your membership plan.</p></div>
    <c:if test="${not empty membership}"><span class="plan-tier plan-tier-${membership.membershipType.toLowerCase()}">${membership.membershipType}</span></c:if>
</div>
<c:if test="${param.error == 'duplicate'}">
    <div class="alert alert-warning">You already booked this class.</div>
</c:if>
<c:if test="${param.error == 'full'}">
    <div class="alert alert-danger">This class is full.</div>
</c:if>
<c:if test="${param.error == 'failed'}">
    <div class="alert alert-danger">Booking failed. Please try again.</div>
</c:if>
<c:if test="${param.error == 'plan'}">
    <div class="alert alert-danger">This class is not available for your membership plan.</div>
</c:if>
<div class="table-responsive">
<table class="table table-striped align-middle">
    <thead><tr><th>Class</th><th>Plan</th><th>Trainer</th><th>Date</th><th>Time</th><th>Spaces</th><th>Action</th></tr></thead>
    <tbody>
        <c:forEach var="s" items="${schedules}">
            <tr>
                <td>${s.className}</td>
                <td><span class="plan-tier plan-tier-${s.planType.toLowerCase()}">${s.planType}</span></td>
                <td>${s.trainerName}</td>
                <td>${s.classDate}</td>
                <td>${s.startTime} - ${s.endTime}</td>
                <td><c:choose><c:when test="${s.full}"><span class="badge bg-danger">Full</span></c:when><c:otherwise><span class="badge bg-success">${s.capacity} available</span></c:otherwise></c:choose></td>
                <td>
                    <form action="${pageContext.request.contextPath}/booking" method="post">
                        <input type="hidden" name="action" value="create">
                        <input type="hidden" name="scheduleID" value="${s.scheduleID}">
                        <button type="submit" class="btn btn-sm btn-success" ${s.full ? 'disabled' : ''}><i class="fa-solid fa-calendar-check"></i> ${s.full ? 'Full' : 'Book'}</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty schedules}"><tr><td colspan="7" class="empty-state">No ${membership.membershipType} classes are available yet.</td></tr></c:if>
    </tbody>
</table>
</div>
<a href="${pageContext.request.contextPath}/student/dashboard.jsp" class="btn btn-secondary">Back</a>
<%@ include file="/footer.jsp" %>
