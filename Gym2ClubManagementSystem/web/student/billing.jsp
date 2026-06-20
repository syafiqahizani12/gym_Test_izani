<%@ page pageEncoding="UTF-8" %>
<%@ include file="../headerS.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    com.lab.model.User user = (com.lab.model.User) session.getAttribute("user");
    com.lab.dao.BillingDAO dao = new com.lab.dao.BillingDAO();
    com.lab.model.Billing bill = dao.getPendingBillByStudentId(user.getUserId());
    request.setAttribute("bill", bill);
%>

<h2>Billing Details</h2>

<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>

<c:if test="${not empty bill}">
    <div class="card">
        <div class="card-body">
            <h4>Membership Bill</h4>
            <table class="table table-bordered">
                <tr><th>Bill ID</th><td>#${bill.billID}</td></tr>
                <tr><th>Amount</th><td><h3>RM ${bill.amount}</h3></td></tr>
                <tr><th>Due Date</th><td>${bill.dueDate}</td></tr>
                <tr><th>Status</th>
                    <td>
                        <c:choose>
                            <c:when test="${bill.status == 'Pending'}"><span class="badge bg-warning">Pending Payment</span></c:when>
                            <c:when test="${bill.status == 'Paid'}"><span class="badge bg-success">Paid</span></c:when>
                            <c:otherwise><span class="badge bg-danger">${bill.status}</span></c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </table>
            <c:if test="${bill.status == 'Pending'}">
                <form action="${pageContext.request.contextPath}/payment" method="post">
                    <input type="hidden" name="action" value="create">
                    <input type="hidden" name="billID" value="${bill.billID}">
                    <input type="hidden" name="amount" value="${bill.amount}">
                    <button type="submit" class="btn btn-primary">Proceed to Payment</button>
                    <a href="${pageContext.request.contextPath}/student/dashboard.jsp" class="btn btn-secondary">Cancel</a>
                </form>
            </c:if>
            <c:if test="${bill.status == 'Paid'}">
                <div class="alert alert-success">This bill has been paid.</div>
                <a href="${pageContext.request.contextPath}/student/dashboard.jsp" class="btn btn-primary">Go to Dashboard</a>
            </c:if>
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