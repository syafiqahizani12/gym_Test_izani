<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<section class="plan-rules mt-4" aria-labelledby="planRulesTitle">
    <h3 id="planRulesTitle">${membership.membershipType} Plan Access</h3>
    <c:choose>
        <c:when test="${membership.membershipType == 'Basic'}">
            <p class="plan-price">RM39 / month</p>
            <h4>Included</h4>
            <ul class="feature-list allowed"><li>Gym check-in</li><li>View schedules</li><li>Book classes</li><li>View attendance</li><li>View membership</li></ul>
            <h4>Not included</h4>
            <ul class="feature-list denied"><li>Priority booking</li><li>Personal trainer</li></ul>
        </c:when>
        <c:when test="${membership.membershipType == 'Premium'}">
            <p class="plan-price">RM79 / month</p>
            <h4>Everything in Basic, plus</h4>
            <ul class="feature-list allowed"><li>Trainer sessions</li><li>Priority booking</li></ul>
            <h4>Not included</h4>
            <ul class="feature-list denied"><li>Personal trainer</li><li>VIP lounge</li></ul>
        </c:when>
        <c:when test="${membership.membershipType == 'Elite'}">
            <p class="plan-price">RM129 / month</p>
            <h4>Everything in Premium, plus</h4>
            <ul class="feature-list allowed"><li>Personal trainer</li><li>VIP lounge</li><li>Full facility access</li></ul>
        </c:when>
    </c:choose>
</section>
