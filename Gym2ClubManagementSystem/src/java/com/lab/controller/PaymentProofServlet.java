package com.lab.controller;

import com.lab.dao.BillingDAO;
import com.lab.dao.PaymentDAO;
import com.lab.model.Billing;
import com.lab.model.Payment;
import com.lab.model.User;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/payment-proof")
public class PaymentProofServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) { response.sendError(401); return; }
        User user = (User) session.getAttribute("user");
        int id;
        try { id = Integer.parseInt(request.getParameter("id")); } catch (Exception e) { response.sendError(400); return; }
        Payment payment = new PaymentDAO().getPaymentById(id);
        if (payment == null) { response.sendError(404); return; }
        Billing bill = new BillingDAO().getBillById(payment.getBillID());
        boolean allowed = "Manager".equals(user.getRole()) || (bill != null && bill.getStudentID() == user.getUserId());
        if (!allowed) { response.sendError(403); return; }
        File file = new File(payment.getProofPath());
        if (!file.isFile()) { response.sendError(404); return; }
        String type = Files.probeContentType(file.toPath());
        response.setContentType(type == null ? "application/octet-stream" : type);
        String safeName = payment.getProofFileName().replace("\"", "").replace("\r", "").replace("\n", "");
        response.setHeader("Content-Disposition", "inline; filename=\"" + safeName + "\"");
        Files.copy(file.toPath(), response.getOutputStream());
    }
}
