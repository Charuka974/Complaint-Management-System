package com.assignment.ijse.controller;

import com.assignment.ijse.DTO.User;
import com.assignment.ijse.model.UserModel;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String email = request.getParameter("loginEmail");
        String password = request.getParameter("loginPassword");

        ServletContext context = getServletContext();
        BasicDataSource dataSource = (BasicDataSource) context.getAttribute("dataSource");

        UserModel userModel = new UserModel(dataSource);

        try {
            User user = userModel.validateUser(email, password);

            if (user != null) {
                // Store user in session
                request.getSession().setAttribute("user", user);

                // Redirect with email and role and id as query parameters
                response.sendRedirect("web/jsp/dashboard.jsp?email=" + user.getEmail() + "&role=" + user.getRole() + "&id=" + user.getId());
            } else {
                response.sendRedirect("web/jsp/login.jsp?login-error=Invalid+credentials");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("web/jsp/login.jsp?login-error=Server+error");
        }

    }

}
