<%@ page pageEncoding="UTF-8" %>
<%@ include file="/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    com.lab.model.User user = (com.lab.model.User) session.getAttribute("user");
    request.setAttribute("membership", new com.lab.dao.MembershipDAO().getMembershipByStudentId(user.getUserId()));
    request.setAttribute("pendingBill", new com.lab.dao.BillingDAO().getPendingBillByStudentId(user.getUserId()));
%>

<div class="page-heading">
    <div><h2>Change Membership Plan</h2><p>Your current plan remains active until the new payment is approved.</p></div>
    <c:if test="${not empty membership}"><span class="plan-tier plan-tier-${membership.membershipType.toLowerCase()}">Current: ${membership.membershipType}</span></c:if>
</div>

<c:if test="${param.error == 'same'}"><div class="alert alert-info">You already use that membership plan.</div></c:if>
<c:if test="${param.error == 'inactive'}"><div class="alert alert-warning">An active membership is required before changing plans.</div></c:if>
<c:if test="${not empty pendingBill}">
    <div class="alert alert-warning">
        <div><strong>${pendingBill.planType} plan change awaiting payment.</strong> Complete or resubmit payment proof before requesting another change.</div>
        <a href="${pageContext.request.contextPath}/student/payment.jsp" class="btn btn-warning">Continue Payment</a>
    </div>
</c:if>

<div class="plan-change-grid">
    <section class="plan-choice">
        <h3>Basic</h3><p class="plan-choice-price">RM39 <span>/ month</span></p>
        <ul><li>Gym check-in</li><li>Class booking</li><li>Attendance history</li></ul>
        <form action="${pageContext.request.contextPath}/billing" method="post">
            <input type="hidden" name="action" value="changePlan"><input type="hidden" name="plan" value="Basic">
            <button class="btn btn-plan" type="submit" ${membership.membershipType == 'Basic' || not empty pendingBill ? 'disabled' : ''}>${membership.membershipType == 'Basic' ? 'Current Plan' : 'Choose Basic'}</button>
        </form>
    </section>
    <section class="plan-choice featured">
        <h3>Premium</h3><p class="plan-choice-price">RM79 <span>/ month</span></p>
        <ul><li>Everything in Basic</li><li>Trainer sessions</li><li>Priority booking</li></ul>
        <form action="${pageContext.request.contextPath}/billing" method="post">
            <input type="hidden" name="action" value="changePlan"><input type="hidden" name="plan" value="Premium">
            <button class="btn btn-plan" type="submit" ${membership.membershipType == 'Premium' || not empty pendingBill ? 'disabled' : ''}>${membership.membershipType == 'Premium' ? 'Current Plan' : 'Choose Premium'}</button>
        </form>
    </section>
    <section class="plan-choice">
        <h3>Elite</h3><p class="plan-choice-price">RM129 <span>/ month</span></p>
        <ul><li>Everything in Premium</li><li>Personal trainer</li><li>VIP and full facility access</li></ul>
        <form action="${pageContext.request.contextPath}/billing" method="post">
            <input type="hidden" name="action" value="changePlan"><input type="hidden" name="plan" value="Elite">
            <button class="btn btn-plan" type="submit" ${membership.membershipType == 'Elite' || not empty pendingBill ? 'disabled' : ''}>${membership.membershipType == 'Elite' ? 'Current Plan' : 'Choose Elite'}</button>
        </form>
    </section>
</div>
<a href="${pageContext.request.contextPath}/student/membershipDetails.jsp" class="btn btn-secondary mt-4">Back to Membership</a>
<%@ include file="/footer.jsp" %>
