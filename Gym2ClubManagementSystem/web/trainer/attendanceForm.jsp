<%@ page pageEncoding="UTF-8" %>
<%@ include file="/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    com.lab.model.User trainer = (com.lab.model.User) session.getAttribute("user");
    request.setAttribute("participants", new com.lab.dao.BookingDAO().getConfirmedBookingsByTrainer(trainer.getUserId()));
%>

<div class="page-heading">
    <div><h2>Class Attendance</h2><p>Only confirmed participants in your assigned classes are shown.</p></div>
</div>
<c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

<div class="table-responsive">
    <table class="table table-striped align-middle">
        <thead><tr><th>Class</th><th>Student</th><th>Date</th><th>Time</th><th>Current Status</th><th>Mark</th></tr></thead>
        <tbody>
            <c:forEach var="booking" items="${participants}">
                <tr>
                    <td>${booking.scheduleName}</td>
                    <td>${booking.studentName}</td>
                    <td>${booking.classDate}</td>
                    <td>${booking.startTime} - ${booking.endTime}</td>
                    <td>
                        <c:choose>
                            <c:when test="${booking.attendanceStatus == 'Present'}"><span class="badge bg-success">Present</span></c:when>
                            <c:when test="${booking.attendanceStatus == 'Absent'}"><span class="badge bg-danger">Absent</span></c:when>
                            <c:otherwise><span class="badge bg-secondary">Not Marked</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <form action="${pageContext.request.contextPath}/attendance" method="post" class="attendance-actions">
                            <input type="hidden" name="action" value="mark">
                            <input type="hidden" name="scheduleID" value="${booking.scheduleID}">
                            <input type="hidden" name="studentID" value="${booking.studentID}">
                            <button type="submit" name="attendanceStatus" value="Present" class="btn btn-sm btn-success" ${booking.attendanceOpen ? '' : 'disabled'}><i class="fa-solid fa-check"></i> Present</button>
                            <button type="submit" name="attendanceStatus" value="Absent" class="btn btn-sm btn-danger" ${booking.attendanceOpen ? '' : 'disabled'}><i class="fa-solid fa-xmark"></i> Absent</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty participants}"><tr><td colspan="6" class="empty-state">No students have booked your classes.</td></tr></c:if>
        </tbody>
    </table>
</div>
<p class="form-text mt-2"><i class="fa-solid fa-clock"></i> Attendance controls are enabled only during the scheduled class time.</p>
<a href="${pageContext.request.contextPath}/trainer/dashboard.jsp" class="btn btn-secondary mt-3">Back</a>
<%@ include file="/footer.jsp" %>
