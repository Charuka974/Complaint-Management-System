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
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

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
            <%
                String action = request.getAttribute("action") != null ? (String) request.getAttribute("action") : "save";
                Complaint selectedComplaint = (Complaint) request.getAttribute("selectedComplaint");
            %>
            <form method="post" action="${pageContext.request.contextPath}/EmployeeComplaintServlet" id="complaintForm">
                <!-- Operation type (set dynamically by buttons) -->
                <input type="hidden" name="action" id="formAction" value="save">
                <!-- For update/delete -->
                <input type="hidden" name="complaintId" id="complaintId" value="<%= selectedComplaint != null ? selectedComplaint.getComplaintId() : "" %>">
                <!-- Always set user ID -->
                <input type="hidden" name="complaintUserId" value="<%= loggedUser.getId() %>">

                <div class="form-text-group">
                    <label for="complaintTitle">Title</label>
                    <input type="text" id="complaintTitle" name="title" required
                           placeholder="Enter complaint title"
                           value="<%= selectedComplaint != null ? selectedComplaint.getTitle() : "" %>">
                </div>

                <div class="form-text-group">
                    <label for="complaintDescription">Description</label>
                    <textarea id="complaintDescription" name="description" rows="5" required
                              placeholder="Describe the issue"><%= selectedComplaint != null ? selectedComplaint.getDescription() : "" %></textarea>
                </div>

                <div class="form-button-group">
                    <button type="submit" onclick="setAction('save')">Submit Complaint</button>
                    <button type="submit" onclick="setAction('update')">Update Complaint</button>
                    <button type="submit" onclick="return confirmDelete()">Delete Complaint</button>
                    <button type="reset">Clear</button>
                </div>
            </form>
            <script>
                function setAction(actionType) {
                    document.getElementById('formAction').value = actionType;
                }

                function confirmDelete() {
                    Swal.fire({
                        title: "Are you sure?",
                        text: "You are about to delete this complaint.",
                        icon: "warning",
                        showCancelButton: true,
                        confirmButtonText: "Yes, delete it!",
                        cancelButtonText: "Cancel"
                    }).then((result) => {
                        if (result.isConfirmed) {
                            // Set action and submit
                            document.getElementById('formAction').value = 'delete';
                            document.getElementById('complaintForm').submit();
                        }
                    });
                    return false;
                }
            </script>

        </div>

        <div id="my-complaints-panel" class="content-panel">
            <h3>My Complaints</h3>
            <form method="get" action="${pageContext.request.contextPath}/EmployeeComplaintServlet" id="viewMyComplaintsForm">
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
                    List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
                    if (complaints != null && !complaints.isEmpty()) {
                        for (Complaint c : complaints) {
                %>
                <tr onclick="populateComplaintForm('<%= c.getComplaintId() %>', '<%= c.getTitle().replace("'", "\\'") %>', '<%= c.getDescription().replace("'", "\\'") %>')"
                    style="cursor: pointer;">
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
            <script>
                function populateComplaintForm(id, title, description) {
                    document.querySelector('input[name="action"]').value = "update";
                    document.querySelector('input[name="complaintId"]').value = id;
                    document.querySelector('input[name="title"]').value = title;
                    document.querySelector('textarea[name="description"]').value = description;
                }
            </script>

        </div>

    <%
        }
    %>
</div>

</body>
</html>
