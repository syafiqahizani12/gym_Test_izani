<%-- 
    Document   : bookingList
    Created on : 19 Jun 2026, 9:40:56 pm
    Author     : ASUS
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ include file="../header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    com.lab.dao.BookingDAO dao = new com.lab.dao.BookingDAO();
    com.lab.model.User user = (com.lab.model.User) session.getAttribute("user");
    request.setAttribute("bookings", dao.getBookingsByStudent(user.getUserId()));
%>

<h2>My Bookings</h2>

<table class="table">
    <thead>
        <tr>
            <th>Schedule</th>
            <th>Booking Date</th>
            <th>Status</th>
            <th>Action</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="b" items="${bookings}">
            <tr>
                <td>${b.scheduleID}</td>
                <td>${b.bookingDate}</td>
                <td>${b.bookingStatus}</td>
                <td>
                    <c:if test="${b.bookingStatus == 'Confirmed'}">
                        <a href="${pageContext.request.contextPath}/booking?action=cancel&bookingID=${b.bookingID}" 
                           class="btn btn-sm btn-danger" 
                           onclick="return confirm('Cancel booking?')">Cancel</a>
                    </c:if>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>

<a href="${pageContext.request.contextPath}/student/dashboard.jsp" class="btn btn-secondary">Back</a>

<%@ include file="../footer.jsp" %>