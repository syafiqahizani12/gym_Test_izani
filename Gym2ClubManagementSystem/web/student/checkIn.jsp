<%@ page pageEncoding="UTF-8" %>
<%@ include file="/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    com.lab.model.User user = (com.lab.model.User) session.getAttribute("user");
    com.lab.dao.AttendanceDAO dao = new com.lab.dao.AttendanceDAO();
    request.setAttribute("bookedSchedules", dao.getBookedSchedulesForCheckIn(user.getUserId()));
%>

<div class="page-heading">
    <div><h2>Class Check-In</h2><p>Check in during the scheduled time of a confirmed booking.</p></div>
</div>

<c:if test="${param.error == 'time'}"><div class="alert alert-warning">Check-in opens at the class start time and closes when the class ends.</div></c:if>
<c:if test="${param.error == 'booking'}"><div class="alert alert-danger">A confirmed booking matching your membership plan is required.</div></c:if>
<c:if test="${param.error == 'already'}"><div class="alert alert-info">You are already checked in for that class.</div></c:if>
<c:if test="${param.error == 'failed'}"><div class="alert alert-danger">Check-in could not be completed.</div></c:if>

<div class="table-responsive">
    <table class="table table-striped align-middle">
        <thead><tr><th>Class</th><th>Plan</th><th>Trainer</th><th>Date</th><th>Time</th><th>Status</th><th>Action</th></tr></thead>
        <tbody>
            <c:forEach var="s" items="${bookedSchedules}">
                <tr>
                    <td>${s.className}</td>
                    <td><span class="plan-tier plan-tier-${s.planType.toLowerCase()}">${s.planType}</span></td>
                    <td>${s.trainerName}</td>
                    <td>${s.classDate}</td>
                    <td>${s.startTime} - ${s.endTime}</td>
                    <td>
                        <c:choose>
                            <c:when test="${s.checkedIn}"><span class="badge bg-success">Checked In</span></c:when>
                            <c:when test="${s.checkInOpen}"><span class="badge bg-warning text-dark">Open Now</span></c:when>
                            <c:otherwise><span class="badge bg-secondary">Closed</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <form action="${pageContext.request.contextPath}/attendance" method="post">
                            <input type="hidden" name="action" value="checkin">
                            <input type="hidden" name="scheduleID" value="${s.scheduleID}">
                            <button type="submit" class="btn btn-sm btn-success" ${!s.checkInOpen || s.checkedIn ? 'disabled' : ''}>
                                <i class="fa-solid fa-right-to-bracket"></i> Check In
                            </button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty bookedSchedules}"><tr><td colspan="7" class="empty-state">You have no confirmed classes available for check-in.</td></tr></c:if>
        </tbody>
    </table>
</div>

<a href="${pageContext.request.contextPath}/student/dashboard.jsp" class="btn btn-secondary mt-3">Back</a>
<%@ include file="/footer.jsp" %>
