<%-- 
    Document   : membershipDetails
    Created on : 19 Jun 2026
    Author     : ASUS
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ include file="/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    com.lab.dao.MembershipDAO dao = new com.lab.dao.MembershipDAO();
    com.lab.model.User user = (com.lab.model.User) session.getAttribute("user");
    // FIXED: Changed getUserID() to getUserId()
    com.lab.model.Membership m = dao.getMembershipByStudentId(user.getUserId());
    request.setAttribute("membership", m);
%>

<h2>My Membership</h2>
<c:choose>
    <c:when test="${not empty membership}">
        <table class="table table-bordered">
            <tr><th>Type</th><td>${membership.membershipType}</td></tr>
            <tr><th>Start Date</th><td>${membership.startDate}</td></tr>
            <tr><th>Expiry Date</th><td>${membership.expiryDate}</td></tr>
            <tr><th>Status</th><td>${membership.status}</td></tr>
        </table>
    </c:when>
    <c:otherwise><p>No membership found.</p></c:otherwise>
</c:choose>
<a href="${pageContext.request.contextPath}/student/dashboard.jsp" class="btn btn-secondary">Back</a>
<%@ include file="/footer.jsp" %>