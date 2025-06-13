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
    <div class="container">
        <h1>Welcome, <%= loggedUser.getFullName() %>!</h1>
        <p>Your email: <%= loggedUser.getEmail() %></p>
        <p>Your role: <%= loggedUser.getRole() %></p>
        <hr>

        <!-- Clock Widget -->
        <div class="clock">
            <h2>Current Time</h2>
            <p id="time"></p>
        </div>
        <hr>

        <script>
            function updateClock() {
                const now = new Date();
                const timeString = now.toLocaleTimeString('en-US', {
                    hour: '2-digit',
                    minute: '2-digit',
                    second: '2-digit',
                    hour12: true
                });
                document.getElementById('time').textContent = timeString;
            }

            // Initial call and interval update
            updateClock();
            setInterval(updateClock, 1000);
        </script>
    </div>






</div>

</body>
</html>
