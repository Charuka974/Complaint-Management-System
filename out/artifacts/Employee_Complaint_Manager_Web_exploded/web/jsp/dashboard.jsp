<%@ page import="com.assignment.ijse.DTO.User" %>
<%@ page import="com.assignment.ijse.DAO.UserDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="com.assignment.ijse.DTO.Complaint" %>

<%
    User loggedUser = (User) session.getAttribute("user");
    if (loggedUser == null) {
        response.sendRedirect("login.jsp?login-error=Please+login+first");
        return;
    }
%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/web/css/dashboard.css" />
    <script src="${pageContext.request.contextPath}/web/js/dashboard.js" defer></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>

<div class="sidebar">
    <h2><%= loggedUser.getRole() %> Panel</h2>

    <% if ("ADMIN".equals(loggedUser.getRole())) { %>
    <a href="${pageContext.request.contextPath}/ManageComplaintAdminServlet">Manage Complaints</a>
    <a href="${pageContext.request.contextPath}/ManageUsersAdminServlet">Manage Users</a>
    <% } else if ("EMPLOYEE".equals(loggedUser.getRole())) { %>
    <a href="${pageContext.request.contextPath}/EmployeeComplaintServlet">My Complaints</a>
    <% } %>

    <a href="<%= request.getContextPath() %>/LogoutServlet">Logout</a>
</div>

<div class="main-content">
    <h1>Welcome, <%= loggedUser.getFullName() %>!</h1>
    <p>Your email: <%= loggedUser.getEmail() %></p>
    <p>Your role: <%= loggedUser.getRole() %></p>
    <hr>


</div>

</body>
</html>
