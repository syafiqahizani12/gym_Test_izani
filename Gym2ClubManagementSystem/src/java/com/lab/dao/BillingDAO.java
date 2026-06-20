package com.lab.dao;

import com.lab.model.Billing;
import com.lab.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BillingDAO {

    public boolean createBill(Billing bill) {
        String sql = "INSERT INTO bills (studentID, amount, dueDate, status, planType) VALUES (?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, bill.getStudentID());
            ps.setDouble(2, bill.getAmount());
            ps.setDate(3, bill.getDueDate());
            ps.setString(4, bill.getStatus());
            ps.setString(5, bill.getPlanType());
            int result = ps.executeUpdate();
            if (result > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    bill.setBillID(rs.getInt(1));
                }
                return true;
            }
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Billing getPendingBillByStudentId(int studentId) {
        String sql = "SELECT * FROM bills WHERE studentID=? AND status='Pending' ORDER BY billID DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Billing b = new Billing();
                b.setBillID(rs.getInt("billID"));
                b.setStudentID(rs.getInt("studentID"));
                b.setAmount(rs.getDouble("amount"));
                b.setDueDate(rs.getDate("dueDate"));
                b.setStatus(rs.getString("status"));
                b.setPlanType(rs.getString("planType"));
                return b;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Billing getBillById(int billId) {
        String sql = "SELECT * FROM bills WHERE billID=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, billId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Billing b = new Billing();
                b.setBillID(rs.getInt("billID"));
                b.setStudentID(rs.getInt("studentID"));
                b.setAmount(rs.getDouble("amount"));
                b.setDueDate(rs.getDate("dueDate"));
                b.setStatus(rs.getString("status"));
                b.setPlanType(rs.getString("planType"));
                return b;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateBillStatus(int billId, String status) {
        String sql = "UPDATE bills SET status=? WHERE billID=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, billId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Billing> getBillsByStudentId(int studentId) {
        List<Billing> list = new ArrayList<>();
        String sql = "SELECT * FROM bills WHERE studentID=? ORDER BY billID DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Billing b = new Billing();
                b.setBillID(rs.getInt("billID"));
                b.setStudentID(rs.getInt("studentID"));
                b.setAmount(rs.getDouble("amount"));
                b.setDueDate(rs.getDate("dueDate"));
                b.setStatus(rs.getString("status"));
                b.setPlanType(rs.getString("planType"));
                list.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
