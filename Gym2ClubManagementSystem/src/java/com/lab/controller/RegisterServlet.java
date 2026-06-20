package com.lab.controller;

import com.lab.dao.BillingDAO;
import com.lab.dao.MembershipDAO;
import com.lab.dao.UserDAO;
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

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserDAO userDao = new UserDAO();
    private MembershipDAO membershipDao = new MembershipDAO();
    private BillingDAO billingDao = new BillingDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String plan = request.getParameter("plan");
        String amountStr = request.getParameter("amount");

        System.out.println("=== REGISTER ATTEMPT ===");
        System.out.println("Full Name: " + fullName);
        System.out.println("Email: " + email);
        System.out.println("Plan: " + plan);
        System.out.println("Amount: " + amountStr);

        // Validate plan
        if (plan == null || plan.isEmpty() || amountStr == null || amountStr.isEmpty()) {
            System.out.println("❌ Plan or amount is null!");
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=noplan");
            return;
        }

        // Check if email exists
        User existingUser = userDao.getUserByEmail(email);
        if (existingUser != null) {
            System.out.println("❌ Email already exists!");
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=duplicate");
            return;
        }

        // Create user
        String role = "Member";
        User user = new User(0, fullName, email, password, phone, role);
        boolean registered = userDao.register(user);
        System.out.println("Step 1 - User registered: " + registered);
        if (!registered) {
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=other");
            return;
        }

        // Get new user
        User newUser = userDao.getUserByEmail(email);
        if (newUser == null) {
            System.out.println("❌ Could not retrieve new user!");
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=other");
            return;
        }
        int studentId = newUser.getUserId();
        System.out.println("Step 2 - New user ID: " + studentId);

        // Create bill
        double amount = Double.parseDouble(amountStr);
        Billing bill = new Billing();
        bill.setStudentID(studentId);
        bill.setAmount(amount);
        bill.setDueDate(Date.valueOf(LocalDate.now().plusDays(7)));
        bill.setStatus("Pending");

        boolean billCreated = billingDao.createBill(bill);
        System.out.println("Step 3 - Bill created: " + billCreated);
        if (!billCreated) {
            System.out.println("❌ Bill creation FAILED!");
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=other");
            return;
        }

        // Create pending membership
        boolean membershipCreated = membershipDao.createPendingMembership(studentId, plan, amount);
        System.out.println("Step 4 - Membership created (Pending): " + membershipCreated);
        if (!membershipCreated) {
            System.out.println("❌ Membership creation FAILED!");
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=other");
            return;
        }

        // Store session
        HttpSession session = request.getSession();
        session.setAttribute("user", newUser);

        System.out.println("✅ Registration COMPLETE! Redirecting to billing.");
        response.sendRedirect(request.getContextPath() + "/student/billing.jsp");
    }
}