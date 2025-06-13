package com.assignment.ijse.DTO;

import lombok.*;

import java.sql.Timestamp;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class Complaint {
    private int complaintId;
    private int userId;
    private String title;
    private String description;
    private String status;      // PENDING, IN_PROGRESS, RESOLVED
    private String remarks;
    private Timestamp createdAt;
    private Timestamp updatedAt;
}
