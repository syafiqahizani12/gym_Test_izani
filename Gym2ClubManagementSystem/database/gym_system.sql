CREATE DATABASE IF NOT EXISTS gym_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE gym_system;

CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone_number VARCHAR(20) NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('Member','Trainer','Manager') NOT NULL DEFAULT 'Member',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS membership (
    membershipID INT AUTO_INCREMENT PRIMARY KEY,
    studentID INT NOT NULL UNIQUE,
    membershipType ENUM('Basic','Premium','Elite') NOT NULL,
    startDate DATE NULL,
    expiryDate DATE NULL,
    status ENUM('Pending','Active','Expired','Suspended') NOT NULL DEFAULT 'Pending',
    CONSTRAINT fk_membership_student FOREIGN KEY (studentID) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS bills (
    billID INT AUTO_INCREMENT PRIMARY KEY,
    studentID INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    planType ENUM('Basic','Premium','Elite') NOT NULL,
    dueDate DATE NOT NULL,
    status ENUM('Pending','Paid','Overdue') NOT NULL DEFAULT 'Pending',
    CONSTRAINT fk_bill_student FOREIGN KEY (studentID) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS payments (
    paymentID INT AUTO_INCREMENT PRIMARY KEY,
    billID INT NOT NULL,
    paymentDate DATE NOT NULL,
    paymentMethod VARCHAR(50) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    status ENUM('Pending','Approved','Rejected') NOT NULL DEFAULT 'Pending',
    proofPath VARCHAR(500) NOT NULL,
    proofFileName VARCHAR(255) NOT NULL,
    CONSTRAINT fk_payment_bill FOREIGN KEY (billID) REFERENCES bills(billID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS schedules (
    scheduleID INT AUTO_INCREMENT PRIMARY KEY,
    className VARCHAR(100) NOT NULL,
    trainerID INT NOT NULL,
    classDate DATE NOT NULL,
    startTime TIME NOT NULL,
    endTime TIME NOT NULL,
    capacity INT NOT NULL,
    planType ENUM('Basic','Premium','Elite') NOT NULL DEFAULT 'Basic',
    CONSTRAINT fk_schedule_trainer FOREIGN KEY (trainerID) REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS bookings (
    bookingID INT AUTO_INCREMENT PRIMARY KEY,
    scheduleID INT NOT NULL,
    studentID INT NOT NULL,
    bookingDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    bookingStatus ENUM('Confirmed','Cancelled') NOT NULL DEFAULT 'Confirmed',
    CONSTRAINT fk_booking_schedule FOREIGN KEY (scheduleID) REFERENCES schedules(scheduleID) ON DELETE CASCADE,
    CONSTRAINT fk_booking_student FOREIGN KEY (studentID) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_booking_unique_active (studentID, scheduleID, bookingStatus)
);

CREATE TABLE IF NOT EXISTS attendance (
    attendanceID INT AUTO_INCREMENT PRIMARY KEY,
    studentID INT NOT NULL,
    scheduleID INT NOT NULL,
    checkInTime TIMESTAMP NULL,
    checkOutTime TIMESTAMP NULL,
    attendanceStatus ENUM('Present','Absent') NOT NULL DEFAULT 'Present',
    CONSTRAINT fk_attendance_student FOREIGN KEY (studentID) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_attendance_schedule FOREIGN KEY (scheduleID) REFERENCES schedules(scheduleID) ON DELETE CASCADE,
    UNIQUE KEY uq_attendance (studentID, scheduleID)
);
