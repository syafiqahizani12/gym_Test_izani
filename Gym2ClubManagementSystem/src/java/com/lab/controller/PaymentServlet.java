package com.lab.controller;

import com.lab.dao.BillingDAO;
import com.lab.dao.MembershipDAO;
import com.lab.dao.PaymentDAO;
import com.lab.model.Payment;
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

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {

    private PaymentDAO paymentDao = new PaymentDAO();
    private BillingDAO billingDao = new BillingDAO();
    private MembershipDAO membershipDao = new MembershipDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if ("create".equals(action)) {
            // Show payment page
            int billId = Integer.parseInt(request.getParameter("billID"));
            request.setAttribute("billID", billId);
            request.setAttribute("amount", request.getParameter("amount"));
            request.getRequestDispatcher("/student/payment.jsp").forward(request, response);

        } else if ("process".equals(action)) {
            // Process payment
            int billId = Integer.parseInt(request.getParameter("billID"));
            double amount = Double.parseDouble(request.getParameter("amount"));
            String paymentMethod = request.getParameter("paymentMethod");

            Payment payment = new Payment();
            payment.setBillID(billId);
            payment.setPaymentDate(Date.valueOf(LocalDate.now()));
            payment.setPaymentMethod(paymentMethod);
            payment.setAmount(amount);
            payment.setStatus("Paid");

            boolean paymentCreated = paymentDao.createPayment(payment);
            if (paymentCreated) {
                billingDao.updateBillStatus(billId, "Paid");
                membershipDao.updateMembershipStatus(user.getUserId(), "Active");
                response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp?payment=success");
            } else {
                request.setAttribute("error", "Payment failed. Please try again.");
                request.getRequestDispatcher("/student/payment.jsp").forward(request, response);
            }
        }
    }
}