<%@ page pageEncoding="UTF-8" %>
<%@ include file="/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${param.proof == 'submitted'}"><div class="alert alert-success">Transaction proof submitted successfully.</div></c:if>
<c:if test="${param.proof == 'alreadySubmitted'}"><div class="alert alert-info">Your transaction proof is already waiting for manager review.</div></c:if>
<div class="alert alert-warning">
    <h4>Membership Pending</h4>
    <p>Your membership is waiting for payment proof review. It becomes active after a manager approves the transaction.</p>
    <a href="${pageContext.request.contextPath}/student/payment.jsp" class="btn btn-warning">
        <i class="fa-solid fa-qrcode"></i> Payment Page
    </a>
    <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary">Logout</a>
</div>

<%@ include file="/footer.jsp" %>
