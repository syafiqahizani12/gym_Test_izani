/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.lab.controller;

import com.lab.dao.AttendanceDAO;
import com.lab.model.Attendance;
import com.lab.dao.MembershipDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author DELL
 */
@WebServlet("/attendance")

public class AttendanceServlet extends HttpServlet {
private AttendanceDAO dao = new AttendanceDAO();
    private MembershipDAO memDao = new MembershipDAO();
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
            out.println("<title>Servlet AttendanceServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AttendanceServlet at " + request.getContextPath() + "</h1>");
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
  protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        AttendanceDAO dao = new AttendanceDAO();

        List<Attendance> attendanceList =
                dao.getAllAttendance();

        request.setAttribute("attendanceList", attendanceList);

        request.getRequestDispatcher(
                "trainer/trainer_attendance.jsp")
                .forward(request, response);

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
        if ("checkin".equals(action)) {
            int studentId = Integer.parseInt(request.getParameter("studentID"));
            int scheduleId = Integer.parseInt(request.getParameter("scheduleID"));
            if (!memDao.isActive(studentId)) {
                request.setAttribute("error", "Membership is not active.");
                request.getRequestDispatcher("views/student/dashboard.jsp").forward(request, response);
                return;
            }
            if (dao.checkIn(studentId, scheduleId)) {
                response.sendRedirect("views/student/attendanceList.jsp");
            } else {
                request.setAttribute("error", "Check-in failed.");
                request.getRequestDispatcher("views/student/dashboard.jsp").forward(request, response);
            }
        } else if ("checkout".equals(action)) {
            int attId = Integer.parseInt(request.getParameter("attendanceID"));
            dao.checkOut(attId);
            response.sendRedirect("views/student/attendanceList.jsp");
        } else if ("mark".equals(action)) {
            int scheduleId = Integer.parseInt(request.getParameter("scheduleID"));
            int studentId = Integer.parseInt(request.getParameter("studentID"));
            String status = request.getParameter("attendanceStatus");
            if (dao.markAttendanceByTrainer(scheduleId, studentId, status)) {
                response.sendRedirect("views/trainer/attendanceList.jsp");
            } else {
                request.setAttribute("error", "Cannot mark attendance (class not started or error).");
                request.getRequestDispatcher("views/trainer/attendanceForm.jsp").forward(request, response);
            }
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

