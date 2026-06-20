<%@ page pageEncoding="UTF-8" %>
<%@ include file="/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    com.lab.model.User user = (com.lab.model.User) session.getAttribute("user");
    com.lab.dao.BillingDAO dao = new com.lab.dao.BillingDAO();
    com.lab.model.Billing bill = dao.getPendingBillByStudentId(user.getUserId());
    request.setAttribute("bill", bill);
%>

<h2>Make Payment</h2>
<c:if test="${param.notice == 'pending'}"><div class="alert alert-info">Complete the existing pending payment before creating another plan request.</div></c:if>

<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>

<c:if test="${not empty bill}">
    <div class="card">
        <div class="card-body">
            <h4>Payment Details</h4>
            <table class="table table-bordered">
                <tr><th>Bill ID</th><td>#${bill.billID}</td></tr>
                <tr><th>Requested Plan</th><td>${bill.planType}</td></tr>
                <tr><th>Amount</th><td><h3>RM ${bill.amount}</h3></td></tr>
            </table>
            <div class="text-center mb-4">
                <p class="mb-2">Scan the QR that matches your selected plan and amount.</p>
                <c:choose>
                    <c:when test="${bill.amount == 39}"><img class="payment-qr" src="${pageContext.request.contextPath}/images/qr-basic-rm39.png" alt="Basic plan payment QR for RM39"></c:when>
                    <c:when test="${bill.amount == 79}"><img class="payment-qr" src="${pageContext.request.contextPath}/images/qr-premium-rm79.png" alt="Premium plan payment QR for RM79"></c:when>
                    <c:when test="${bill.amount == 129}"><img class="payment-qr" src="${pageContext.request.contextPath}/images/qr-elite-rm129.png" alt="Elite plan payment QR for RM129"></c:when>
                </c:choose>
            </div>
            <form action="${pageContext.request.contextPath}/payment" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="process">
                <input type="hidden" name="billID" value="${bill.billID}">
                <div class="mb-3">
                    <label for="transactionProof" class="form-label">Transaction proof</label>
                    <input id="transactionProof" type="file" name="transactionProof" class="form-control" accept="image/jpeg,image/png,application/pdf" required>
                    <div class="form-text">JPG, PNG, or PDF. Maximum 5 MB.</div>
                </div>
                <button type="submit" class="btn btn-success btn-lg"><i class="fa-solid fa-upload"></i> Submit Proof</button>
            </form>
        </div>
    </div>
</c:if>

<c:if test="${empty bill}">
    <div class="alert alert-info">
        <p>No pending bill found.</p>
        <a href="${pageContext.request.contextPath}/student/dashboard.jsp" class="btn btn-primary">Back to Dashboard</a>
    </div>
</c:if>

<%@ include file="/footer.jsp" %>
