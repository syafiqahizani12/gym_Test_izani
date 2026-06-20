package com.lab.controller;

import com.lab.dao.BillingDAO;
import com.lab.dao.MembershipDAO;
import com.lab.model.Billing;
import com.lab.model.User;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/billing")
public class BillingServlet extends HttpServlet {

    private BillingDAO billingDao = new BillingDAO();
    private MembershipDAO membershipDao = new MembershipDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if ("create".equals(action)) {
            // This is called after registration to show the bill
            // No need to create bill here – it's already created in RegisterServlet
            response.sendRedirect(request.getContextPath() + "/student/billing.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp");
        }
    }
}