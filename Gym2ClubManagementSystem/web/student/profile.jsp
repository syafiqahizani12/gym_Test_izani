<%@ page pageEncoding="UTF-8" %>
<%@ include file="/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="page-heading">
    <div><h2>My Profile</h2><p>Keep your contact details up to date.</p></div>
</div>

<c:if test="${param.updated == 'true'}"><div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Profile updated successfully.</div></c:if>
<c:if test="${param.error == 'validation'}"><div class="alert alert-danger">Enter a valid name, email address, and phone number.</div></c:if>
<c:if test="${param.error == 'email'}"><div class="alert alert-danger">That email address is already used by another account.</div></c:if>
<c:if test="${param.error == 'failed'}"><div class="alert alert-danger">Profile update failed. Please try again.</div></c:if>

<form action="${pageContext.request.contextPath}/profile" method="post" class="profile-form">
    <div class="mb-3">
        <label for="fullName" class="form-label">Full Name</label>
        <input id="fullName" name="fullName" type="text" class="form-control" maxlength="100" value="${sessionScope.user.fullName}" required>
    </div>
    <div class="mb-3">
        <label for="email" class="form-label">Email Address</label>
        <input id="email" name="email" type="email" class="form-control" maxlength="100" value="${sessionScope.user.email}" required>
    </div>
    <div class="mb-3">
        <label for="phone" class="form-label">Phone Number</label>
        <input id="phone" name="phone" type="tel" class="form-control" maxlength="20" pattern="[0-9+() -]{7,20}" value="${sessionScope.user.phoneNumber}" required>
    </div>
    <div class="mb-4">
        <label class="form-label">Role</label>
        <input type="text" class="form-control" value="${sessionScope.user.role}" disabled>
    </div>
    <button type="submit" class="btn btn-primary"><i class="fa-solid fa-floppy-disk"></i> Save Changes</button>
    <a href="${pageContext.request.contextPath}/student/dashboard.jsp" class="btn btn-secondary">Cancel</a>
</form>

<%@ include file="/footer.jsp" %>
