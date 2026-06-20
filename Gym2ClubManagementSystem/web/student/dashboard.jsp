<%-- 
    Document   : studentDashboard
    Created on : 19 Jun 2026
    Author     : ASUS
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ include file="/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    com.lab.dao.MembershipDAO memDao = new com.lab.dao.MembershipDAO();
    com.lab.model.User user = (com.lab.model.User) session.getAttribute("user");
    com.lab.model.Membership membership = memDao.getMembershipByStudentId(user.getUserId());
    request.setAttribute("membership", membership);
%>

<h2>Welcome, ${sessionScope.user.fullName}!</h2>

<c:choose>
    <c:when test="${not empty membership && membership.status == 'Active'}">
        <!-- Active Membership -->
        <div class="alert alert-success">
            <h4>✅ Active Membership</h4>
            <p><strong>Type:</strong> ${membership.membershipType}</p>
            <p><strong>Start Date:</strong> ${membership.startDate}</p>
            <p><strong>Expiry Date:</strong> ${membership.expiryDate}</p>
            <p><strong>Status:</strong> ${membership.status}</p>
        </div>
        
        <div class="row">
            <div class="col-md-3">
                <div class="card">
                    <div class="card-body">
                        <h5>📋 Schedules</h5>
                        <a href="${pageContext.request.contextPath}/student/scheduleList.jsp" class="btn btn-primary">View</a>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card">
                    <div class="card-body">
                        <h5>📖 My Bookings</h5>
                        <a href="${pageContext.request.contextPath}/student/bookingList.jsp" class="btn btn-primary">Manage</a>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card">
                    <div class="card-body">
                        <h5>✅ Attendance</h5>
                        <a href="${pageContext.request.contextPath}/student/attendanceList.jsp" class="btn btn-primary">View</a>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card">
                    <div class="card-body">
                        <h5>💳 Payment History</h5>
                        <a href="${pageContext.request.contextPath}/student/paymentHistory.jsp" class="btn btn-primary">View</a>
                    </div>
                </div>
            </div>
        </div>
    </c:when>

    <c:when test="${not empty membership && membership.status == 'Pending'}">
        <!-- Pending Membership -->
        <div class="alert alert-warning">
            <h4>⏳ Membership Pending Payment</h4>
            <p><strong>Plan:</strong> ${membership.membershipType}</p>
            <p><strong>Start Date:</strong> ${membership.startDate}</p>
            <p>Please complete your payment to activate your membership.</p>
            <a href="${pageContext.request.contextPath}/student/billing.jsp" class="btn btn-warning">Complete Payment</a>
        </div>
    </c:when>

    <c:otherwise>
        <!-- No Membership - Show Plans -->
        <div class="alert alert-info">
            <h4>🏋️ Choose Your Membership Plan</h4>
            <p>Select a plan below to get started with UniGym!</p>
        </div>

        <!-- Membership Plans -->
        <div class="row mt-4">
            <!-- BASIC PLAN -->
            <div class="col-lg-4">
                <div class="membership-card">
                    <h3>Basic</h3>
                    <div class="price">RM39<span>/month</span></div>
                    <ul>
                        <li>✅ Gym Access</li>
                        <li>✅ Attendance Tracking</li>
                        <li>✅ Locker Access</li>
                    </ul>
                    <form action="${pageContext.request.contextPath}/billing" method="post">
                        <input type="hidden" name="action" value="create">
                        <input type="hidden" name="plan" value="Basic">
                        <input type="hidden" name="amount" value="39.00">
                        <button type="submit" class="btn btn-plan">Join Now</button>
                    </form>
                </div>
            </div>

            <!-- PREMIUM PLAN -->
            <div class="col-lg-4">
                <div class="membership-card premium-card">
                    <div class="popular-badge">Popular</div>
                    <h3>Premium</h3>
                    <div class="price">RM79<span>/month</span></div>
                    <ul>
                        <li>✅ Unlimited Classes</li>
                        <li>✅ Trainer Sessions</li>
                        <li>✅ Priority Booking</li>
                    </ul>
                    <form action="${pageContext.request.contextPath}/billing" method="post">
                        <input type="hidden" name="action" value="create">
                        <input type="hidden" name="plan" value="Premium">
                        <input type="hidden" name="amount" value="79.00">
                        <button type="submit" class="btn btn-plan">Join Now</button>
                    </form>
                </div>
            </div>

            <!-- ELITE PLAN -->
            <div class="col-lg-4">
                <div class="membership-card">
                    <h3>Elite</h3>
                    <div class="price">RM129<span>/month</span></div>
                    <ul>
                        <li>✅ VIP Lounge</li>
                        <li>✅ Personal Trainer</li>
                        <li>✅ Full Facility Access</li>
                    </ul>
                    <form action="${pageContext.request.contextPath}/billing" method="post">
                        <input type="hidden" name="action" value="create">
                        <input type="hidden" name="plan" value="Elite">
                        <input type="hidden" name="amount" value="129.00">
                        <button type="submit" class="btn btn-plan">Join Now</button>
                    </form>
                </div>
            </div>
        </div>
    </c:otherwise>
</c:choose>

<%@ include file="/footer.jsp" %>