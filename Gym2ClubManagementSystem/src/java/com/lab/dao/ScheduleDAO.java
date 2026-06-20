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
        String sql = "INSERT INTO schedules (className, trainerID, classDate, startTime, endTime, capacity) VALUES (?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getClassName());
            ps.setInt(2, s.getTrainerID());
            ps.setDate(3, s.getClassDate());
            ps.setTime(4, s.getStartTime());
            ps.setTime(5, s.getEndTime());
            ps.setInt(6, s.getCapacity());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<Schedule> getAllSchedules() {
        List<Schedule> list = new ArrayList<>();
        String sql = "SELECT * FROM schedules";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Schedule s = new Schedule();
                s.setScheduleID(rs.getInt("scheduleID"));
                s.setClassName(rs.getString("className"));
                s.setTrainerID(rs.getInt("trainerID"));
                s.setClassDate(rs.getDate("classDate"));
                s.setStartTime(rs.getTime("startTime"));
                s.setEndTime(rs.getTime("endTime"));
                s.setCapacity(rs.getInt("capacity"));
                list.add(s);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Schedule getScheduleById(int id) {
        String sql = "SELECT * FROM schedules WHERE scheduleID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Schedule s = new Schedule();
                s.setScheduleID(rs.getInt("scheduleID"));
                s.setClassName(rs.getString("className"));
                s.setTrainerID(rs.getInt("trainerID"));
                s.setClassDate(rs.getDate("classDate"));
                s.setStartTime(rs.getTime("startTime"));
                s.setEndTime(rs.getTime("endTime"));
                s.setCapacity(rs.getInt("capacity"));
                return s;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean updateSchedule(Schedule s) {
        String sql = "UPDATE schedules SET className=?, trainerID=?, classDate=?, startTime=?, endTime=?, capacity=? WHERE scheduleID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getClassName());
            ps.setInt(2, s.getTrainerID());
            ps.setDate(3, s.getClassDate());
            ps.setTime(4, s.getStartTime());
            ps.setTime(5, s.getEndTime());
            ps.setInt(6, s.getCapacity());
            ps.setInt(7, s.getScheduleID());
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
        String sql = "SELECT * FROM schedules WHERE trainerID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, trainerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Schedule s = new Schedule();
                s.setScheduleID(rs.getInt("scheduleID"));
                s.setClassName(rs.getString("className"));
                s.setTrainerID(rs.getInt("trainerID"));
                s.setClassDate(rs.getDate("classDate"));
                s.setStartTime(rs.getTime("startTime"));
                s.setEndTime(rs.getTime("endTime"));
                s.setCapacity(rs.getInt("capacity"));
                list.add(s);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}