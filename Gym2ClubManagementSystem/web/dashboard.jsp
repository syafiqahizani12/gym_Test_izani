<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:choose>
    <c:when test="${sessionScope.user.role == 'Member'}">
        <c:redirect url="/student/dashboard.jsp" />
    </c:when>
    <c:when test="${sessionScope.user.role == 'Trainer'}">
        <c:redirect url="/trainer/dashboard.jsp" />
    </c:when>
    <c:when test="${sessionScope.user.role == 'Manager'}">
        <c:redirect url="/manager/dashboard.jsp" />
    </c:when>
    <c:otherwise>
        <c:redirect url="/login.jsp" />
    </c:otherwise>
</c:choose>
