package com.assignment.ijse.DTO;

import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class User {
    private int id;
    private String fullName;
    private String email;
    private String password;
    private String role;

}
