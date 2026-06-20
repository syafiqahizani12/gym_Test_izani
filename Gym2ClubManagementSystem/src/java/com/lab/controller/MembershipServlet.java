package com.lab.controller;

import com.lab.model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/membership")
public class MembershipServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        System.out.println("=== MEMBERSHIP ACTION === " + action);

        if ("approve".equals(action)) {
            HttpSession session = request.getSession(false);
            User user = session == null ? null : (User) session.getAttribute("user");
            if (user == null || !"Manager".equalsIgnoreCase(user.getRole())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Managers only");
                return;
            }
            System.out.println("Direct membership approval blocked; payment proof review is required.");
            response.sendRedirect(request.getContextPath() + "/manager/view_payments.jsp");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp");
    }

}
