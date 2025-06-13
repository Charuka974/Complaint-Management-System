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
('admin123', 'Alice Fernando', 'alice@example.com', 'ADMIN'),
('admin456', 'Bob Silva', 'bob@example.com', 'ADMIN'),
('emp001', 'Chathura Perera', 'chathura@example.com', 'EMPLOYEE'),
('emp002', 'Dilani Weerasinghe', 'dilani@example.com', 'EMPLOYEE'),
('emp003', 'Ruwan Gunasekara', 'ruwan@example.com', 'EMPLOYEE');


INSERT INTO complaints (user_id, title, description, status, remarks)
VALUES
(3, 'Monitor Not Working', 'The screen is blank and won’t turn on.', 'PENDING', ''),
(3, 'Keyboard Malfunction', 'Several keys are not responsive.', 'IN_PROGRESS', 'Replacement requested'),
(3, 'System Slowdown', 'Computer is extremely slow to respond.', 'RESOLVED', 'RAM upgrade done'),
(4, 'No Internet Access', 'Wi-Fi is not connecting since morning.', 'PENDING', ''),
(4, 'Broken Desk Lamp', 'Desk lamp flickers continuously.', 'RESOLVED', 'Replaced bulb on 2025-06-10'),
(4, 'Phone Line Down', 'Unable to make calls from desk phone.', 'IN_PROGRESS', 'Telecom team investigating'),
(5, 'AC Leaking', 'Water dripping from the AC unit.', 'PENDING', ''),
(5, 'Software Not Installed', 'Need MS Project installed for upcoming tasks.', 'RESOLVED', 'Installed on 2025-06-12'),
(5, 'Mouse Lagging', 'Mouse pointer freezes intermittently.', 'IN_PROGRESS', 'Checked driver compatibility'),
(5, 'Chair Adjustment Issue', 'Office chair cannot be adjusted.', 'RESOLVED', 'Hydraulics fixed');

SELECT * FROM complaints;
SELECT * FROM users;