<%@ page pageEncoding="UTF-8" %>
<%@ include file="/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    com.lab.model.User user = (com.lab.model.User) session.getAttribute("user");
    com.lab.dao.PaymentDAO paymentDao = new com.lab.dao.PaymentDAO();
    request.setAttribute("payments", paymentDao.getPaymentsByStudentId(user.getUserId()));
%>

<h2>Payment History</h2>

<div class="table-responsive">
    <table class="table table-striped">
        <thead>
            <tr>
                <th>Payment ID</th>
                <th>Bill ID</th>
                <th>Date</th>
                <th>Method</th>
                <th>Amount</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="payment" items="${payments}">
                <tr>
                    <td>${payment.paymentID}</td>
                    <td>${payment.billID}</td>
                    <td>${payment.paymentDate}</td>
                    <td>${payment.paymentMethod}</td>
                    <td>RM ${payment.amount}</td>
                    <td><span class="badge ${payment.status == 'Approved' ? 'bg-success' : payment.status == 'Rejected' ? 'bg-danger' : 'bg-warning text-dark'}">${payment.status}</span></td>
                </tr>
            </c:forEach>
            <c:if test="${empty payments}">
                <tr>
                    <td colspan="6" class="text-center text-muted">No payments yet.</td>
                </tr>
            </c:if>
        </tbody>
    </table>
</div>

<a href="${pageContext.request.contextPath}/student/dashboard.jsp" class="btn btn-secondary">Back</a>

<%@ include file="/footer.jsp" %>
