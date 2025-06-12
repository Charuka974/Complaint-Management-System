package com.assignment.ijse.controller;

import com.assignment.ijse.DTO.User;
import com.assignment.ijse.model.UserModel;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Map;
import java.util.UUID;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve form parameters
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // Access the shared DataSource from context
        ServletContext servletContext = getServletContext();
        BasicDataSource dataSource = (BasicDataSource) servletContext.getAttribute("dataSource");

        UserModel userModel = new UserModel(dataSource);

        try {
            // Create and populate the User object
            User user = new User();
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPassword(password); // You should hash this in production
            user.setRole(role);

            // Try to create user in DB
            boolean created = userModel.createUser(user);

            if (created) {
                // Optionally store user in session or redirect to login
                response.sendRedirect("web/jsp/login.jsp?register-msg=Account+created");
            } else {
                response.sendRedirect("web/jsp/register.jsp?register-msg=Could+not+create+user");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("web/jsp/register.jsp?register-msg=Server+error");
        }
    }



}
