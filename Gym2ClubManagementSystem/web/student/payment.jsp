<%@ page pageEncoding="UTF-8" %>
<%@ include file="../headerS.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    com.lab.model.User user = (com.lab.model.User) session.getAttribute("user");
    com.lab.dao.BillingDAO dao = new com.lab.dao.BillingDAO();
    com.lab.model.Billing bill = dao.getPendingBillByStudentId(user.getUserId());
    request.setAttribute("bill", bill);
%>

<h2>Make Payment</h2>

<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>

<c:if test="${not empty bill}">
    <div class="card">
        <div class="card-body">
            <h4>Payment Details</h4>
            <table class="table table-bordered">
                <tr><th>Bill ID</th><td>#${bill.billID}</td></tr>
                <tr><th>Amount</th><td><h3>RM ${bill.amount}</h3></td></tr>
            </table>
            <form action="${pageContext.request.contextPath}/payment" method="post">
                <input type="hidden" name="action" value="process">
                <input type="hidden" name="billID" value="${bill.billID}">
                <input type="hidden" name="amount" value="${bill.amount}">
                <div class="mb-3">
                    <label>Payment Method</label>
                    <select name="paymentMethod" class="form-control" required>
                        <option value="">Select Payment Method</option>
                        <option value="Online Banking">Online Banking</option>
                        <option value="Credit Card">Credit Card</option>
                        <option value="Debit Card">Debit Card</option>
                        <option value="E-Wallet">E-Wallet</option>
                        <option value="Cash">Cash</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label>Card Number (demo)</label>
                    <input type="text" name="cardNumber" class="form-control" value="4111111111111111">
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label>Expiry Date</label>
                            <input type="month" name="expiryDate" class="form-control" value="2026-12">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label>CVV</label>
                            <input type="text" name="cvv" class="form-control" value="123" maxlength="4">
                        </div>
                    </div>
                </div>
                <button type="submit" class="btn btn-success btn-lg">Pay RM ${bill.amount}</button>
                <a href="${pageContext.request.contextPath}/student/billing.jsp" class="btn btn-secondary">Back</a>
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

<%@ include file="../footer.jsp" %>