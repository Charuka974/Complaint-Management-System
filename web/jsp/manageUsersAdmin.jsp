<%@ page import="com.assignment.ijse.DTO.User" %>
<%@ page import="java.util.List" %>
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
    <title>Manage Users</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/web/css/manage-users-admin.css" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="${pageContext.request.contextPath}/web/js/manageUsersAdmin.js" defer></script>
</head>
<body>

<%
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        <% if (success != null) { %>
        Swal.fire({
            icon: "success",
            title: "Success",
            text: "<%= success %>",
            timer: 1500,
            showConfirmButton: false
        }).then(() => {
            window.history.replaceState({}, document.title, window.location.pathname); // Clear the URL parameters
        });
        <% } else if (error != null) { %>
        Swal.fire({
            icon: "error",
            title: "Error",
            text: "<%= error %>",
            showConfirmButton: true
        }).then(() => {
            window.history.replaceState({}, document.title, window.location.pathname);
        });
        <% } %>
    });
</script>


<div class="sidebar">
    <h2><%= loggedUser.getRole() %> Panel</h2>
    <a href="${pageContext.request.contextPath}/ManageComplaintAdminServlet">Manage Complaints</a>
    <a href="${pageContext.request.contextPath}/ManageUsersAdminServlet">Manage Users</a>
    <a href="<%= request.getContextPath() %>/LogoutServlet">Logout</a>
</div>

<div class="main-content">
    <h1>Welcome, <%= loggedUser.getFullName() %>!</h1>
    <p>Your email: <%= loggedUser.getEmail() %></p>
    <p>Your role: <%= loggedUser.getRole() %></p>

    <hr>
    <h2>Manage Users</h2>

    <div id="user-manage-panel" class="content-panel">
        <h3>Search or Delete Users</h3>

        <form method="post" action="${pageContext.request.contextPath}/ManageUsersAdminServlet" id="searchUserForm">
            <input type="hidden" name="action" value="search">
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
                <button type="submit">Search</button>
                <button type="reset">Reset</button>
            </div>
        </form>

        <form method="post" action="${pageContext.request.contextPath}/ManageUsersAdminServlet" id="deleteUserForm">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" id="deleteUserId" name="userId">
            <button type="button" id="deleteUserBtn">Delete Selected User</button>
        </form>

        <h3>Users</h3>

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
            <tr onclick="selectUser('<%= user.getId() %>', '<%= user.getFullName() %>', '<%= user.getEmail() %>')">
                <td><%= user.getId() %></td>
                <td><%= user.getFullName() %></td>
                <td><%= user.getEmail() %></td>
                <td><%= user.getRole() %></td>
            </tr>
            <%
                }
            } else {
            %>
            <tr><td colspan="4">No users found</td></tr>
            <% } %>
            </tbody>
        </table>
    </div>
</div>

<%--<script>--%>
<%--</script>--%>

</body>
</html>
