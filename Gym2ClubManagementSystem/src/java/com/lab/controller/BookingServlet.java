/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.lab.controller;

import com.lab.dao.BookingDAO;
import com.lab.model.Booking;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.annotation.WebServlet;

/**
 *
 * @author ASUS
 */
@WebServlet("/booking")

public class BookingServlet extends HttpServlet {

    private BookingDAO dao = new BookingDAO();

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet BookingServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet BookingServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("create".equals(action)) {
            int studentId = Integer.parseInt(request.getParameter("studentID"));
            int scheduleId = Integer.parseInt(request.getParameter("scheduleID"));
            if (dao.isAlreadyBooked(studentId, scheduleId)) {
                request.setAttribute("error", "You already booked this class.");
                request.getRequestDispatcher("views/student/bookingForm.jsp").forward(request, response);
                return;
            }
            if (dao.isClassFull(scheduleId)) {
                request.setAttribute("error", "Class is full.");
                request.getRequestDispatcher("views/student/bookingForm.jsp").forward(request, response);
                return;
            }
            Booking b = new Booking();
            b.setStudentID(studentId);
            b.setScheduleID(scheduleId);
            b.setBookingStatus("Confirmed");
            if (dao.createBooking(b)) {
                dao.decreaseCapacity(scheduleId);
                response.sendRedirect("views/student/bookingList.jsp");
            } else {
                request.setAttribute("error", "Booking failed.");
                request.getRequestDispatcher("views/student/bookingForm.jsp").forward(request, response);
            }
        } else if ("cancel".equals(action)) {
            int bookingId = Integer.parseInt(request.getParameter("bookingID"));
            Booking b = dao.getBookingById(bookingId);
            if (b != null && "Confirmed".equals(b.getBookingStatus())) {
                dao.cancelBooking(bookingId);
                dao.increaseCapacity(b.getScheduleID());
            }
            response.sendRedirect("views/student/bookingList.jsp");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
