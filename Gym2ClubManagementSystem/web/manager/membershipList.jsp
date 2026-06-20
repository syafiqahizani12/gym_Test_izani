<%-- 
    Document   : membershipList
    Created on : 19 Jun 2026
    Author     : ASUS
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ include file="/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    com.lab.dao.MembershipDAO dao = new com.lab.dao.MembershipDAO();
    request.setAttribute("memberships", dao.getAllMemberships());
%>

<h2>Membership List</h2>

<c:if test="${param.approved == 'true'}">
    <div class="alert alert-success">Membership approved.</div>
</c:if>

<table class="table table-striped">
    <thead>
        <tr>
            <th>ID</th>
            <th>Student</th>
            <th>Type</th>
            <th>Start</th>
            <th>Expiry</th>
            <th>Status</th>
            <th>Action</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="m" items="${memberships}">
            <tr>
                <td>${m.membershipID}</td>
                <td>${m.studentName}</td>
                <td>${m.membershipType}</td>
                <td>${m.startDate}</td>
                <td>${m.expiryDate}</td>
                <td>${m.status}</td>
                <td>
                    <c:choose>
                        <c:when test="${m.status == 'Pending'}"><a class="btn btn-sm btn-success" href="${pageContext.request.contextPath}/manager/view_payments.jsp"><i class="fa-solid fa-receipt"></i> Review Payment</a></c:when>
                        <c:otherwise><span class="text-muted">Read-only</span></c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>

<a href="${pageContext.request.contextPath}/manager/dashboard.jsp" class="btn btn-secondary">Back</a>

<%@ include file="/footer.jsp" %>
