package com.lab.controller;

import com.lab.dao.BillingDAO;
import com.lab.dao.MembershipDAO;
import com.lab.model.Billing;
import com.lab.model.Membership;
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

    private final BillingDAO billingDao = new BillingDAO();
    private final MembershipDAO membershipDao = new MembershipDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if ("create".equals(action) || "changePlan".equals(action)) {
            createPendingBillAndMembership(request, response, user, "changePlan".equals(action));
            return;
        }

        response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp");
    }

    private void createPendingBillAndMembership(HttpServletRequest request, HttpServletResponse response, User user, boolean planChange)
            throws IOException {
        String plan = request.getParameter("plan");
        Double amount = getPlanAmount(plan);
        System.out.println("=== BILLING CREATE === userID=" + user.getUserId() + ", plan=" + plan);

        if (amount == null) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp?error=noplan");
            return;
        }

        Membership existing = membershipDao.getMembershipByStudentId(user.getUserId());
        boolean active = existing != null && "Active".equalsIgnoreCase(existing.getStatus());
        if (planChange && !active) {
            response.sendRedirect(request.getContextPath() + "/student/changePlan.jsp?error=inactive");
            return;
        }
        if (!planChange && active) {
            response.sendRedirect(request.getContextPath() + "/student/changePlan.jsp");
            return;
        }
        if (active && plan.equalsIgnoreCase(existing.getMembershipType())) {
            response.sendRedirect(request.getContextPath() + "/student/changePlan.jsp?error=same");
            return;
        }
        if (billingDao.getPendingBillByStudentId(user.getUserId()) != null) {
            response.sendRedirect(request.getContextPath() + "/student/payment.jsp?notice=pending");
            return;
        }

        Billing bill = new Billing();
        bill.setStudentID(user.getUserId());
        bill.setAmount(amount);
        bill.setDueDate(Date.valueOf(LocalDate.now().plusDays(7)));
        bill.setStatus("Pending");
        bill.setPlanType(plan);

        if (billingDao.createBill(bill)) {
            if (existing == null) {
                membershipDao.createPendingMembership(user.getUserId(), plan, amount);
            } else if (!active) {
                existing.setMembershipType(plan);
                existing.setStartDate(Date.valueOf(LocalDate.now()));
                existing.setExpiryDate(Date.valueOf(LocalDate.now().plusMonths(1)));
                existing.setStatus("Pending");
                membershipDao.updateMembership(existing);
            }
            response.sendRedirect(request.getContextPath() + "/student/payment.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp?error=billing");
        }
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
