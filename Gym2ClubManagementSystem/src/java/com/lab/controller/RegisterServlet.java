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

    private final UserDAO userDao = new UserDAO();
    private final MembershipDAO membershipDao = new MembershipDAO();
    private final BillingDAO billingDao = new BillingDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String plan = request.getParameter("plan");

        System.out.println("=== REGISTER ATTEMPT ===");
        System.out.println("Email: " + email + ", plan: " + plan);

        if (isBlank(fullName) || isBlank(email) || isBlank(phone) || password == null || password.length() < 6) {
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=validation");
            return;
        }

        Double amount = getPlanAmount(plan);
        if (amount == null) {
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=noplan");
            return;
        }

        if (userDao.getUserByEmail(email.trim()) != null) {
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=duplicate");
            return;
        }

        User user = new User(0, fullName.trim(), email.trim(), password, phone.trim(), "Member");
        if (!userDao.register(user)) {
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=other");
            return;
        }

        User newUser = userDao.getUserByEmail(email.trim());
        if (newUser == null) {
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=other");
            return;
        }

        Billing bill = new Billing();
        bill.setStudentID(newUser.getUserId());
        bill.setAmount(amount);
        bill.setDueDate(Date.valueOf(LocalDate.now().plusDays(7)));
        bill.setStatus("Pending");
        bill.setPlanType(plan);

        boolean billCreated = billingDao.createBill(bill);
        boolean membershipCreated = membershipDao.createPendingMembership(newUser.getUserId(), plan, amount);
        System.out.println("Bill created=" + billCreated + ", membership created=" + membershipCreated);

        if (!billCreated || !membershipCreated) {
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=other");
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute("user", newUser);
        session.setAttribute("user_id", newUser.getUserId());
        session.setAttribute("name", newUser.getFullName());
        response.sendRedirect(request.getContextPath() + "/student/payment.jsp");
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private Double getPlanAmount(String plan) {
        if ("Basic".equalsIgnoreCase(plan)) {
            return 39.00;
        }
        if ("Premium".equalsIgnoreCase(plan)) {
            return 79.00;
        }
        if ("Elite".equalsIgnoreCase(plan)) {
            return 129.00;
        }
        return null;
    }
}
