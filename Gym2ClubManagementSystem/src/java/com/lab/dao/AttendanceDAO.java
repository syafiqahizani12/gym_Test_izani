package com.lab.dao;

import com.lab.model.Attendance;
import com.lab.model.Schedule;
import com.lab.util.DBConnection;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class AttendanceDAO {

    public enum CheckInResult { SUCCESS, ALREADY_CHECKED_IN, NOT_BOOKED, OUTSIDE_CLASS_TIME, ERROR }

    public CheckInResult checkIn(int studentId, int scheduleId) {
        String eligibilitySql = "SELECT s.classDate, s.startTime, s.endTime, a.attendanceStatus "
                + "FROM bookings b JOIN schedules s ON b.scheduleID=s.scheduleID "
                + "JOIN membership m ON m.studentID=b.studentID AND m.membershipType=s.planType "
                + "LEFT JOIN attendance a ON a.studentID=b.studentID AND a.scheduleID=b.scheduleID "
                + "WHERE b.studentID=? AND b.scheduleID=? AND b.bookingStatus='Confirmed' AND m.status='Active'";
        String upsertSql = "INSERT INTO attendance (studentID,scheduleID,checkInTime,attendanceStatus) VALUES (?,?,?,'Present') "
                + "ON DUPLICATE KEY UPDATE checkInTime=VALUES(checkInTime), attendanceStatus='Present'";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement eligibility = conn.prepareStatement(eligibilitySql)) {
            eligibility.setInt(1, studentId);
            eligibility.setInt(2, scheduleId);
            ResultSet rs = eligibility.executeQuery();
            if (!rs.next()) return CheckInResult.NOT_BOOKED;
            if (!isAttendanceWindowOpen(rs.getDate("classDate"), rs.getTime("startTime"), rs.getTime("endTime"))) {
                return CheckInResult.OUTSIDE_CLASS_TIME;
            }
            if ("Present".equalsIgnoreCase(rs.getString("attendanceStatus"))) {
                return CheckInResult.ALREADY_CHECKED_IN;
            }
            try (PreparedStatement upsert = conn.prepareStatement(upsertSql)) {
                upsert.setInt(1, studentId);
                upsert.setInt(2, scheduleId);
                upsert.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
                return upsert.executeUpdate() > 0 ? CheckInResult.SUCCESS : CheckInResult.ERROR;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return CheckInResult.ERROR;
        }
    }

    public boolean checkOut(int attendanceId, int studentId) {
        String sql = "UPDATE attendance SET checkOutTime=? WHERE attendanceID=? AND studentID=? AND attendanceStatus='Present'";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            ps.setInt(2, attendanceId);
            ps.setInt(3, studentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean markAttendanceByTrainer(int scheduleId, int studentId, int trainerId, String status) {
        if (!("Present".equals(status) || "Absent".equals(status))) return false;
        String eligibilitySql = "SELECT s.classDate,s.startTime,s.endTime FROM bookings b "
                + "JOIN schedules s ON b.scheduleID=s.scheduleID "
                + "WHERE b.studentID=? AND b.scheduleID=? AND b.bookingStatus='Confirmed' AND s.trainerID=?";
        String upsertSql = "INSERT INTO attendance(studentID,scheduleID,checkInTime,attendanceStatus) VALUES(?,?,?,?) "
                + "ON DUPLICATE KEY UPDATE attendanceStatus=VALUES(attendanceStatus), "
                + "checkInTime=IF(VALUES(attendanceStatus)='Present',COALESCE(checkInTime,VALUES(checkInTime)),checkInTime)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement eligibility = conn.prepareStatement(eligibilitySql)) {
            eligibility.setInt(1, studentId);
            eligibility.setInt(2, scheduleId);
            eligibility.setInt(3, trainerId);
            ResultSet rs = eligibility.executeQuery();
            if (!rs.next() || !isAttendanceWindowOpen(rs.getDate("classDate"), rs.getTime("startTime"), rs.getTime("endTime"))) {
                return false;
            }
            try (PreparedStatement upsert = conn.prepareStatement(upsertSql)) {
                upsert.setInt(1, studentId);
                upsert.setInt(2, scheduleId);
                upsert.setTimestamp(3, "Present".equals(status) ? new Timestamp(System.currentTimeMillis()) : null);
                upsert.setString(4, status);
                return upsert.executeUpdate() > 0;
            }
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<Schedule> getBookedSchedulesForCheckIn(int studentId) {
        List<Schedule> list = new ArrayList<>();
        String sql = "SELECT s.*,u.full_name AS trainerName,a.attendanceStatus FROM bookings b "
                + "JOIN schedules s ON b.scheduleID=s.scheduleID JOIN users u ON s.trainerID=u.user_id "
                + "JOIN membership m ON m.studentID=b.studentID AND m.membershipType=s.planType "
                + "LEFT JOIN attendance a ON a.studentID=b.studentID AND a.scheduleID=b.scheduleID "
                + "WHERE b.studentID=? AND b.bookingStatus='Confirmed' AND m.status='Active' "
                + "ORDER BY s.classDate DESC,s.startTime";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
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
                s.setCheckedIn("Present".equalsIgnoreCase(rs.getString("attendanceStatus")));
                s.setCheckInOpen(isAttendanceWindowOpen(s.getClassDate(), s.getStartTime(), s.getEndTime()));
                list.add(s);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Attendance> getAttendanceByStudent(int studentId) {
        return queryAttendance("WHERE a.studentID=?", studentId);
    }

    public List<Attendance> getAttendanceBySchedule(int scheduleId) {
        return queryAttendance("WHERE a.scheduleID=?", scheduleId);
    }

    public List<Attendance> getAttendanceByTrainer(int trainerId) {
        return queryAttendance("WHERE s.trainerID=? AND EXISTS (SELECT 1 FROM bookings b "
                + "WHERE b.studentID=a.studentID AND b.scheduleID=a.scheduleID AND b.bookingStatus='Confirmed')", trainerId);
    }

    public List<Attendance> getAllAttendance() {
        return queryAttendance("", null);
    }

    private List<Attendance> queryAttendance(String where, Integer id) {
        List<Attendance> list = new ArrayList<>();
        String sql = "SELECT a.*,u.full_name AS studentName,s.className AS scheduleName FROM attendance a "
                + "JOIN users u ON a.studentID=u.user_id JOIN schedules s ON a.scheduleID=s.scheduleID "
                + where + " ORDER BY s.classDate DESC,s.startTime,u.full_name";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            if (id != null) ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapAttendance(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private Attendance mapAttendance(ResultSet rs) throws SQLException {
        Attendance a = new Attendance();
        a.setAttendanceID(rs.getInt("attendanceID"));
        a.setStudentID(rs.getInt("studentID"));
        a.setScheduleID(rs.getInt("scheduleID"));
        a.setCheckInTime(rs.getTimestamp("checkInTime"));
        a.setCheckOutTime(rs.getTimestamp("checkOutTime"));
        a.setAttendanceStatus(rs.getString("attendanceStatus"));
        a.setStudentName(rs.getString("studentName"));
        a.setScheduleName(rs.getString("scheduleName"));
        return a;
    }

    private boolean isAttendanceWindowOpen(Date date, Time start, Time end) {
        LocalDate today = LocalDate.now();
        LocalTime now = LocalTime.now();
        return date != null && start != null && end != null && today.equals(date.toLocalDate())
                && !now.isBefore(start.toLocalTime()) && !now.isAfter(end.toLocalTime());
    }
}
