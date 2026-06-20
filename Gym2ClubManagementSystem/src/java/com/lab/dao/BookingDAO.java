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
import java.time.LocalDate;
import java.time.LocalTime;

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
        String sql = "SELECT capacity FROM schedules WHERE scheduleID=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("capacity") <= 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return true;
    }

    public boolean isPlanEligible(int studentId, int scheduleId) {
        String sql = "SELECT 1 FROM membership m JOIN schedules s ON s.planType=m.membershipType "
                + "WHERE m.studentID=? AND s.scheduleID=? AND m.status='Active'";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, scheduleId);
            return ps.executeQuery().next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean bookClass(int studentId, int scheduleId) {
        String duplicateSql = "SELECT bookingID FROM bookings WHERE studentID=? AND scheduleID=? AND bookingStatus='Confirmed'";
        String capacitySql = "SELECT capacity, planType FROM schedules WHERE scheduleID=? FOR UPDATE";
        String membershipSql = "SELECT membershipType FROM membership WHERE studentID=? AND status='Active'";
        String insertSql = "INSERT INTO bookings (scheduleID, studentID, bookingDate, bookingStatus) VALUES (?,?,?,?)";
        String updateCapacitySql = "UPDATE schedules SET capacity = capacity - 1 WHERE scheduleID=? AND capacity > 0";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement duplicate = conn.prepareStatement(duplicateSql);
                 PreparedStatement capacity = conn.prepareStatement(capacitySql);
                 PreparedStatement membership = conn.prepareStatement(membershipSql)) {
                duplicate.setInt(1, studentId);
                duplicate.setInt(2, scheduleId);
                if (duplicate.executeQuery().next()) {
                    conn.rollback();
                    return false;
                }

                capacity.setInt(1, scheduleId);
                ResultSet rs = capacity.executeQuery();
                if (!rs.next() || rs.getInt("capacity") <= 0) {
                    conn.rollback();
                    return false;
                }
                String schedulePlan = rs.getString("planType");
                membership.setInt(1, studentId);
                ResultSet memberRs = membership.executeQuery();
                if (!memberRs.next() || !schedulePlan.equalsIgnoreCase(memberRs.getString("membershipType"))) {
                    conn.rollback();
                    return false;
                }

                try (PreparedStatement insert = conn.prepareStatement(insertSql);
                     PreparedStatement update = conn.prepareStatement(updateCapacitySql)) {
                    insert.setInt(1, scheduleId);
                    insert.setInt(2, studentId);
                    insert.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
                    insert.setString(4, "Confirmed");
                    insert.executeUpdate();

                    update.setInt(1, scheduleId);
                    if (update.executeUpdate() == 0) {
                        conn.rollback();
                        return false;
                    }
                }

                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
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
        String sql = "SELECT b.*, u.full_name AS studentName, s.className AS scheduleName "
                + "FROM bookings b JOIN users u ON b.studentID=u.user_id "
                + "JOIN schedules s ON b.scheduleID=s.scheduleID WHERE b.studentID=? ORDER BY b.bookingDate DESC";
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
                b.setStudentName(rs.getString("studentName"));
                b.setScheduleName(rs.getString("scheduleName"));
                list.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Booking> getBookingsBySchedule(int scheduleId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, u.full_name AS studentName, s.className AS scheduleName "
                + "FROM bookings b JOIN users u ON b.studentID=u.user_id "
                + "JOIN schedules s ON b.scheduleID=s.scheduleID WHERE b.scheduleID=? ORDER BY u.full_name";
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
                b.setStudentName(rs.getString("studentName"));
                b.setScheduleName(rs.getString("scheduleName"));
                list.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Booking> getAllBookings() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, u.full_name AS studentName, s.className AS scheduleName "
                + "FROM bookings b JOIN users u ON b.studentID=u.user_id "
                + "JOIN schedules s ON b.scheduleID=s.scheduleID ORDER BY b.bookingDate DESC";
        try (Connection conn = DBConnection.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Booking b = new Booking();
                b.setBookingID(rs.getInt("bookingID"));
                b.setScheduleID(rs.getInt("scheduleID"));
                b.setStudentID(rs.getInt("studentID"));
                b.setBookingDate(rs.getTimestamp("bookingDate"));
                b.setBookingStatus(rs.getString("bookingStatus"));
                b.setStudentName(rs.getString("studentName"));
                b.setScheduleName(rs.getString("scheduleName"));
                list.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Booking> getConfirmedBookingsByTrainer(int trainerId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, u.full_name AS studentName, s.className AS scheduleName, "
                + "s.classDate, s.startTime, s.endTime, a.attendanceStatus "
                + "FROM bookings b JOIN users u ON b.studentID=u.user_id "
                + "JOIN schedules s ON b.scheduleID=s.scheduleID "
                + "LEFT JOIN attendance a ON a.studentID=b.studentID AND a.scheduleID=b.scheduleID "
                + "WHERE s.trainerID=? AND b.bookingStatus='Confirmed' ORDER BY s.classDate DESC, s.startTime, u.full_name";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, trainerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Booking b = new Booking();
                b.setBookingID(rs.getInt("bookingID"));
                b.setScheduleID(rs.getInt("scheduleID"));
                b.setStudentID(rs.getInt("studentID"));
                b.setBookingDate(rs.getTimestamp("bookingDate"));
                b.setBookingStatus(rs.getString("bookingStatus"));
                b.setStudentName(rs.getString("studentName"));
                b.setScheduleName(rs.getString("scheduleName"));
                b.setClassDate(rs.getDate("classDate"));
                b.setStartTime(rs.getTime("startTime"));
                b.setEndTime(rs.getTime("endTime"));
                b.setAttendanceStatus(rs.getString("attendanceStatus"));
                b.setAttendanceOpen(isAttendanceWindowOpen(b.getClassDate(), b.getStartTime(), b.getEndTime()));
                list.add(b);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private boolean isAttendanceWindowOpen(Date date, Time start, Time end) {
        LocalDate today = LocalDate.now();
        LocalTime now = LocalTime.now();
        return date != null && start != null && end != null
                && today.equals(date.toLocalDate())
                && !now.isBefore(start.toLocalTime())
                && !now.isAfter(end.toLocalTime());
    }
}
