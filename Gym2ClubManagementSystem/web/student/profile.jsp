<%-- 
    Document   : profile
    Created on : 19 Jun 2026
    Author     : ASUS
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ include file="../header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    com.lab.model.User user = (com.lab.model.User) session.getAttribute("user");
%>

<h2>My Profile</h2>

<div class="card">
    <div class="card-body">
        <h4>Personal Information</h4>
        <table class="table">
            <tr>
                <th>Full Name</th>
                <td>${sessionScope.user.fullName}</td>
            </tr>
            <tr>
                <th>Email</th>
                <td>${sessionScope.user.email}</td>
            </tr>
            <tr>
                <th>Phone</th>
                <td>${sessionScope.user.phoneNumber}</td>
            </tr>
            <tr>
                <th>Role</th>
                <td>${sessionScope.user.role}</td>
            </tr>
        </table>
    </div>
</div>

<a href="${pageContext.request.contextPath}/student/dashboard.jsp" class="btn btn-secondary mt-3">Back</a>

<%@ include file="../footer.jsp" %>