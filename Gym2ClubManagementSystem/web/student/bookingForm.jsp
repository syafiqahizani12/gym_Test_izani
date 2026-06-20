<%-- 
    Document   : bookingForm
    Created on : 19 Jun 2026, 9:41:10 pm
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<h2>Booking</h2>
<c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
<a href="${pageContext.request.contextPath}/student/scheduleList.jsp" class="btn btn-primary">Back to Schedules</a>
<%@ include file="../footer.jsp" %>