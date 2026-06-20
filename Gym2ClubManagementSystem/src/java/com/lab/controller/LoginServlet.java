package com.lab.controller;

import com.lab.dao.UserDAO;
import com.lab.dao.MembershipDAO;
import com.lab.model.User;
import com.lab.model.Membership;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/login")   // ← MUST be "/login" (not "/LoginServlet")
public class LoginServlet extends HttpServlet {

    private UserDAO userDao = new UserDAO();
    private MembershipDAO membershipDao = new MembershipDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // If someone accesses /login via GET, redirect to login page
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        System.out.println("=== LOGIN ATTEMPT ===");
        System.out.println("Email: " + email);

        // Step 1: Authenticate user
        User user = userDao.authenticate(email, password);

        if (user == null) {
            System.out.println("Login FAILED for: " + email);
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=invalid");
            return;
        }

        System.out.println("User authenticated: " + user.getFullName());
        System.out.println("Role: " + user.getRole());

        // Step 2: Check membership status
        Membership membership = membershipDao.getMembershipByStudentId(user.getUserId());

        if (membership == null || "Expired".equals(membership.getStatus()) || "Suspended".equals(membership.getStatus())) {
            // No valid membership – redirect to index with alert
            System.out.println("No valid membership for: " + email);
            response.sendRedirect(request.getContextPath() + "/index.jsp?needPlan=true");
            return;
        }

        // Step 3: If membership is pending, redirect to billing
        if ("Pending".equals(membership.getStatus())) {
            System.out.println("Pending membership for: " + email);
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            response.sendRedirect(request.getContextPath() + "/student/billing.jsp");
            return;
        }

        // Step 4: Active membership – store session and redirect to dashboard
        HttpSession session = request.getSession();
        session.setAttribute("user", user);
        session.setAttribute("user_id", user.getUserId());
        session.setAttribute("name", user.getFullName());

        String role = user.getRole();

        // Redirect based on role
        if (role != null && role.equalsIgnoreCase("Member") || role.equalsIgnoreCase("Student")) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp");
        } else if (role != null && role.equalsIgnoreCase("Trainer")) {
            response.sendRedirect(request.getContextPath() + "/trainer/dashboard.jsp");
        } else if (role != null && role.equalsIgnoreCase("Manager") || role.equalsIgnoreCase("Admin")) {
            response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=invalid");
        }
    }
}