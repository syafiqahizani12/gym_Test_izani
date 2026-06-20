/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.lab.dao;

/**
 *
 * @author ASUS
 */


import com.lab.model.Schedule;
import com.lab.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ScheduleDAO {
    public boolean createSchedule(Schedule s) {
        String sql = "INSERT INTO schedules (className, trainerID, classDate, startTime, endTime, capacity, planType) VALUES (?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getClassName());
            ps.setInt(2, s.getTrainerID());
            ps.setDate(3, s.getClassDate());
            ps.setTime(4, s.getStartTime());
            ps.setTime(5, s.getEndTime());
            ps.setInt(6, s.getCapacity());
            ps.setString(7, s.getPlanType());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<Schedule> getAllSchedules() {
        List<Schedule> list = new ArrayList<>();
        String sql = "SELECT s.*, u.full_name AS trainerName FROM schedules s "
                + "JOIN users u ON s.trainerID=u.user_id ORDER BY s.classDate, s.startTime";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Schedule s = new Schedule();
                s.setScheduleID(rs.getInt("scheduleID"));
                s.setClassName(rs.getString("className"));
                s.setTrainerID(rs.getInt("trainerID"));
                s.setTrainerName(rs.getString("trainerName"));
                s.setClassDate(rs.getDate("classDate"));
                s.setStartTime(rs.getTime("startTime"));
                s.setEndTime(rs.getTime("endTime"));
                s.setCapacity(rs.getInt("capacity"));
                s.setPlanType(rs.getString("planType"));
                list.add(s);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Schedule getScheduleById(int id) {
        String sql = "SELECT s.*, u.full_name AS trainerName FROM schedules s "
                + "JOIN users u ON s.trainerID=u.user_id WHERE s.scheduleID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Schedule s = new Schedule();
                s.setScheduleID(rs.getInt("scheduleID"));
                s.setClassName(rs.getString("className"));
                s.setTrainerID(rs.getInt("trainerID"));
                s.setTrainerName(rs.getString("trainerName"));
                s.setClassDate(rs.getDate("classDate"));
                s.setStartTime(rs.getTime("startTime"));
                s.setEndTime(rs.getTime("endTime"));
                s.setCapacity(rs.getInt("capacity"));
                s.setPlanType(rs.getString("planType"));
                return s;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean updateSchedule(Schedule s) {
        String sql = "UPDATE schedules SET className=?, trainerID=?, classDate=?, startTime=?, endTime=?, capacity=?, planType=? WHERE scheduleID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getClassName());
            ps.setInt(2, s.getTrainerID());
            ps.setDate(3, s.getClassDate());
            ps.setTime(4, s.getStartTime());
            ps.setTime(5, s.getEndTime());
            ps.setInt(6, s.getCapacity());
            ps.setString(7, s.getPlanType());
            ps.setInt(8, s.getScheduleID());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean deleteSchedule(int id) {
        String sql = "DELETE FROM schedules WHERE scheduleID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<Schedule> getSchedulesByTrainer(int trainerId) {
        List<Schedule> list = new ArrayList<>();
        String sql = "SELECT s.*, u.full_name AS trainerName FROM schedules s "
                + "JOIN users u ON s.trainerID=u.user_id WHERE s.trainerID=? ORDER BY s.classDate, s.startTime";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, trainerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Schedule s = new Schedule();
                s.setScheduleID(rs.getInt("scheduleID"));
                s.setClassName(rs.getString("className"));
                s.setTrainerID(rs.getInt("trainerID"));
                s.setTrainerName(rs.getString("trainerName"));
                s.setClassDate(rs.getDate("classDate"));
                s.setStartTime(rs.getTime("startTime"));
                s.setEndTime(rs.getTime("endTime"));
                s.setCapacity(rs.getInt("capacity"));
                s.setPlanType(rs.getString("planType"));
                list.add(s);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Schedule> getSchedulesByPlan(String planType) {
        List<Schedule> list = new ArrayList<>();
        String sql = "SELECT s.*, u.full_name AS trainerName FROM schedules s "
                + "JOIN users u ON s.trainerID=u.user_id WHERE s.planType=? ORDER BY s.classDate, s.startTime";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, planType);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Schedule s = new Schedule();
                s.setScheduleID(rs.getInt("scheduleID"));
                s.setClassName(rs.getString("className"));
                s.setTrainerID(rs.getInt("trainerID"));
                s.setTrainerName(rs.getString("trainerName"));
                s.setClassDate(rs.getDate("classDate"));
                s.setStartTime(rs.getTime("startTime"));
                s.setEndTime(rs.getTime("endTime"));
                s.setCapacity(rs.getInt("capacity"));
                s.setPlanType(rs.getString("planType"));
                list.add(s);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}
