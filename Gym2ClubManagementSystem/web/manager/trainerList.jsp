<%@ page pageEncoding="UTF-8" %>
<%@ include file="/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    com.lab.dao.UserDAO userDao = new com.lab.dao.UserDAO();
    request.setAttribute("trainers", userDao.getUsersByRole("Trainer"));
%>

<h2>Trainer Management</h2>

<div class="card mb-4">
    <div class="card-body">
        <h5>Add Trainer</h5>
        <form action="${pageContext.request.contextPath}/trainer-management" method="post" class="row g-3">
            <input type="hidden" name="action" value="add">
            <div class="col-md-3">
                <label class="form-label">Full Name</label>
                <input type="text" name="fullName" class="form-control" required>
            </div>
            <div class="col-md-3">
                <label class="form-label">Email</label>
                <input type="email" name="email" class="form-control" required>
            </div>
            <div class="col-md-2">
                <label class="form-label">Phone</label>
                <input type="text" name="phone" class="form-control" required>
            </div>
            <div class="col-md-2">
                <label class="form-label">Password</label>
                <input type="password" name="password" class="form-control" required minlength="6">
            </div>
            <div class="col-md-2 d-flex align-items-end">
                <button type="submit" class="btn btn-primary w-100">
                    <i class="fa-solid fa-plus"></i> Add
                </button>
            </div>
        </form>
    </div>
</div>

<div class="table-responsive">
    <table class="table table-striped align-middle">
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="trainer" items="${trainers}">
                <tr>
                    <td>${trainer.userId}</td>
                    <td>${trainer.fullName}</td>
                    <td>${trainer.email}</td>
                    <td>${trainer.phoneNumber}</td>
                    <td>
                        <form action="${pageContext.request.contextPath}/trainer-management" method="post" class="d-inline">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="trainerID" value="${trainer.userId}">
                            <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Delete trainer?')">
                                <i class="fa-solid fa-trash"></i> Delete
                            </button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<a href="${pageContext.request.contextPath}/manager/dashboard.jsp" class="btn btn-secondary">Back</a>

<%@ include file="/footer.jsp" %>
