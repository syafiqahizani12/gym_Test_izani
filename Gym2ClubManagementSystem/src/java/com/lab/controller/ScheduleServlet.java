/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.lab.controller;

import com.lab.dao.ScheduleDAO;
import com.lab.model.Schedule;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.Date;
import java.sql.Time;
import javax.servlet.annotation.WebServlet;

/**
 *
 * @author ASUS
 */
@WebServlet("/schedule")
public class ScheduleServlet extends HttpServlet {

    private ScheduleDAO dao = new ScheduleDAO();

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
            out.println("<title>Servlet ScheduleServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ScheduleServlet at " + request.getContextPath() + "</h1>");
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
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.deleteSchedule(id);
            response.sendRedirect("views/manager/scheduleList.jsp");
        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Schedule s = dao.getScheduleById(id);
            request.setAttribute("schedule", s);
            request.getRequestDispatcher("views/manager/scheduleForm.jsp").forward(request, response);
        } else {
            response.sendRedirect("views/manager/scheduleList.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        Schedule s = new Schedule();
        s.setClassName(request.getParameter("className"));
        s.setTrainerID(Integer.parseInt(request.getParameter("trainerID")));
        s.setClassDate(Date.valueOf(request.getParameter("classDate")));
        s.setStartTime(Time.valueOf(request.getParameter("startTime") + ":00"));
        s.setEndTime(Time.valueOf(request.getParameter("endTime") + ":00"));
        s.setCapacity(Integer.parseInt(request.getParameter("capacity")));

        if ("update".equals(action)) {
            s.setScheduleID(Integer.parseInt(request.getParameter("scheduleID")));
            dao.updateSchedule(s);
        } else {
            dao.createSchedule(s);
        }
        response.sendRedirect("views/manager/scheduleList.jsp");
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
