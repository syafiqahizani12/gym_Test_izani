<%@ page pageEncoding="UTF-8" %>
<%@ include file="/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    com.lab.model.User user = (com.lab.model.User) session.getAttribute("user");
    com.lab.model.Membership membership = new com.lab.dao.MembershipDAO().getMembershipByStudentId(user.getUserId());
    request.setAttribute("membership", membership);
%>

<header class="member-dashboard-header">
    <div>
        <p class="dashboard-eyebrow">Member dashboard</p>
        <h1>Welcome back, ${sessionScope.user.fullName}</h1>
        <p>Manage today’s gym activity and your membership from one place.</p>
    </div>
    <a href="${pageContext.request.contextPath}/student/profile.jsp" class="btn btn-secondary"><i class="fa-solid fa-user"></i> Profile</a>
</header>

<c:choose>
    <c:when test="${not empty membership && membership.status == 'Active'}">
        <c:if test="${membership.expiringSoon}">
            <div class="alert alert-warning expiry-reminder" role="alert">
                <i class="fa-solid fa-clock"></i>
                <div>
                    <strong>Your membership expires in ${membership.daysUntilExpiry} day${membership.daysUntilExpiry == 1 ? '' : 's'}.</strong>
                    <span>Renew now to keep your bookings and gym access uninterrupted.</span>
                </div>
                <a href="${pageContext.request.contextPath}/student/renewMembership.jsp" class="btn btn-warning">Renew Membership</a>
            </div>
        </c:if>

        <section class="membership-summary" aria-label="Membership summary">
            <div>
                <span class="summary-label">Current plan</span>
                <strong>${membership.membershipType}</strong>
            </div>
            <div>
                <span class="summary-label">Status</span>
                <strong class="status-active"><i class="fa-solid fa-circle-check"></i> Active</strong>
            </div>
            <div>
                <span class="summary-label">Valid until</span>
                <strong>${membership.expiryDate}</strong>
            </div>
            <div class="summary-action">
                <a href="${pageContext.request.contextPath}/student/membershipDetails.jsp" class="btn btn-outline-success">Membership Details</a>
            </div>
        </section>

        <section class="dashboard-section" aria-labelledby="quickActionsTitle">
            <div class="section-heading">
                <div><h2 id="quickActionsTitle">Quick Actions</h2><p>Your most-used member tools.</p></div>
            </div>
            <div class="dashboard-actions-grid">
                <a class="dashboard-action" href="${pageContext.request.contextPath}/student/checkIn.jsp">
                    <i class="fa-solid fa-right-to-bracket"></i><span><strong>Check In</strong><small>Use a confirmed class booking</small></span><i class="fa-solid fa-chevron-right"></i>
                </a>
                <a class="dashboard-action" href="${pageContext.request.contextPath}/student/scheduleList.jsp">
                    <i class="fa-solid fa-calendar-days"></i><span><strong>Find a Class</strong><small>Browse ${membership.membershipType} schedules</small></span><i class="fa-solid fa-chevron-right"></i>
                </a>
                <a class="dashboard-action" href="${pageContext.request.contextPath}/student/bookingList.jsp">
                    <i class="fa-solid fa-bookmark"></i><span><strong>My Bookings</strong><small>Review or cancel classes</small></span><i class="fa-solid fa-chevron-right"></i>
                </a>
                <a class="dashboard-action" href="${pageContext.request.contextPath}/student/attendanceList.jsp">
                    <i class="fa-solid fa-list-check"></i><span><strong>Attendance</strong><small>View your check-in history</small></span><i class="fa-solid fa-chevron-right"></i>
                </a>
            </div>
        </section>

        <div class="dashboard-detail-grid">
            <%@ include file="/student/planRules.jsp" %>
            <section class="account-links" aria-labelledby="accountTitle">
                <h3 id="accountTitle">Account</h3>
                <a href="${pageContext.request.contextPath}/student/paymentHistory.jsp"><i class="fa-solid fa-receipt"></i><span>Payment history</span><i class="fa-solid fa-chevron-right"></i></a>
                <a href="${pageContext.request.contextPath}/student/renewMembership.jsp"><i class="fa-solid fa-rotate"></i><span>Renew membership</span><i class="fa-solid fa-chevron-right"></i></a>
                <a href="${pageContext.request.contextPath}/student/changePlan.jsp"><i class="fa-solid fa-arrow-right-arrow-left"></i><span>Change membership plan</span><i class="fa-solid fa-chevron-right"></i></a>
                <a href="${pageContext.request.contextPath}/student/profile.jsp"><i class="fa-solid fa-user-gear"></i><span>Profile settings</span><i class="fa-solid fa-chevron-right"></i></a>
            </section>
        </div>
    </c:when>

    <c:when test="${not empty membership && membership.status == 'Pending'}">
        <section class="dashboard-state">
            <i class="fa-solid fa-hourglass-half"></i>
            <h2>Membership awaiting approval</h2>
            <p>Your ${membership.membershipType} plan becomes active after your payment proof is approved.</p>
            <a href="${pageContext.request.contextPath}/student/payment.jsp" class="btn btn-primary"><i class="fa-solid fa-qrcode"></i> Open Payment</a>
        </section>
    </c:when>

    <c:otherwise>
        <section class="dashboard-state">
            <i class="fa-solid fa-id-card"></i>
            <h2>No active membership</h2>
            <p>Choose a membership plan to access schedules, bookings, and check-in.</p>
            <a href="${pageContext.request.contextPath}/index.jsp#membership" class="btn btn-primary">View Membership Plans</a>
        </section>
    </c:otherwise>
</c:choose>

<%@ include file="/footer.jsp" %>
