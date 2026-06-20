/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.lab.controller;

import com.lab.dao.MembershipDAO;
import com.lab.model.Membership;
import java.sql.Date;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author ASUS
 */
@WebServlet("/membership")

public class MembershipServlet extends HttpServlet {

    private MembershipDAO dao = new MembershipDAO();


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
            out.println("<title>Servlet MembershipServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet MembershipServlet at " + request.getContextPath() + "</h1>");
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
        // NO MORE EDIT/DELETE FOR MANAGER
        // Only redirect to dashboard
        response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("studentCreate".equals(action)) {
            // Student creates their own membership
            Membership m = new Membership();
            m.setStudentID(Integer.parseInt(request.getParameter("studentID")));
            m.setMembershipType(request.getParameter("membershipType"));
            m.setStartDate(Date.valueOf(request.getParameter("startDate")));
            m.setExpiryDate(Date.valueOf(request.getParameter("expiryDate")));
            m.setStatus(request.getParameter("status"));

            // Check if student already has a membership
            Membership existing = dao.getMembershipByStudentId(m.getStudentID());
            if (existing != null) {
                request.setAttribute("error", "You already have a membership!");
                request.getRequestDispatcher("/student/membershipForm.jsp").forward(request, response);
                return;
            }

            boolean created = dao.createMembership(m);
            if (created) {
                response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp?membership=success");
            } else {
                request.setAttribute("error", "Failed to create membership.");
                request.getRequestDispatcher("/student/membershipForm.jsp").forward(request, response);
            }
        } else {
            // No other actions allowed
            response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp");
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
