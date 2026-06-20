package com.lab.controller;

import com.lab.dao.BillingDAO;
import com.lab.dao.PaymentDAO;
import com.lab.model.Billing;
import com.lab.model.Payment;
import com.lab.model.User;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.sql.Date;
import java.time.LocalDate;
import java.util.Set;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/payment")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024, maxRequestSize = 6 * 1024 * 1024)
public class PaymentServlet extends HttpServlet {
    private final PaymentDAO paymentDao = new PaymentDAO();
    private final BillingDAO billingDao = new BillingDAO();
    private static final Set<String> ALLOWED_TYPES = Set.of("image/jpeg", "image/png", "application/pdf");

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if ("approve".equals(action) || "reject".equals(action)) {
            if (!"Manager".equals(user.getRole())) { response.sendError(403); return; }
            int paymentId = parseInt(request.getParameter("paymentID"));
            boolean ok = "approve".equals(action) ? paymentDao.approvePayment(paymentId) : paymentDao.rejectPayment(paymentId);
            System.out.println("=== PAYMENT " + action.toUpperCase() + " === paymentID=" + paymentId + ", success=" + ok);
            response.sendRedirect(request.getContextPath() + "/manager/view_payments.jsp?result=" + (ok ? action + "d" : "failed"));
            return;
        }

        if (!"Member".equals(user.getRole())) { response.sendError(403); return; }
        if (!"process".equals(action)) { response.sendRedirect(request.getContextPath() + "/student/payment.jsp"); return; }

        int billId = parseInt(request.getParameter("billID"));
        Billing bill = billingDao.getBillById(billId);
        Part proof = request.getPart("transactionProof");
        if (bill == null || bill.getStudentID() != user.getUserId() || !"Pending".equalsIgnoreCase(bill.getStatus())) {
            forwardError(request, response, "Invalid or already-paid bill."); return;
        }
        if (paymentDao.hasPendingPaymentForBill(billId)) {
            response.sendRedirect(request.getContextPath() + "/student/pending.jsp?proof=alreadySubmitted"); return;
        }
        if (proof == null || proof.getSize() == 0 || !ALLOWED_TYPES.contains(proof.getContentType())) {
            forwardError(request, response, "Upload a JPG, PNG, or PDF transaction proof (maximum 5 MB)."); return;
        }

        String original = new File(proof.getSubmittedFileName()).getName();
        String extension = original.contains(".") ? original.substring(original.lastIndexOf('.')).toLowerCase() : "";
        File uploadDir = new File(System.getProperty("catalina.base"), "gym-payment-proofs");
        Files.createDirectories(uploadDir.toPath());
        File stored = new File(uploadDir, UUID.randomUUID().toString() + extension);
        try (java.io.InputStream input = proof.getInputStream()) {
            Files.copy(input, stored.toPath());
        }

        Payment payment = new Payment();
        payment.setBillID(billId);
        payment.setPaymentDate(Date.valueOf(LocalDate.now()));
        payment.setPaymentMethod("QR Transfer");
        payment.setAmount(bill.getAmount());
        payment.setStatus("Pending");
        payment.setProofPath(stored.getAbsolutePath());
        payment.setProofFileName(original);
        boolean created = paymentDao.createPayment(payment);
        System.out.println("=== PAYMENT PROOF SUBMITTED === billID=" + billId + ", userID=" + user.getUserId() + ", success=" + created);
        if (!created) {
            Files.deleteIfExists(stored.toPath());
            forwardError(request, response, "Could not submit payment proof. Please try again.");
            return;
        }
        response.sendRedirect(request.getContextPath() + "/student/pending.jsp?proof=submitted");
    }

    private void forwardError(HttpServletRequest req, HttpServletResponse res, String message) throws ServletException, IOException {
        req.setAttribute("error", message);
        req.getRequestDispatcher("/student/payment.jsp").forward(req, res);
    }

    private int parseInt(String value) {
        try { return Integer.parseInt(value); } catch (Exception e) { return -1; }
    }
}
