<%-- 
    Document   : scheduleForm
    Created on : 19 Jun 2026, 9:47:50 pm
    Author     : ASUS
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ include file="/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    request.setAttribute("trainers", new com.lab.dao.UserDAO().getUsersByRole("Trainer"));
    request.setAttribute("today", java.time.LocalDate.now().toString());
%>

<h2>
    <c:choose>
        <c:when test="${param.action == 'edit'}">Edit</c:when>
        <c:otherwise>Add</c:otherwise>
    </c:choose>
    Schedule
</h2>
<c:if test="${param.error == 'validation'}"><div class="alert alert-danger">Check the plan, trainer, date, time, and capacity values.</div></c:if>
<c:if test="${param.error == 'past'}"><div class="alert alert-danger">The class start time must be in the future.</div></c:if>

<form action="${pageContext.request.contextPath}/schedule" method="post">
    <input type="hidden" name="action" value="${param.action == 'edit' ? 'update' : 'create'}">
    <c:if test="${param.action == 'edit'}">
        <input type="hidden" name="scheduleID" value="${schedule.scheduleID}">
    </c:if>

    <div class="mb-3">
        <label>Class Name</label>
        <input type="text" name="className" class="form-control" value="${schedule.className}" required>
    </div>

    <div class="mb-3">
        <label for="planType">Membership Plan</label>
        <select id="planType" name="planType" class="form-select" required>
            <option value="">Select eligible plan</option>
            <option value="Basic" ${schedule.planType == 'Basic' ? 'selected' : ''}>Basic</option>
            <option value="Premium" ${schedule.planType == 'Premium' ? 'selected' : ''}>Premium</option>
            <option value="Elite" ${schedule.planType == 'Elite' ? 'selected' : ''}>Elite</option>
        </select>
        <div class="form-text">Only active members on this plan can view and book the class.</div>
    </div>

    <div class="mb-3">
        <label for="trainerID">Trainer</label>
        <select id="trainerID" name="trainerID" class="form-select" required>
            <option value="">Select trainer</option>
            <c:forEach var="trainer" items="${trainers}">
                <option value="${trainer.userId}" ${schedule.trainerID == trainer.userId ? 'selected' : ''}>${trainer.fullName}</option>
            </c:forEach>
        </select>
    </div>

    <div class="mb-3">
        <label>Date</label>
        <input type="date" name="classDate" class="form-control" min="${today}" value="${schedule.classDate}" required>
    </div>

    <div class="mb-3">
        <label>Start Time</label>
        <input type="time" name="startTime" class="form-control" value="${schedule.startTime}" required>
    </div>

    <div class="mb-3">
        <label>End Time</label>
        <input type="time" name="endTime" class="form-control" value="${schedule.endTime}" required>
    </div>

    <div class="mb-3">
        <label>Capacity</label>
        <input type="number" name="capacity" class="form-control" min="1" value="${schedule.capacity}" required>
    </div>

    <button type="submit" class="btn btn-primary">Save</button>
    <a href="${pageContext.request.contextPath}/manager/scheduleList.jsp" class="btn btn-secondary">Cancel</a>
</form>

<%@ include file="/footer.jsp" %>
