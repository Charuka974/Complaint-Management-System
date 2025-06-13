<%@ page import="com.assignment.ijse.DTO.User" %>
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/web/css/manage-complaints-admin.css" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</head>
<body>

<div class="sidebar">
    <h2><%= loggedUser.getRole() %> Panel</h2>
    <a href="${pageContext.request.contextPath}/ManageComplaintAdminServlet">Manage Complaints</a>
    <a href="#user-manage-panel">Manage Users</a>
    <a href="<%= request.getContextPath() %>/LogoutServlet">Logout</a>
</div>

<div class="main-content">
    <h1>Welcome, <%= loggedUser.getFullName() %>!</h1>
    <p>Your email: <%= loggedUser.getEmail() %></p>
    <p>Your role: <%= loggedUser.getRole() %></p>

    <hr>
    <h2>Admin Overview</h2>

    <div id="user-manage-panel" class="content-panel">
        <h3>Manage Users</h3>

        <form>
            <div class="form-text-group">
                <input type="hidden" id="userIdInput" name="userId">

                <label for="userNameInput">
                    User Name:
                    <input type="text" id="userNameInput" name="userName" placeholder="Enter user name to search">
                </label>

                <label for="userEmailInput">
                    User Email:
                    <input type="email" id="userEmailInput" name="userEmail" placeholder="Enter user email to search">
                </label>
            </div>

            <div class="form-button-group">
                <button type="button" id="searchUserBtn">Search</button>
                <button type="reset">Reset</button>
                <button type="button" id="deleteUserBtn">Delete</button>
            </div>
        </form>

        <h3>Users</h3>

        <form method="get" action="${pageContext.request.contextPath}/ManageUsersAdminServlet">
            <button type="submit">View All Users</button>
        </form>

        <table>
            <thead>
            <tr>
                <th>User ID</th>
                <th>Full Name</th>
                <th>Email</th>
                <th>Role</th>
            </tr>
            </thead>
            <tbody>
            <%
                List<User> users = (List<User>) request.getAttribute("users");
                if (users != null && !users.isEmpty()) {
                    for (User user : users) {
            %>
            <tr>
                <td><%= user.getId() %></td>
                <td><%= user.getFullName() %></td>
                <td><%= user.getEmail() %></td>
                <td><%= user.getRole() %></td>
            </tr>
            <%
                }
            } else {
            %>
            <tr>
                <td>No users found</td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>

</div>

</body>
</html>
