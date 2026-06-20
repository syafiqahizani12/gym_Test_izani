package com.lab.dao;

import com.lab.model.Payment;
import com.lab.util.DBConnection;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {

    public boolean createPayment(Payment payment) {
        String sql = "INSERT INTO payments (billID, paymentDate, paymentMethod, amount, status, proofPath, proofFileName) VALUES (?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, payment.getBillID());
            ps.setDate(2, payment.getPaymentDate());
            ps.setString(3, payment.getPaymentMethod());
            ps.setDouble(4, payment.getAmount());
            ps.setString(5, payment.getStatus());
            ps.setString(6, payment.getProofPath());
            ps.setString(7, payment.getProofFileName());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Payment mapPayment(ResultSet rs) throws SQLException {
        Payment p = new Payment();
        p.setPaymentID(rs.getInt("paymentID"));
        p.setBillID(rs.getInt("billID"));
        p.setPaymentDate(rs.getDate("paymentDate"));
        p.setPaymentMethod(rs.getString("paymentMethod"));
        p.setAmount(rs.getDouble("amount"));
        p.setStatus(rs.getString("status"));
        p.setProofPath(rs.getString("proofPath"));
        p.setProofFileName(rs.getString("proofFileName"));
        try { p.setStudentName(rs.getString("studentName")); } catch (SQLException ignored) { }
        try { p.setPlanType(rs.getString("planType")); } catch (SQLException ignored) { }
        return p;
    }

    public Payment getPaymentById(int paymentId) {
        String sql = "SELECT p.*, u.full_name AS studentName, b.planType AS planType "
                + "FROM payments p JOIN bills b ON p.billID=b.billID JOIN users u ON b.studentID=u.user_id "
                + "WHERE p.paymentID=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, paymentId);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? mapPayment(rs) : null;
        } catch (SQLException e) { e.printStackTrace(); return null; }
    }

    public boolean hasPendingPaymentForBill(int billId) {
        String sql = "SELECT 1 FROM payments WHERE billID=? AND status='Pending'";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, billId);
            return ps.executeQuery().next();
        } catch (SQLException e) { e.printStackTrace(); return true; }
    }

    public List<Payment> getPaymentsByStudentId(int studentId) {
        return queryPayments("WHERE b.studentID=?", studentId);
    }

    public List<Payment> getAllPayments() {
        return queryPayments("", null);
    }

    private List<Payment> queryPayments(String where, Integer studentId) {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT p.*, u.full_name AS studentName, b.planType AS planType "
                + "FROM payments p JOIN bills b ON p.billID=b.billID JOIN users u ON b.studentID=u.user_id "
                + where + " ORDER BY p.paymentID DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            if (studentId != null) ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapPayment(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean approvePayment(int paymentId) {
        String select = "SELECT p.billID, b.studentID, b.planType FROM payments p JOIN bills b ON p.billID=b.billID "
                + "WHERE p.paymentID=? AND p.status='Pending' FOR UPDATE";
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement find = conn.prepareStatement(select)) {
                find.setInt(1, paymentId);
                ResultSet rs = find.executeQuery();
                if (!rs.next()) { conn.rollback(); return false; }
                int billId = rs.getInt("billID");
                int studentId = rs.getInt("studentID");
                String planType = rs.getString("planType");
                try (PreparedStatement payment = conn.prepareStatement("UPDATE payments SET status='Approved' WHERE paymentID=?");
                     PreparedStatement bill = conn.prepareStatement("UPDATE bills SET status='Paid' WHERE billID=?");
                     PreparedStatement member = conn.prepareStatement("UPDATE membership SET membershipType=?, status='Active', startDate=?, expiryDate=? WHERE studentID=?")) {
                    payment.setInt(1, paymentId);
                    bill.setInt(1, billId);
                    member.setString(1, planType);
                    member.setDate(2, Date.valueOf(LocalDate.now()));
                    member.setDate(3, Date.valueOf(LocalDate.now().plusMonths(1)));
                    member.setInt(4, studentId);
                    payment.executeUpdate();
                    bill.executeUpdate();
                    if (member.executeUpdate() == 0) { conn.rollback(); return false; }
                }
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            } finally { conn.setAutoCommit(true); }
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean rejectPayment(int paymentId) {
        String sql = "UPDATE payments SET status='Rejected' WHERE paymentID=? AND status='Pending'";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, paymentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}
