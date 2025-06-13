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
<%--    <link rel="stylesheet" type="text/css" href="../css/dashboard.css">--%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/web/css/dashboard.css" />
    <script src="../js/dashboard.js" defer></script>

</head>
<body>

<div class="sidebar">
    <h2><%= loggedUser.getRole() %> Panel</h2>
    <%
        if ("ADMIN".equals(loggedUser.getRole())) {
    %>
    <a href="#complaint-manage-panel">Manage Complaints</a>
    <a href="#user-manage-panel">Manage Users</a>
    <%
    } else if ("EMPLOYEE".equals(loggedUser.getRole())) {
    %>
    <a href="#new-complaint-panel">Submit Complaint</a>
    <a href="#my-complaints-panel">My Complaints</a>
    <%
        }
    %>
    <a href="<%= request.getContextPath() %>/LogoutServlet">Logout</a>
</div>

<div class="main-content">
    <h1>Welcome, <%= loggedUser.getFullName() %>!</h1>
    <p>Your email: <%= loggedUser.getEmail() %></p>
    <p>Your role: <%= loggedUser.getRole() %></p>

    <hr>

    <%-- Dynamic content--%>
    <%
        if ("ADMIN".equals(loggedUser.getRole())) {
    %>
        <h2>Admin Overview</h2>
        <div id="complaint-manage-panel" class="content-panel">
            <h3>Manage Complaints</h3>
            <form id="updateComplaintForm" action="${pageContext.request.contextPath}/ManageComplaintAdminServlet" method="post">
                <input type="hidden" name="_method" value="PUT">
                <div class="form-text-group">
                    <label>Title: <label id="readTitle"></label></label>
                    <label>Description: <label id="readDescription"></label></label>
                    <hr>
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
                    <input type="hidden" id="complaintId" name="complaintId" value="6">
                    <label for="complaintRemarks">Remarks</label>
                    <textarea id="complaintRemarks" name="remarks" rows="5" required placeholder="Enter complaint remarks"></textarea>
                </div>

                <div class="form-button-group">
                    <button type="submit"> Update</button>
                    <button type="button"> Delete</button>
                    <button type="reset">Clear</button>
                </div>
            </form>
            <h3>Complaints</h3>

            <form method="get" action="${pageContext.request.contextPath}/ManageComplaintAdminServlet">
                <button type="submit">View My Complaints</button>
            </form>
            <table>
                <thead>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Status</th>
                    <th>Remarks</th>
                    <th>Submitted On</th>
                </thead>
                <%
                    // Retrieve complaints from request attribute (same as in your servlet)
                    List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
                    if (complaints != null && !complaints.isEmpty()) {
                        for (Complaint c : complaints) {
                %>
                <tr>
                    <td><%= c.getComplaintId() %></td>
                    <td><%= c.getTitle() %></td>
                    <td><%= c.getStatus() %></td>
                    <td><%= c.getRemarks() %></td>
                    <td><%= c.getCreatedAt() %></td>
                </tr>
                <%
                    }
                } else {
                %>
                <tr>
                    <td>No complaints found</td>
                </tr>
                <% } %>
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
                </div>
                <div class="form-button-group">
                    <button type="button" id="searchUserBtn">Search</button>
                    <button type="reset" id="Clear">Reset</button>
                    <button type="button" id="deleteUserBtn">Delete</button>
                </div>
            </form>
            <h3>Users</h3>

            <form method="get" action="${pageContext.request.contextPath}/ManageUsersAdminServlet">
                <button type="submit">View All Users</button>
            </form>
            <table>
                <thead>
                    <th>User ID</th>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>Role</th>
                </thead>
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
            </table>


        </div>
    <%
    } else {
    %>
        <h2>Employee Dashboard</h2>
        <div id="new-complaint-panel" class="content-panel">
            <h3>Submit a Complaint</h3>
            <form id="submitComplaintForm" action="${pageContext.request.contextPath}/EmployeeComplaintServlet" method="post">
                <div class="form-text-group">
                    <input type="hidden" id="complaintUserId" name="complaintUserId" value="<%= loggedUser.getId() %>">
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
                    <button type="button" id="editBtn">Edit</button>
                    <button type="button" id="deleteBtn">Delete</button>
                </div>
            </form>
        </div>

        <div id="my-complaints-panel" class="content-panel">
            <h3>My Complaints</h3>

            <form method="get" action="${pageContext.request.contextPath}/EmployeeComplaintServlet">
                <button type="submit">View My Complaints</button>
            </form>
            <table>
                <thead>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Status</th>
                    <th>Remarks</th>
                    <th>Submitted On</th>
                </thead>
                <%
                    // Retrieve complaints from request attribute (same as in your servlet)
                    List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
                    if (complaints != null && !complaints.isEmpty()) {
                        for (Complaint c : complaints) {
                %>
                <tr>
                    <td><%= c.getComplaintId() %></td>
                    <td><%= c.getTitle() %></td>
                    <td><%= c.getStatus() %></td>
                    <td><%= c.getRemarks() %></td>
                    <td><%= c.getCreatedAt() %></td>
                </tr>
                <%
                    }
                } else {
                %>
                <tr>
                    <td>No complaints found</td>
                </tr>
                <% } %>
            </table>

        </div>

    <%
        }
    %>
</div>

</body>
</html>
