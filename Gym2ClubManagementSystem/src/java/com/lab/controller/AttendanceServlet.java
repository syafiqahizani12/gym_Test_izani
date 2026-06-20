package com.lab.controller;

import com.lab.dao.AttendanceDAO;
import com.lab.dao.MembershipDAO;
import com.lab.model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/attendance")
public class AttendanceServlet extends HttpServlet {

    private final AttendanceDAO attendanceDao = new AttendanceDAO();
    private final MembershipDAO membershipDao = new MembershipDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/student/attendanceList.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        System.out.println("=== ATTENDANCE ACTION === " + action);

        if ("checkin".equals(action)) {
            checkIn(request, response);
        } else if ("checkout".equals(action)) {
            User user = currentUser(request);
            if (user == null) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
            int attendanceId = parseInt(request.getParameter("attendanceID"));
            attendanceDao.checkOut(attendanceId, user.getUserId());
            response.sendRedirect(request.getContextPath() + "/student/attendanceList.jsp");
        } else if ("mark".equals(action)) {
            markByTrainer(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp");
        }
    }

    private User currentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (User) session.getAttribute("user");
    }

    private void checkIn(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        User user = currentUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int scheduleId = parseInt(request.getParameter("scheduleID"));
        if (!membershipDao.isActive(user.getUserId())) {
            response.sendRedirect(request.getContextPath() + "/student/expired.jsp?reason=inactive");
            return;
        }

        AttendanceDAO.CheckInResult result = attendanceDao.checkIn(user.getUserId(), scheduleId);
        System.out.println("Student check-in userID=" + user.getUserId() + ", scheduleID=" + scheduleId + ", result=" + result);
        switch (result) {
            case SUCCESS:
                response.sendRedirect(request.getContextPath() + "/student/attendanceList.jsp?checkin=success"); break;
            case ALREADY_CHECKED_IN:
                response.sendRedirect(request.getContextPath() + "/student/checkIn.jsp?error=already"); break;
            case NOT_BOOKED:
                response.sendRedirect(request.getContextPath() + "/student/checkIn.jsp?error=booking"); break;
            case OUTSIDE_CLASS_TIME:
                response.sendRedirect(request.getContextPath() + "/student/checkIn.jsp?error=time"); break;
            default:
                response.sendRedirect(request.getContextPath() + "/student/checkIn.jsp?error=failed");
        }
    }

    private void markByTrainer(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        User trainer = currentUser(request);
        if (trainer == null) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
        if (!"Trainer".equals(trainer.getRole())) { response.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
        int scheduleId = parseInt(request.getParameter("scheduleID"));
        int studentId = parseInt(request.getParameter("studentID"));
        String status = request.getParameter("attendanceStatus");

        if (attendanceDao.markAttendanceByTrainer(scheduleId, studentId, trainer.getUserId(), status)) {
            response.sendRedirect(request.getContextPath() + "/trainer/attendanceList.jsp?mark=success");
        } else {
            request.setAttribute("error", "Attendance can only be marked during class time for a confirmed participant in your class.");
            request.getRequestDispatcher("/trainer/attendanceForm.jsp").forward(request, response);
        }
    }

    private int parseInt(String value) {
        try { return Integer.parseInt(value); } catch (Exception e) { return -1; }
    }
}
