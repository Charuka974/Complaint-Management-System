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
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/ManageComplaintAdminServlet")
public class ManageComplaintAdminServlet extends HttpServlet {

    private ComplaintDAO complaintDAO;

    @Override
    public void init() throws ServletException {
        ServletContext context = getServletContext();
        BasicDataSource dataSource = (BasicDataSource) context.getAttribute("dataSource");
        complaintDAO = new ComplaintDAO(dataSource);
    }

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String method = request.getParameter("_method");

        if ("PUT".equalsIgnoreCase(method)) {
            doPut(request, response);
        } else {
            super.service(request, response);
        }
    }


    // Handle complaint submission (from employee form)
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");

        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("web/jsp/login.jsp?error=Unauthorized+access");
            return;
        }

        try {
            // Parse parameters from request
            int complaintId = Integer.parseInt(request.getParameter("complaintId"));
            String status = request.getParameter("status");
            String remarks = request.getParameter("remarks");

            Complaint complaint = new Complaint();
            complaint.setComplaintId(complaintId);
            complaint.setStatus(status);
            complaint.setRemarks(remarks);

            boolean updated = complaintDAO.updateComplaintAdmin(complaint);

            if (updated) {
                response.sendRedirect("web/jsp/dashboard.jsp?success=Complaint+updated");
            } else {
                response.sendRedirect("web/jsp/dashboard.jsp?error=Update+failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("web/jsp/dashboard.jsp?error=Server+error");
        }
    }


    // Handle listing complaints (GET)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");

        if (user == null) {
            response.sendRedirect("web/jsp/login.jsp?error=Please+login+first");
            return;
        }

        try {
            List<Complaint> complaints;

            // Assuming you want to show complaints related to the logged-in user
            if ("ADMIN".equals(user.getRole())) {
                complaints = complaintDAO.getAllComplaints();
            } else {
                complaints = complaintDAO.getComplaintsByUser(user.getId());
            }

            request.setAttribute("complaints", complaints);
            request.getRequestDispatcher("web/jsp/dashboard.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("web/jsp/dashboard.jsp?error=Unable+to+load+complaints");
        }
    }


}
