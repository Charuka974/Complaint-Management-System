package com.assignment.ijse.controller;

import com.assignment.ijse.DAO.UserDAO;
import com.assignment.ijse.DTO.User;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/ManageUsersAdminServlet")
public class ManageUsersAdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        ServletContext context = getServletContext();
        BasicDataSource dataSource = (BasicDataSource) context.getAttribute("dataSource");

        UserDAO userDAO = new UserDAO(dataSource);

        try {
            List<User> users = userDAO.getAllUsers();
            request.setAttribute("users", users);
            // Forward the users list to the admin JSP
            request.getRequestDispatcher("/web/jsp/dashboard.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Unable to load users.");
            request.getRequestDispatcher("/web/jsp/dashboard.jsp").forward(request, response);
        }
    }



    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ServletContext context = getServletContext();
        BasicDataSource dataSource = (BasicDataSource) context.getAttribute("dataSource");

        UserDAO userDAO = new UserDAO(dataSource);

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        ObjectMapper objectMapper = new ObjectMapper();

        try {
            int userId = Integer.parseInt(request.getParameter("user_id"));
            boolean deleted = userDAO.deleteUser(userId);

            if (deleted) {
                // Return updated list of users
                List<User> users = userDAO.getAllUsers(); // You must implement this method
                String usersJson = objectMapper.writeValueAsString(users);
                out.print(usersJson);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"error\":\"User not found or could not be deleted.\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"Internal server error: " + e.getMessage() + "\"}");
        } finally {
            out.flush();
            out.close();
        }
    }


}
