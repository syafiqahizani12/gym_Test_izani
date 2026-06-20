<%@ page pageEncoding="UTF-8" %>
<%@ include file="/header.jsp" %>

<div class="alert alert-danger">
    <h4>Membership Not Active</h4>
    <p>Your membership is expired, suspended, or inactive. Active membership is required for check-in and class booking.</p>
    <a href="${pageContext.request.contextPath}/student/renewMembership.jsp" class="btn btn-primary">
        <i class="fa-solid fa-rotate-right"></i> Renew Membership
    </a>
    <a href="${pageContext.request.contextPath}/index.jsp#membership" class="btn btn-secondary">View Plans</a>
</div>

<%@ include file="/footer.jsp" %>
