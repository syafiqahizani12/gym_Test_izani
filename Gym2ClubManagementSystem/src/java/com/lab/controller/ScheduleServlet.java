/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.lab.controller;

import com.lab.dao.ScheduleDAO;
import com.lab.model.Schedule;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDateTime;
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
            response.sendRedirect(request.getContextPath() + "/manager/scheduleList.jsp");
        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Schedule s = dao.getScheduleById(id);
            request.setAttribute("schedule", s);
            request.getRequestDispatcher("/manager/scheduleForm.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/manager/scheduleList.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            Schedule s = new Schedule();
            s.setClassName(request.getParameter("className").trim());
            s.setTrainerID(Integer.parseInt(request.getParameter("trainerID")));
            s.setClassDate(Date.valueOf(request.getParameter("classDate")));
            s.setStartTime(toSqlTime(request.getParameter("startTime")));
            s.setEndTime(toSqlTime(request.getParameter("endTime")));
            s.setCapacity(Integer.parseInt(request.getParameter("capacity")));
            s.setPlanType(request.getParameter("planType"));
            if (s.getClassName().isEmpty() || s.getCapacity() < 1 || !s.getEndTime().after(s.getStartTime())
                    || !("Basic".equals(s.getPlanType()) || "Premium".equals(s.getPlanType()) || "Elite".equals(s.getPlanType()))) {
                throw new IllegalArgumentException("Invalid schedule values");
            }
            LocalDateTime classStart = LocalDateTime.of(s.getClassDate().toLocalDate(), s.getStartTime().toLocalTime());
            if (!classStart.isAfter(LocalDateTime.now())) {
                System.out.println("=== SCHEDULE REJECTED === class start is in the past: " + classStart);
                response.sendRedirect(request.getContextPath() + "/manager/scheduleForm.jsp?error=past");
                return;
            }
            boolean saved;
            if ("update".equals(action)) {
                s.setScheduleID(Integer.parseInt(request.getParameter("scheduleID")));
                saved = dao.updateSchedule(s);
            } else {
                saved = dao.createSchedule(s);
            }
            System.out.println("=== SCHEDULE SAVE === action=" + action + ", class=" + s.getClassName() + ", success=" + saved);
            response.sendRedirect(request.getContextPath() + "/manager/scheduleList.jsp?result=" + (saved ? "saved" : "failed"));
        } catch (IllegalArgumentException e) {
            System.out.println("=== SCHEDULE VALIDATION FAILED === " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/manager/scheduleForm.jsp?error=validation");
        }
    }

    private Time toSqlTime(String value) {
        return Time.valueOf(value.length() == 5 ? value + ":00" : value);
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
