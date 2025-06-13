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

        <h3>Complaints</h3>

<%--        <form method="get" action="${pageContext.request.contextPath}/ManageComplaintAdminServlet" id="viewAllComplaintsForm">--%>
<%--            <button type="submit">View My Complaints</button>--%>
<%--        </form>--%>
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
            function populateComplaintForm(id, title, description, status, remarks) {
                document.getElementById("complaintId").value = id;
                document.getElementById("complaintTitle").value = title;
                document.getElementById("complaintDescription").value = description;
                document.getElementById("complaintRemarks").value = remarks;
                document.getElementById("complaintStatus").value = status;

                // Set the form action to 'update' to reflect intent
                document.getElementById("formAction").value = "update";
            }
        </script>
        <%--Alert--%>
        <%
            String successMsg = request.getParameter("success");
            if (successMsg != null) {
        %>
        <script>
            Swal.fire({
                icon: 'success',
                title: "<%= successMsg.replace("+", " ") %>",
                showConfirmButton: false,
                timer: 1000
            });
        </script>
        <% } %>


    </div>

</div>

</body>
</html>
