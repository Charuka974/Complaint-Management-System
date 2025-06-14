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
import jakarta.servlet.http.HttpSession;
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/ManageUsersAdminServlet")
public class ManageUsersAdminServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        ServletContext context = getServletContext();
        BasicDataSource dataSource = (BasicDataSource) context.getAttribute("dataSource");
        userDAO = new UserDAO(dataSource);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("web/jsp/login.jsp?error=Unauthorized+access");
            return;
        }

        try {
            List<User> users = userDAO.getAllUsers();
            request.setAttribute("users", users);
            request.getRequestDispatcher("/web/jsp/manageUsersAdmin.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Unable to load users.");
            request.getRequestDispatcher("/web/jsp/manageUsersAdmin.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("web/jsp/login.jsp?error=Unauthorized+access");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect("web/jsp/manageUsersAdmin.jsp?error=Missing+action");
            return;
        }

        try {
            switch (action.toLowerCase()) {
                case "delete":
                    handleDelete(request, response);
                    break;
                case "search":
                    handleSearch(request, response);
                    break;
                default:
                    response.sendRedirect("web/jsp/manageUsersAdmin.jsp?error=Invalid+action");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("web/jsp/manageUsersAdmin.jsp?error=Server+error");
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        int userId = Integer.parseInt(request.getParameter("userId"));

        boolean success = userDAO.deleteUser(userId);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/ManageUsersAdminServlet?success=User+deleted");
        } else {
            response.sendRedirect("web/jsp/manageUsersAdmin.jsp?error=Delete+failed");
        }
    }

    private void handleSearch(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        String name = request.getParameter("userName");
        String email = request.getParameter("userEmail");

        List<User> filteredUsers;

        if ((name == null || name.isBlank()) && (email == null || email.isBlank())) {
            filteredUsers = userDAO.getAllUsers();
        } else if (name != null && !name.isBlank() && email != null && !email.isBlank()) {
            filteredUsers = userDAO.getUsersByNameAndEmail(name, email);
        } else if (name != null && !name.isBlank()) {
            filteredUsers = userDAO.getUsersByName(name);
        } else {
            filteredUsers = userDAO.getUserByEmail(email);
        }

        request.setAttribute("users", filteredUsers);
        request.getRequestDispatcher("/web/jsp/manageUsersAdmin.jsp").forward(request, response);
    }




}
