/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.lab.dao;

/**
 *
 * @author DELL
 */


import com.lab.model.Attendance;
import com.lab.model.Schedule;
import com.lab.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AttendanceDAO {
    public boolean checkIn(int studentId, int scheduleId) {
        if (!new MembershipDAO().isActive(studentId)) return false;
        String sql = "INSERT INTO attendance (studentID, scheduleID, checkInTime, attendanceStatus) VALUES (?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, scheduleId);
            ps.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            ps.setString(4, "Present");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean checkOut(int attendanceId) {
        String sql = "UPDATE attendance SET checkOutTime=? WHERE attendanceID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            ps.setInt(2, attendanceId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean markAttendanceByTrainer(int scheduleId, int studentId, String status) {
        ScheduleDAO sDao = new ScheduleDAO();
        Schedule s = sDao.getScheduleById(scheduleId);
        if (s == null) return false;
        Time now = new Time(System.currentTimeMillis());
        if (now.before(s.getStartTime())) return false;

        String checkSql = "SELECT attendanceID FROM attendance WHERE studentID=? AND scheduleID=?";
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement psCheck = conn.prepareStatement(checkSql);
            psCheck.setInt(1, studentId);
            psCheck.setInt(2, scheduleId);
            ResultSet rs = psCheck.executeQuery();
            if (rs.next()) {
                int id = rs.getInt("attendanceID");
                String updSql = "UPDATE attendance SET attendanceStatus=? WHERE attendanceID=?";
                PreparedStatement psUpd = conn.prepareStatement(updSql);
                psUpd.setString(1, status);
                psUpd.setInt(2, id);
                return psUpd.executeUpdate() > 0;
            } else {
                String insSql = "INSERT INTO attendance (studentID, scheduleID, checkInTime, attendanceStatus) VALUES (?,?,?,?)";
                PreparedStatement psIns = conn.prepareStatement(insSql);
                psIns.setInt(1, studentId);
                psIns.setInt(2, scheduleId);
                psIns.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
                psIns.setString(4, status);
                return psIns.executeUpdate() > 0;
            }
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<Attendance> getAttendanceByStudent(int studentId) {
        List<Attendance> list = new ArrayList<>();
        String sql = "SELECT * FROM attendance WHERE studentID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Attendance a = new Attendance();
                a.setAttendanceID(rs.getInt("attendanceID"));
                a.setStudentID(rs.getInt("studentID"));
                a.setScheduleID(rs.getInt("scheduleID"));
                a.setCheckInTime(rs.getTimestamp("checkInTime"));
                a.setCheckOutTime(rs.getTimestamp("checkOutTime"));
                a.setAttendanceStatus(rs.getString("attendanceStatus"));
                list.add(a);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Attendance> getAttendanceBySchedule(int scheduleId) {
        List<Attendance> list = new ArrayList<>();
        String sql = "SELECT * FROM attendance WHERE scheduleID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Attendance a = new Attendance();
                a.setAttendanceID(rs.getInt("attendanceID"));
                a.setStudentID(rs.getInt("studentID"));
                a.setScheduleID(rs.getInt("scheduleID"));
                a.setCheckInTime(rs.getTimestamp("checkInTime"));
                a.setCheckOutTime(rs.getTimestamp("checkOutTime"));
                a.setAttendanceStatus(rs.getString("attendanceStatus"));
                list.add(a);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Attendance> getAllAttendance() {
        List<Attendance> list = new ArrayList<>();
        String sql = "SELECT * FROM attendance";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Attendance a = new Attendance();
                a.setAttendanceID(rs.getInt("attendanceID"));
                a.setStudentID(rs.getInt("studentID"));
                a.setScheduleID(rs.getInt("scheduleID"));
                a.setCheckInTime(rs.getTimestamp("checkInTime"));
                a.setCheckOutTime(rs.getTimestamp("checkOutTime"));
                a.setAttendanceStatus(rs.getString("attendanceStatus"));
                list.add(a);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}