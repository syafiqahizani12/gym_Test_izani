<%-- 
    Document   : dashboard
    Created on : 26 May 2026, 4:19:41 pm
    Author     : DELL
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Campus Fitness | Attendance Dashboard</title>
    <link rel="stylesheet" href="css/dashboard.css">
</head>
<body>

    <%@ include file="header_user.jsp" %>

    <div class="hero-container">
        <div class="hero-text-side">
            <span class="badge">MEMBERSHIP</span>
            <h1>GET YOUR STAR<br><span class="accent">POWER ON</span></h1>
            <p>University Gym Portal. Live tracking logs tailored to your facility, your schedules, and your pace.</p>
            <button class="outline-btn">VIEW SYSTEM SCHEDULER &rarr;</button>
        </div>
        
        <div class="hero-stats-side">
            <div class="table-container">
                <h3>LIVE ATTENDANCE LOG</h3>
                <table>
                    <thead>
                        <tr>
                            <th>Student ID</th>
                            <th>Student Name</th>
                            <th>Check In Time</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="log" items="${attendanceList}">
                            <tr>
                                <td><c:out value="${log.studentId}"/></td>
                                <td class="highlight-name"><c:out value="${log.studentName}"/></td>
                                <td><c:out value="${log.checkInTime}"/></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div id="checkInModal" class="modal-overlay">
        <div class="modal-box">
            <span class="close-btn" onclick="closeModal()">&times;</span>
            <h2>TRY US <span class="accent-text">FOR FREE</span></h2>
            <p class="subtitle">Quick swipe alternative validation system.</p>
            
            <form action="dashboard" method="POST">
                <div class="form-group">
                    <label>STUDENT MATRIX ID</label>
                    <input type="text" name="studentId" placeholder="e.g. SU10245" required>
                </div>
                <div class="form-group">
                    <label>FULL STUDENT NAME</label>
                    <input type="text" name="studentName" placeholder="e.g. Adam Haikal" required>
                </div>
                <button type="submit" class="submit-btn">SUBMIT &rarr;</button>
            </form>
        </div>
    </div>

    <script>
        function openModal() {
            document.getElementById("checkInModal").style.display = "flex";
        }
        function closeModal() {
            document.getElementById("checkInModal").style.display = "none";
        }
        window.onclick = function(e) {
            var modal = document.getElementById("checkInModal");
            if (e.target == modal) {
                modal.style.display = "none";
            }
        }
    </script>
</body>
</html>