package com.assignment.ijse.controller;

import com.assignment.ijse.DAO.ComplaintDAO;
import com.assignment.ijse.DTO.Complaint;
import com.assignment.ijse.DTO.User;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/EmployeeComplaintServlet")
public class EmployeeComplaintServlet extends HttpServlet {
    private ComplaintDAO complaintDAO;

    @Override
    public void init() throws ServletException {
        ServletContext context = getServletContext();
        BasicDataSource dataSource = (BasicDataSource) context.getAttribute("dataSource");
        complaintDAO = new ComplaintDAO(dataSource);
    }

    // 📝 Handle Complaint Submission
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"EMPLOYEE".equals(user.getRole())) {
            response.sendRedirect("web/jsp/login.jsp?error=Please+login+as+employee");
            return;
        }

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        int userId = Integer.parseInt(request.getParameter("complaintUserId"));

        Complaint complaint = new Complaint();
        complaint.setUserId(userId);
        complaint.setTitle(title);
        complaint.setDescription(description);
        complaint.setStatus("PENDING");
        complaint.setRemarks("");

        try {
            boolean success = complaintDAO.saveComplaint(complaint);
            if (success) {
                response.sendRedirect("web/jsp/dashboard.jsp?success=Complaint+submitted");
            } else {
                response.sendRedirect("web/jsp/dashboard.jsp?error=Submission+failed");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("web/jsp/dashboard.jsp?error=Server+error");
        }
    }

    // 📄 View All Complaints by Employee
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"EMPLOYEE".equals(user.getRole())) {
            response.sendRedirect("web/jsp/login.jsp?error=Unauthorized+access");
            return;
        }

        try {
            List<Complaint> complaints = complaintDAO.getComplaintsByUser(user.getId());
            request.setAttribute("complaints", complaints);
            request.getRequestDispatcher("web/jsp/dashboard.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("web/jsp/dashboard.jsp?error=Unable+to+load+your+complaints");
        }
    }

}
