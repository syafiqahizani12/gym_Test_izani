<%@ page pageEncoding="UTF-8" %>
<%@ include file="/header.jsp" %>

<h2>Profile</h2>
<div class="card">
    <div class="card-body">
        <table class="table table-bordered">
            <tr><th>Name</th><td>${sessionScope.user.fullName}</td></tr>
            <tr><th>Email</th><td>${sessionScope.user.email}</td></tr>
            <tr><th>Phone</th><td>${sessionScope.user.phoneNumber}</td></tr>
            <tr><th>Role</th><td>${sessionScope.user.role}</td></tr>
        </table>
    </div>
</div>

<a href="${pageContext.request.contextPath}/trainer/dashboard.jsp" class="btn btn-secondary mt-3">Back</a>

<%@ include file="/footer.jsp" %>
