<%-- 
    Document   : membershipForm
    Created on : 20 Jun 2026, 10:25:01 am
    Author     : ASUS
--%>

<%-- 
    Document   : membershipForm
    Created on : 19 Jun 2026
    Author     : ASUS
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ include file="/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    com.lab.model.User user = (com.lab.model.User) session.getAttribute("user");
    com.lab.dao.MembershipDAO dao = new com.lab.dao.MembershipDAO();
    com.lab.model.Membership existing = dao.getMembershipByStudentId(user.getUserId());
    request.setAttribute("existing", existing);
%>

<h2>Add Membership</h2>

<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>

<c:if test="${not empty existing}">
    <div class="alert alert-warning">
        <strong>You already have a membership!</strong><br>
        Type: ${existing.membershipType}<br>
        Expiry Date: ${existing.expiryDate}<br>
        Status: ${existing.status}
    </div>
</c:if>

<c:if test="${empty existing}">
    <form action="${pageContext.request.contextPath}/membership" method="post">
        <input type="hidden" name="action" value="studentCreate">
        <input type="hidden" name="studentID" value="${sessionScope.user.userId}">

        <div class="mb-3">
            <label>Membership Type</label>
            <select name="membershipType" class="form-control" required>
                <option value="">Select Type</option>
                <option value="Monthly">Monthly</option>
                <option value="Yearly">Yearly</option>
            </select>
        </div>

        <div class="mb-3">
            <label>Start Date</label>
            <input type="date" name="startDate" class="form-control" required>
        </div>

        <div class="mb-3">
            <label>Expiry Date</label>
            <input type="date" name="expiryDate" class="form-control" required>
        </div>

        <div class="mb-3">
            <label>Status</label>
            <select name="status" class="form-control">
                <option value="Active">Active</option>
                <option value="Pending">Pending</option>
            </select>
        </div>

        <button type="submit" class="btn btn-primary">Submit Membership</button>
        <a href="${pageContext.request.contextPath}/student/dashboard.jsp" class="btn btn-secondary">Cancel</a>
    </form>
</c:if>

<%@ include file="/footer.jsp" %>
