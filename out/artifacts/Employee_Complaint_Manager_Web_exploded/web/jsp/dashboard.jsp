<%@ page import="com.assignment.ijse.DTO.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp?login-error=Please+login+first");
        return;
    }
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
    <link rel="stylesheet" type="text/css" href="../css/dashboard.css">
    <script src="../js/dashboard.js" defer></script>

</head>
<body>

<div class="sidebar">
    <h2><%= user.getRole() %> Panel</h2>
    <%
        if ("ADMIN".equals(user.getRole())) {
    %>
    <a href="#complaint-manage-panel">Manage Complaints</a>
    <a href="#user-manage-panel">Manage Users</a>
    <%
    } else if ("EMPLOYEE".equals(user.getRole())) {
    %>
    <a href="#new-complaint-panel">Submit Complaint</a>
    <a href="#my-complaints-panel">My Complaints</a>
    <%
        }
    %>

    <a href="<%= request.getContextPath() %>/LogoutServlet">Logout</a>

</div>

<div class="main-content">
    <h1>Welcome, <%= user.getFullName() %>!</h1>
    <p>Your email: <%= user.getEmail() %></p>
    <p>Your role: <%= user.getRole() %></p>

    <hr>

    <%-- Dynamic content area --%>
    <%
        if ("ADMIN".equals(user.getRole())) {
    %>
        <h2>Admin Overview</h2>
        <div id="complaint-manage-panel" class="content-panel">
            <h3>Manage Complaints</h3>
            <form id="updateComplaintForm">
                <div class="form-text-group">
                    <label>Title: <label id="readTitle"></label></label>
                    <label>Description: <label id="readDescription"></label></label>
                    <hr style="">
                </div>
                <div class="form-text-group">
                    <label for="complaintStatus">Status</label>
                    <select id="complaintStatus" name="status" required>
                        <option value="PENDING">Pending</option>
                        <option value="IN_PROGRESS">In Progress</option>
                        <option value="RESOLVED">Resolved</option>
                    </select>
                </div>
                <div class="form-text-group">
                    <label for="complaintRemarks">Remarks</label>
                    <textarea id="complaintRemarks" name="remarks" rows="5" required placeholder="Enter complaint remarks"></textarea>
                </div>

                <div class="form-button-group">
                    <button type="button"> Update</button>
                    <button type="button"> Delete</button>
                    <button type="reset">Clear</button>
                </div>
            </form>
            <h3>Complaints</h3>
            <table>
                <thead>
                <tr>
                    <th>Complaint ID</th>
                    <th>Title</th>
                    <th>Status</th>
                    <th>Remarks</th>
                    <th>Created At</th>
                </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>

        <div id="user-manage-panel" class="content-panel">
            <h3>Manage Users</h3>
            <form>
                <div class="form-text-group">
                    <input type="hidden" id="userIdInput" name="userId">
                    <label for="userNameInput">User Name:
                        <input type="text" id="userNameInput" name="userName" placeholder="Enter user name to search">
                    </label>
                    <label for="userEmailInput">User Email:
                        <input type="email" id="userEmailInput" name="userEmail" placeholder="Enter user email to search">
                    </label>
                    <label>User Role:
                        <select id="userRoleInput" name="userRole">
                            <option value="">All</option>
                            <option value="EMPLOYEE">Employee</option>
                            <option value="ADMIN">Admin</option>
                        </select>
                    </label>
                </div>
                <div class="form-button-group">
                    <button type="button" id="searchUserBtn">Search</button>
                    <button type="reset" id="Clear">Reset</button>
                    <button type="button" id="deleteUserBtn">Delete</button>
                </div>
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
                </tbody>
            </table>
        </div>
    <%
    } else {
    %>
        <h2>Employee Dashboard</h2>
        <div id="new-complaint-panel" class="content-panel">
            <h3>Submit a Complaint</h3>
            <form id="submitComplaintForm">
                <div class="form-text-group">
                    <input type="hidden" id="complaintUserId" name="complaintUserId" value="<%= user.getId() %>">
                    <label for="complaintTitle">Title</label>
                    <input type="text" id="complaintTitle" name="title" required placeholder="Enter complaint title">
                </div>

                <div class="form-text-group">
                    <label for="complaintDescription">Description</label>
                    <textarea id="complaintDescription" name="description" rows="5" required placeholder="Describe the issue"></textarea>
                </div>

                <div class="form-button-group">
                    <button type="submit">Submit Complaint</button>
                    <button type="reset">Clear</button>
                    <button type="button"> Edit</button>
                    <button type="button"> Delete</button>
                </div>
            </form>
        </div>

        <div id="my-complaints-panel" class="content-panel">
            <h3>My Complaints</h3>
            <table>
                <thead>
                <tr>
                    <th>Complaint ID</th>
                    <th>Title</th>
                    <th>Status</th>
                    <th>Remarks</th>
                    <th>Created At</th>
                </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>

    <%
        }
    %>
</div>

</body>
</html>
