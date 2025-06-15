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
    <title>Manage Complaints</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/web/css/manage-complaints-admin.css" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="${pageContext.request.contextPath}/web/js/manageComplaintsAdmin.js" defer></script>

</head>
<body>

<div class="sidebar">
    <h2><%= loggedUser.getRole() %> Panel</h2>
    <a href="#complaint-manage-panel">Manage Complaints</a>
    <a href="${pageContext.request.contextPath}/ManageUsersAdminServlet">Manage Users</a>
    <a href="<%= request.getContextPath() %>/LogoutServlet">Logout</a>
</div>

<div class="main-content">
    <h1>Welcome, <%= loggedUser.getFullName() %>!</h1>
    <p>Your email: <%= loggedUser.getEmail() %></p>
    <p>Your role: <%= loggedUser.getRole() %></p>

    <hr>

    <h2>Admin Overview</h2>
    <div id="complaint-manage-panel" class="content-panel">
        <h3>Manage Complaints</h3>
        <%
            Complaint selectedComplaint = (Complaint) request.getAttribute("selectedComplaint");
        %>
        <form method="post" action="${pageContext.request.contextPath}/ManageComplaintAdminServlet" id="complaintForm">
            <!-- Operation type (set dynamically by buttons) -->
            <input type="hidden" name="action" id="formAction" value="save">
            <!-- For update/delete -->
            <input type="hidden" name="complaintId" id="complaintId" value="<%= selectedComplaint != null ? selectedComplaint.getComplaintId() : "" %>">
            <!-- Always set user ID -->
            <input type="hidden" name="complaintUserId" value="<%= loggedUser.getId() %>">

            <div class="form-text-group">
                <label for="complaintTitle">Title</label>
                <input type="text" id="complaintTitle" name="title" required
                       placeholder="Enter complaint title" readonly
                       value="<%= selectedComplaint != null ? selectedComplaint.getTitle() : "" %>">
            </div>

            <div class="form-text-group">
                <label for="complaintDescription">Description</label>
                <textarea id="complaintDescription" name="description" required
                          placeholder="Describe the issue" readonly><%= selectedComplaint != null ? selectedComplaint.getDescription() : "" %></textarea>
            </div>

            <div class="form-text-group">
                <label for="complaintRemarks">Remarks</label>
                <textarea id="complaintRemarks" name="remarks" required
                          placeholder="Remarks"><%= selectedComplaint != null ? selectedComplaint.getDescription() : "" %></textarea>
            </div>


            <label for="complaintStatus">Status</label>
            <select id="complaintStatus" name="status" required>
                <option value="PENDING" <%= selectedComplaint != null && "PENDING".equals(selectedComplaint.getStatus()) ? "selected" : "" %>>Pending</option>
                <option value="IN_PROGRESS" <%= selectedComplaint != null && "IN_PROGRESS".equals(selectedComplaint.getStatus()) ? "selected" : "" %>>In Progress</option>
                <option value="RESOLVED" <%= selectedComplaint != null && "RESOLVED".equals(selectedComplaint.getStatus()) ? "selected" : "" %>>Resolved</option>
            </select>

            <div class="form-button-group">
                <button type="submit" onclick="setAction('update')">Update Complaint</button>
                <button type="submit" onclick="return confirmDelete()">Delete Complaint</button>
                <button type="reset">Clear</button>
            </div>
        </form>
<%--        <script>--%>
<%--        </script>--%>

        <h3>Pending Complaints</h3>

<%--        <form method="get" action="${pageContext.request.contextPath}/ManageComplaintAdminServlet" id="viewAllComplaintsForm">--%>
<%--            <button type="submit">View My Complaints</button>--%>
<%--        </form>--%>
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Title</th>
                <th>Status</th>
                <th>Remarks</th>
                <th>Submitted On</th>
                <th>User ID</th>
            </tr>
            </thead>
            <tbody>
            <%
                List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
                boolean hasPending = false;
                if (complaints != null) {
                    for (Complaint c : complaints) {
                        if ("PENDING".equalsIgnoreCase(c.getStatus())) {
                            hasPending = true;
            %>
            <tr onclick="populateComplaintForm('<%= c.getComplaintId() %>',
                    '<%= c.getTitle() %>',
                    '<%= c.getDescription() %>',
                    '<%= c.getStatus().replace("'", "\\'") %>',
                    '<%= c.getRemarks().replace("'", "\\'") %>')"
                style="cursor: pointer;">
                <td><%= c.getComplaintId() %></td>
                <td><%= c.getTitle() %></td>
                <td><%= c.getStatus() %></td>
                <td><%= c.getRemarks() %></td>
                <td><%= c.getCreatedAt() %></td>
                <td><%= c.getUserId() %></td>
            </tr>
            <%
                        }
                    }
                }
                if (!hasPending) {
            %>
            <tr><td colspan="6">No pending complaints found</td></tr>
            <% } %>
            </tbody>
        </table>

        <br>

        <h3>In-Progress Complaints</h3>
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Title</th>
                <th>Status</th>
                <th>Remarks</th>
                <th>Submitted On</th>
                <th>User ID</th>
            </tr>
            </thead>
            <tbody>
            <%
                boolean hasInProgress = false;
                if (complaints != null) {
                    for (Complaint c : complaints) {
                        if ("IN_PROGRESS".equalsIgnoreCase(c.getStatus())) {
                            hasInProgress = true;
            %>
            <tr onclick="populateComplaintForm('<%= c.getComplaintId() %>',
                    '<%= c.getTitle() %>',
                    '<%= c.getDescription() %>',
                    '<%= c.getStatus().replace("'", "\\'") %>',
                    '<%= c.getRemarks().replace("'", "\\'") %>')"
                style="cursor: pointer; background-color: #fff3cd;">
                <td><%= c.getComplaintId() %></td>
                <td><%= c.getTitle() %></td>
                <td><%= c.getStatus() %></td>
                <td><%= c.getRemarks() %></td>
                <td><%= c.getCreatedAt() %></td>
                <td><%= c.getUserId() %></td>
            </tr>
            <%
                        }
                    }
                }
                if (!hasInProgress) {
            %>
            <tr><td colspan="6">No in-progress complaints found</td></tr>
            <% } %>
            </tbody>
        </table>

        <br>

        <h3>Resolved Complaints</h3>
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Title</th>
                <th>Status</th>
                <th>Remarks</th>
                <th>Submitted On</th>
                <th>User ID</th>
            </tr>
            </thead>
            <tbody>
            <%
                boolean hasResolved = false;
                if (complaints != null) {
                    for (Complaint c : complaints) {
                        if ("RESOLVED".equalsIgnoreCase(c.getStatus())) {
                            hasResolved = true;
            %>
            <tr onclick="populateComplaintForm('<%= c.getComplaintId() %>',
                    '<%= c.getTitle() %>',
                    '<%= c.getDescription() %>',
                    '<%= c.getStatus().replace("'", "\\'") %>',
                    '<%= c.getRemarks().replace("'", "\\'") %>')"
                style="cursor: pointer; background-color: #d4edda; color: #155724;">
                <td><%= c.getComplaintId() %></td>
                <td><%= c.getTitle() %></td>
                <td><%= c.getStatus() %></td>
                <td><%= c.getRemarks() %></td>
                <td><%= c.getCreatedAt() %></td>
                <td><%= c.getUserId() %></td>
            </tr>
            <%
                        }
                    }
                }
                if (!hasResolved) {
            %>
            <tr><td colspan="6">No resolved complaints found</td></tr>
            <% } %>
            </tbody>
        </table>

        <%
            String successMsg = request.getParameter("success");
            if (successMsg != null) {
                successMsg = java.net.URLDecoder.decode(successMsg, "UTF-8");
        %>
        <script>
            document.addEventListener("DOMContentLoaded", () => {
                Swal.fire({
                    icon: 'success',
                    title: "<%= successMsg %>",
                    showConfirmButton: false,
                    timer: 1000
                }).then(() => {
                    // Remove ?success=... from the URL so it doesn't show again on reload
                    window.history.replaceState({}, document.title, window.location.pathname);
                });
            });
        </script>
        <% } %>



    </div>

</div>

</body>
</html>
