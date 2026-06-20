<%-- 
    Document   : bookingList
    Created on : 19 Jun 2026, 9:47:26 pm
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    com.lab.dao.BookingDAO dao = new com.lab.dao.BookingDAO();
    request.setAttribute("bookings", dao.getAllBookings());
%>
<h2>All Bookings</h2>
<table class="table">
    <thead><tr><th>Booking ID</th><th>Schedule</th><th>Student</th><th>Date</th><th>Status</th></tr></thead>
    <tbody>
        <c:forEach var="b" items="${bookings}">
            <tr>
                <td>${b.bookingID}</td>
                <td>${b.scheduleID}</td>
                <td>${b.studentID}</td>
                <td>${b.bookingDate}</td>
                <td>${b.bookingStatus}</td>
            </tr>
        </c:forEach>
    </tbody>
</table>
<a href="${pageContext.request.contextPath}/manager/dashboard.jsp" class="btn btn-secondary">Back</a>
<%@ include file="footer.jsp" %>
