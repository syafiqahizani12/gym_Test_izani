package com.lab.dao;

import com.lab.model.Membership;
import com.lab.util.DBConnection;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class MembershipDAO {

    public boolean createMembership(Membership m) {
        String sql = "INSERT INTO membership (studentID, membershipType, startDate, expiryDate, status) VALUES (?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, m.getStudentID());
            ps.setString(2, m.getMembershipType());
            ps.setDate(3, m.getStartDate());
            ps.setDate(4, m.getExpiryDate());
            ps.setString(5, m.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Membership> getAllMemberships() {
        List<Membership> list = new ArrayList<>();
        String sql = "SELECT * FROM membership";
        try (Connection conn = DBConnection.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Membership m = new Membership();
                m.setMembershipID(rs.getInt("membershipID"));
                m.setStudentID(rs.getInt("studentID"));
                m.setMembershipType(rs.getString("membershipType"));
                m.setStartDate(rs.getDate("startDate"));
                m.setExpiryDate(rs.getDate("expiryDate"));
                m.setStatus(rs.getString("status"));
                list.add(m);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Membership getMembershipByStudentId(int studentId) {
        String sql = "SELECT * FROM membership WHERE studentID=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Membership m = new Membership();
                m.setMembershipID(rs.getInt("membershipID"));
                m.setStudentID(rs.getInt("studentID"));
                m.setMembershipType(rs.getString("membershipType"));
                m.setStartDate(rs.getDate("startDate"));
                m.setExpiryDate(rs.getDate("expiryDate"));
                m.setStatus(rs.getString("status"));
                return m;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Membership getMembershipById(int id) {
        String sql = "SELECT * FROM membership WHERE membershipID=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Membership m = new Membership();
                m.setMembershipID(rs.getInt("membershipID"));
                m.setStudentID(rs.getInt("studentID"));
                m.setMembershipType(rs.getString("membershipType"));
                m.setStartDate(rs.getDate("startDate"));
                m.setExpiryDate(rs.getDate("expiryDate"));
                m.setStatus(rs.getString("status"));
                return m;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateMembership(Membership m) {
        String sql = "UPDATE membership SET membershipType=?, startDate=?, expiryDate=?, status=? WHERE membershipID=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, m.getMembershipType());
            ps.setDate(2, m.getStartDate());
            ps.setDate(3, m.getExpiryDate());
            ps.setString(4, m.getStatus());
            ps.setInt(5, m.getMembershipID());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteMembership(int id) {
        String sql = "DELETE FROM membership WHERE membershipID=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isActive(int studentId) {
        Membership m = getMembershipByStudentId(studentId);
        if (m == null) return false;
        return "Active".equals(m.getStatus()) && m.getExpiryDate().after(new Date(System.currentTimeMillis()));
    }

    // ✅ CREATE PENDING MEMBERSHIP
    public boolean createPendingMembership(int studentId, String plan, double amount) {
        String sql = "INSERT INTO membership (studentID, membershipType, startDate, expiryDate, status) VALUES (?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setString(2, plan);
            ps.setDate(3, Date.valueOf(LocalDate.now()));
            ps.setDate(4, Date.valueOf(LocalDate.now().plusMonths(1)));
            ps.setString(5, "Pending");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ UPDATE MEMBERSHIP STATUS
    public boolean updateMembershipStatus(int studentId, String status) {
        String sql = "UPDATE membership SET status=? WHERE studentID=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, studentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ CREATE ACTIVE MEMBERSHIP (Skip billing)
    public boolean createActiveMembership(int studentId, String plan, double amount) {
        String sql = "INSERT INTO membership (studentID, membershipType, startDate, expiryDate, status) VALUES (?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setString(2, plan);
            ps.setDate(3, Date.valueOf(LocalDate.now()));
            ps.setDate(4, Date.valueOf(LocalDate.now().plusMonths(1)));
            ps.setString(5, "Active");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}