<%-- 
    Document   : scheduleForm
    Created on : 19 Jun 2026, 9:47:50 pm
    Author     : ASUS
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ include file="../header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h2>
    <c:choose>
        <c:when test="${param.action == 'edit'}">Edit</c:when>
        <c:otherwise>Add</c:otherwise>
    </c:choose>
    Schedule
</h2>

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
        <label>Trainer ID</label>
        <input type="number" name="trainerID" class="form-control" value="${schedule.trainerID}" required>
    </div>

    <div class="mb-3">
        <label>Date</label>
        <input type="date" name="classDate" class="form-control" value="${schedule.classDate}" required>
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
        <input type="number" name="capacity" class="form-control" value="${schedule.capacity}" required>
    </div>

    <button type="submit" class="btn btn-primary">Save</button>
    <a href="${pageContext.request.contextPath}/manager/scheduleList.jsp" class="btn btn-secondary">Cancel</a>
</form>

<%@ include file="/footer.jsp" %>