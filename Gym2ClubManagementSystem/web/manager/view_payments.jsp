<%@ page pageEncoding="UTF-8" %>
<%@ include file="/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    com.lab.dao.PaymentDAO paymentDao = new com.lab.dao.PaymentDAO();
    request.setAttribute("payments", paymentDao.getAllPayments());
%>

<h2>Payment Records</h2>
<c:if test="${param.result == 'approved'}"><div class="alert alert-success">Payment approved and membership activated.</div></c:if>
<c:if test="${param.result == 'rejected'}"><div class="alert alert-warning">Payment proof rejected.</div></c:if>
<c:if test="${param.result == 'failed'}"><div class="alert alert-danger">The payment could not be updated.</div></c:if>

<div class="table-responsive">
    <table class="table table-striped align-middle">
        <thead>
            <tr>
                <th>Payment ID</th>
                <th>Member</th>
                <th>Plan</th>
                <th>Date</th>
                <th>Method</th>
                <th>Amount</th>
                <th>Status</th>
                <th>Proof</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="payment" items="${payments}">
                <tr>
                    <td>${payment.paymentID}</td>
                    <td>${payment.studentName}</td>
                    <td>${payment.planType}</td>
                    <td>${payment.paymentDate}</td>
                    <td>${payment.paymentMethod}</td>
                    <td>RM ${payment.amount}</td>
                    <td><span class="badge ${payment.status == 'Approved' ? 'bg-success' : payment.status == 'Rejected' ? 'bg-danger' : 'bg-warning text-dark'}">${payment.status}</span></td>
                    <td><a class="btn btn-sm btn-outline-light" target="_blank" href="${pageContext.request.contextPath}/payment-proof?id=${payment.paymentID}"><i class="fa-solid fa-file-arrow-up"></i> View</a></td>
                    <td>
                        <c:if test="${payment.status == 'Pending'}">
                            <form class="d-inline" action="${pageContext.request.contextPath}/payment" method="post">
                                <input type="hidden" name="action" value="approve"><input type="hidden" name="paymentID" value="${payment.paymentID}">
                                <button class="btn btn-sm btn-success" type="submit"><i class="fa-solid fa-check"></i> Approve</button>
                            </form>
                            <form class="d-inline" action="${pageContext.request.contextPath}/payment" method="post">
                                <input type="hidden" name="action" value="reject"><input type="hidden" name="paymentID" value="${payment.paymentID}">
                                <button class="btn btn-sm btn-danger" type="submit"><i class="fa-solid fa-xmark"></i> Reject</button>
                            </form>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty payments}">
                <tr>
                    <td colspan="9" class="text-center text-muted">No payment records found.</td>
                </tr>
            </c:if>
        </tbody>
    </table>
</div>

<a href="${pageContext.request.contextPath}/manager/dashboard.jsp" class="btn btn-secondary">Back</a>

<%@ include file="/footer.jsp" %>
