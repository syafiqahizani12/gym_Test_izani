/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.lab.dao;

import com.lab.model.Booking;
import com.lab.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    public boolean createBooking(Booking b) {
        String sql = "INSERT INTO bookings (scheduleID, studentID, bookingDate, bookingStatus) VALUES (?,?,?,?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, b.getScheduleID());
            ps.setInt(2, b.getStudentID());
            ps.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            ps.setString(4, b.getBookingStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isAlreadyBooked(int studentId, int scheduleId) {
        String sql = "SELECT * FROM bookings WHERE studentID=? AND scheduleID=? AND bookingStatus='Confirmed'";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, scheduleId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return true;
        }
    }

    public boolean isClassFull(int scheduleId) {
        String sql = "SELECT capacity, (SELECT COUNT(*) FROM bookings WHERE scheduleID=? AND bookingStatus='Confirmed') AS booked FROM schedules WHERE scheduleID=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleId);
            ps.setInt(2, scheduleId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int capacity = rs.getInt("capacity");
                int booked = rs.getInt("booked");
                return booked >= capacity;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return true;
    }

    public boolean decreaseCapacity(int scheduleId) {
        String sql = "UPDATE schedules SET capacity = capacity - 1 WHERE scheduleID=? AND capacity > 0";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean increaseCapacity(int scheduleId) {
        String sql = "UPDATE schedules SET capacity = capacity + 1 WHERE scheduleID=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean cancelBooking(int bookingId) {
        String sql = "UPDATE bookings SET bookingStatus='Cancelled' WHERE bookingID=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Booking getBookingById(int id) {
        String sql = "SELECT * FROM bookings WHERE bookingID=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Booking b = new Booking();
                b.setBookingID(rs.getInt("bookingID"));
                b.setScheduleID(rs.getInt("scheduleID"));
                b.setStudentID(rs.getInt("studentID"));
                b.setBookingDate(rs.getTimestamp("bookingDate"));
                b.setBookingStatus(rs.getString("bookingStatus"));
                return b;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Booking> getBookingsByStudent(int studentId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM bookings WHERE studentID=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Booking b = new Booking();
                b.setBookingID(rs.getInt("bookingID"));
                b.setScheduleID(rs.getInt("scheduleID"));
                b.setStudentID(rs.getInt("studentID"));
                b.setBookingDate(rs.getTimestamp("bookingDate"));
                b.setBookingStatus(rs.getString("bookingStatus"));
                list.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Booking> getBookingsBySchedule(int scheduleId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM bookings WHERE scheduleID=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Booking b = new Booking();
                b.setBookingID(rs.getInt("bookingID"));
                b.setScheduleID(rs.getInt("scheduleID"));
                b.setStudentID(rs.getInt("studentID"));
                b.setBookingDate(rs.getTimestamp("bookingDate"));
                b.setBookingStatus(rs.getString("bookingStatus"));
                list.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Booking> getAllBookings() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM bookings";
        try (Connection conn = DBConnection.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Booking b = new Booking();
                b.setBookingID(rs.getInt("bookingID"));
                b.setScheduleID(rs.getInt("scheduleID"));
                b.setStudentID(rs.getInt("studentID"));
                b.setBookingDate(rs.getTimestamp("bookingDate"));
                b.setBookingStatus(rs.getString("bookingStatus"));
                list.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
