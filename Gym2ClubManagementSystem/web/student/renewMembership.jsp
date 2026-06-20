<%-- 
    Document   : renewMembership
    Created on : 19 Jun 2026
    Author     : ASUS
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ include file="../header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    com.lab.dao.MembershipDAO memDao = new com.lab.dao.MembershipDAO();
    com.lab.model.User user = (com.lab.model.User) session.getAttribute("user");
    com.lab.model.Membership membership = memDao.getMembershipByStudentId(user.getUserId());
    request.setAttribute("membership", membership);
%>

<h2>Renew Membership</h2>

<c:if test="${param.error == 'failed'}">
    <div class="alert alert-danger">Failed to renew membership. Please try again.</div>
</c:if>

<c:choose>
    <c:when test="${empty membership || membership.status != 'Active'}">
        <div class="alert alert-warning">
            <p>You don't have an active membership to renew.</p>
            <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary">View Plans</a>
        </div>
    </c:when>
    <c:otherwise>
        <div class="card">
            <div class="card-body">
                <h4>Current Membership</h4>
                <table class="table">
                    <tr><th>Type</th><td>${membership.membershipType}</td></tr>
                    <tr><th>Expiry Date</th><td>${membership.expiryDate}</td></tr>
                </table>
                
                <div class="alert alert-info">
                    <p>Renewing will extend your membership by 1 month.</p>
                </div>
                
                <form action="${pageContext.request.contextPath}/renew" method="post">
                    <button type="submit" class="btn btn-success">Renew Membership</button>
                    <a href="${pageContext.request.contextPath}/student/dashboard.jsp" class="btn btn-secondary">Cancel</a>
                </form>
            </div>
        </div>
    </c:otherwise>
</c:choose>

<%@ include file="../footer.jsp" %>