package com.lab.controller;

import com.lab.dao.MembershipDAO;
import com.lab.dao.UserDAO;
import com.lab.model.Membership;
import com.lab.model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDao = new UserDAO();
    private final MembershipDAO membershipDao = new MembershipDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        System.out.println("=== LOGIN ATTEMPT ===");
        System.out.println("Email: " + email);

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=invalid");
            return;
        }

        User user = userDao.authenticate(email.trim(), password);
        if (user == null) {
            System.out.println("Login FAILED for: " + email);
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=invalid");
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute("user", user);
        session.setAttribute("user_id", user.getUserId());
        session.setAttribute("name", user.getFullName());

        String role = user.getRole();
        System.out.println("User authenticated: " + user.getFullName());
        System.out.println("Role: " + role);

        if (role != null && (role.equalsIgnoreCase("Member") || role.equalsIgnoreCase("Student"))) {
            redirectMemberByMembership(request, response, user);
        } else if (role != null && role.equalsIgnoreCase("Trainer")) {
            response.sendRedirect(request.getContextPath() + "/trainer/dashboard.jsp");
        } else if (role != null && (role.equalsIgnoreCase("Manager") || role.equalsIgnoreCase("Admin"))) {
            response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=invalid");
        }
    }

    private void redirectMemberByMembership(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        Membership membership = membershipDao.getMembershipByStudentId(user.getUserId());

        if (membership == null) {
            System.out.println("No membership for userID=" + user.getUserId());
            response.sendRedirect(request.getContextPath() + "/index.jsp?needPlan=true");
            return;
        }

        String status = membership.getStatus();
        System.out.println("Membership status: " + status);

        if ("Pending".equalsIgnoreCase(status)) {
            response.sendRedirect(request.getContextPath() + "/student/pending.jsp");
        } else if ("Active".equalsIgnoreCase(status) && membershipDao.isActive(user.getUserId())) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/student/expired.jsp");
        }
    }
}
