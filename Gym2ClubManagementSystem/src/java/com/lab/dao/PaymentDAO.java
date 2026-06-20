package com.lab.dao;

import com.lab.model.Payment;
import com.lab.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {

    public boolean createPayment(Payment payment) {
        String sql = "INSERT INTO payments (billID, paymentDate, paymentMethod, amount, status) VALUES (?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, payment.getBillID());
            ps.setDate(2, payment.getPaymentDate());
            ps.setString(3, payment.getPaymentMethod());
            ps.setDouble(4, payment.getAmount());
            ps.setString(5, payment.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Payment> getPaymentsByStudentId(int studentId) {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT p.* FROM payments p "
                + "JOIN bills b ON p.billID = b.billID "
                + "WHERE b.studentID=? ORDER BY p.paymentID DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Payment p = new Payment();
                p.setPaymentID(rs.getInt("paymentID"));
                p.setBillID(rs.getInt("billID"));
                p.setPaymentDate(rs.getDate("paymentDate"));
                p.setPaymentMethod(rs.getString("paymentMethod"));
                p.setAmount(rs.getDouble("amount"));
                p.setStatus(rs.getString("status"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
