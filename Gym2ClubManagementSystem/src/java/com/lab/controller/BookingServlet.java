package com.lab.controller;

import com.lab.dao.BookingDAO;
import com.lab.dao.MembershipDAO;
import com.lab.model.Booking;
import com.lab.model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/booking")
public class BookingServlet extends HttpServlet {

    private final BookingDAO bookingDao = new BookingDAO();
    private final MembershipDAO membershipDao = new MembershipDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("cancel".equals(action)) {
            handleCancel(request, response);
            return;
        }
        response.sendRedirect(request.getContextPath() + "/student/bookingList.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("create".equals(action)) {
            handleCreate(request, response);
            return;
        }
        response.sendRedirect(request.getContextPath() + "/student/scheduleList.jsp");
    }

    private User currentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (User) session.getAttribute("user");
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        User user = currentUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int studentId = user.getUserId();
        int scheduleId = Integer.parseInt(request.getParameter("scheduleID"));
        System.out.println("=== BOOKING CREATE === studentID=" + studentId + ", scheduleID=" + scheduleId);

        if (!membershipDao.isActive(studentId)) {
            response.sendRedirect(request.getContextPath() + "/student/expired.jsp?reason=inactive");
            return;
        }

        if (!bookingDao.isPlanEligible(studentId, scheduleId)) {
            response.sendRedirect(request.getContextPath() + "/student/scheduleList.jsp?error=plan");
            return;
        }

        if (bookingDao.isAlreadyBooked(studentId, scheduleId)) {
            response.sendRedirect(request.getContextPath() + "/student/scheduleList.jsp?error=duplicate");
            return;
        }

        if (bookingDao.isClassFull(scheduleId)) {
            response.sendRedirect(request.getContextPath() + "/student/scheduleList.jsp?error=full");
            return;
        }

        if (bookingDao.bookClass(studentId, scheduleId)) {
            response.sendRedirect(request.getContextPath() + "/student/bookingList.jsp?booking=success");
        } else {
            response.sendRedirect(request.getContextPath() + "/student/scheduleList.jsp?error=failed");
        }
    }

    private void handleCancel(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        User user = currentUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int bookingId = Integer.parseInt(request.getParameter("bookingID"));
        Booking booking = bookingDao.getBookingById(bookingId);
        System.out.println("=== BOOKING CANCEL === bookingID=" + bookingId + ", userID=" + user.getUserId());

        if (booking != null
                && booking.getStudentID() == user.getUserId()
                && "Confirmed".equalsIgnoreCase(booking.getBookingStatus())) {
            if (bookingDao.cancelBooking(bookingId)) {
                bookingDao.increaseCapacity(booking.getScheduleID());
            }
        }
        response.sendRedirect(request.getContextPath() + "/student/bookingList.jsp");
    }
}
