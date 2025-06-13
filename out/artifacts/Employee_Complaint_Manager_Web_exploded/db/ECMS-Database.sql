-- Database: employee_complaint_management_system
DROP database ECMS;
CREATE DATABASE IF NOT EXISTS ECMS;
USE ECMS;

-- Table: users
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    role ENUM('EMPLOYEE', 'ADMIN') NOT NULL
);

-- Table: complaints
CREATE TABLE complaints (
    complaint_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    status ENUM('PENDING', 'IN_PROGRESS', 'RESOLVED') DEFAULT 'PENDING',
    remarks TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

INSERT INTO users (password, full_name, email, role)
VALUES 
('5678', 'John Doe', 'jdoe@example.com', 'EMPLOYEE'),
('1234', 'Theodore Jang', 'theoj@example.com', 'ADMIN');

INSERT INTO complaints (user_id, title, description, status, remarks)
VALUES 
(1, 'Internet Issue', 'No internet connectivity in office block B since morning.', 'PENDING', ''),
(1, 'Broken Chair', 'Chair in cubicle 15 is broken and unsafe.', 'IN_PROGRESS', 'Maintenance scheduled'),
(1, 'Software License Expired', 'Photoshop license expired, unable to complete design tasks.', 'RESOLVED', 'Renewed on 2024-12-01'),
(1, 'Air Conditioning Not Working', 'AC not functioning in meeting room 2.', 'PENDING', ''),
(2, 'Printer Out of Ink', 'Cannot print in lab room 3. Please refill.', 'RESOLVED', 'Ink replaced on 2025-06-01');

SELECT * FROM complaints;