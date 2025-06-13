package com.assignment.ijse.DAO;

import com.assignment.ijse.DTO.Complaint;
import com.assignment.ijse.DTO.User;
import org.apache.commons.dbcp2.BasicDataSource;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ComplaintDAO {

    private final BasicDataSource dataSource;

    public ComplaintDAO(BasicDataSource dataSource) {
        this.dataSource = dataSource;
    }


    public boolean updateComplaintByAdmin(int complaintId, String remark, String status) throws SQLException {
        String sql = "UPDATE complaints SET status = ?, remarks = ? WHERE complaint_id = ?";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setString(2, remark);
            stmt.setInt(3, complaintId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    public boolean deleteComplaintByAdmin(int complaintId) throws SQLException {
        String sql = "DELETE FROM complaints WHERE complaint_id = ?";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, complaintId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    public List<Complaint> getComplaintsByUser(int userId) throws SQLException {
        List<Complaint> complaints = new ArrayList<>();
        String sql = "SELECT * FROM complaints WHERE user_id = ? ORDER BY created_at DESC";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    complaints.add(mapRowToComplaint(rs));
                }
            }
        }
        return complaints;
    }

    public List<Complaint> getComplaintsByStatus(String status) throws SQLException {
        List<Complaint> complaints = new ArrayList<>();
        String sql = "SELECT * FROM complaints WHERE status = ? ORDER BY created_at DESC";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    complaints.add(mapRowToComplaint(rs));
                }
            }
        }
        return complaints;
    }

    public List<Complaint> getAllComplaints() throws SQLException {
        List<Complaint> complaints = new ArrayList<>();
        String sql = "SELECT * FROM complaints ORDER BY created_at DESC";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                complaints.add(mapRowToComplaint(rs));
            }
        }
        return complaints;
    }





    // Employee
    public boolean saveComplaint(Complaint complaint) throws SQLException {
        String sql = "INSERT INTO complaints (user_id, title, description, status, remarks) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, complaint.getUserId());
            stmt.setString(2, complaint.getTitle());
            stmt.setString(3, complaint.getDescription());
            stmt.setString(4, complaint.getStatus());
            stmt.setString(5, complaint.getRemarks());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    public boolean updateComplaintByEmployee(int id, String title, String description) throws SQLException {
        String sql = "UPDATE complaints SET title = ?, description = ? WHERE complaint_id = ?";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, title);
            stmt.setString(2, description);
            stmt.setInt(3, id);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    public boolean deleteComplaintByEmployee(int complaintId, int userId) throws SQLException {
        String sql = "DELETE FROM complaints WHERE complaint_id = ? AND user_id = ?";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, complaintId);
            stmt.setInt(2, userId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    public List<Complaint> getComplaintsByEmployee(int userId) throws SQLException {
        List<Complaint> complaints = new ArrayList<>();
        String sql = "SELECT * FROM complaints WHERE user_id = ? ORDER BY created_at DESC";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    complaints.add(mapRowToComplaint(rs));
                }
            }
        }
        return complaints;
    }








    //  Helper Method
    private Complaint mapRowToComplaint(ResultSet rs) throws SQLException {
        Complaint complaint = new Complaint();
        complaint.setComplaintId(rs.getInt("complaint_id"));
        complaint.setUserId(rs.getInt("user_id"));
        complaint.setTitle(rs.getString("title"));
        complaint.setDescription(rs.getString("description"));
        complaint.setStatus(rs.getString("status"));
        complaint.setRemarks(rs.getString("remarks"));
        complaint.setCreatedAt(rs.getTimestamp("created_at"));
        complaint.setUpdatedAt(rs.getTimestamp("updated_at"));
        return complaint;
    }

}
