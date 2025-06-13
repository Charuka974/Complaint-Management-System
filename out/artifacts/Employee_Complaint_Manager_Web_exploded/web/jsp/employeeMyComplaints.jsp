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
    <title>Manage My Complaints</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/web/css/employee-my-complaints.css" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="${pageContext.request.contextPath}/web/js/employeeMyComplaints.js" defer></script>

</head>
<body>

<%
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<% if (success != null) { %>
<script>
    Swal.fire({
        icon: 'success',
        title: "<%= success.replace("+", " ") %>",
        showConfirmButton: false,
        timer: 1000
    });
</script>
<% } else if (error != null) { %>
<script>
    Swal.fire({
        icon: 'error',
        title: "<%= error.replace("+", " ") %>",
        showConfirmButton: false,
        timer: 1000
    });
</script>
<% } %>


<div class="sidebar">
    <h2><%= loggedUser.getRole() %> Panel</h2>
    <a href="${pageContext.request.contextPath}/EmployeeComplaintServlet">My Complaints</a>
    <a href="<%= request.getContextPath() %>/LogoutServlet">Logout</a>
</div>

<div class="main-content">
    <h1>Welcome, <%= loggedUser.getFullName() %>!</h1>
    <p>Your email: <%= loggedUser.getEmail() %></p>
    <p>Your role: <%= loggedUser.getRole() %></p>

    <hr>

    <h2>Employee Dashboard</h2>
    <br>
    <div id="new-complaint-panel" class="content-panel">
        <h3>Submit or Edit Complaint</h3>
        <%
            Complaint selectedComplaint = (Complaint) request.getAttribute("selectedComplaint");
        %>
        <form method="post" action="${pageContext.request.contextPath}/EmployeeComplaintServlet" id="complaintForm">
            <input type="hidden" name="action" id="formAction" value="save">
            <input type="hidden" name="complaintId" id="complaintId" value="<%= selectedComplaint != null ? selectedComplaint.getComplaintId() : "" %>">
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

                <% if (selectedComplaint == null || "PENDING".equals(selectedComplaint.getStatus())) { %>
                <button type="submit" onclick="setAction('update')">Update Complaint</button>
                <button type="submit" id="deleteBtn">Delete Complaint</button>
                <% } else { %>
                <button type="button" disabled title="Only pending complaints can be updated">Update Complaint</button>
                <button type="button" disabled title="Only pending complaints can be deleted">Delete Complaint</button>
                <% } %>

                <button type="reset" id="clearBtn">Clear</button>
            </div>

        </form>

<%--        <script>--%>

<%--        </script>--%>
    </div>

    <div id="my-complaints-panel" class="content-panel">
        <h3>My Complaints</h3>
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Title</th>
                <th>Status</th>
                <th>Remarks</th>
                <th>Submitted On</th>
            </tr>
            </thead>
            <tbody>
            <%
                List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
                if (complaints != null && !complaints.isEmpty()) {
                    for (Complaint c : complaints) {
            %>
            <%
                String trAttributes;
                if ("PENDING".equalsIgnoreCase(c.getStatus())) {
                    trAttributes = "onclick=\"populateComplaintForm('" + c.getComplaintId() + "', '" +
                            c.getTitle().replace("'", "\\'") + "', '" +
                            c.getDescription().replace("'", "\\'") + "')\" style=\"cursor: pointer;\"";
                } else {
                    trAttributes = "style='background-color: #f9f9f9; color: #aaa; cursor: not-allowed;' title='Only pending complaints can be edited or deleted'";
                }
            %>
            <tr <%= trAttributes %>>

            <%--            <tr onclick="populateComplaintForm('<%= c.getComplaintId() %>', '<%= c.getTitle().replace("'", "\\'") %>', '<%= c.getDescription().replace("'", "\\'") %>')">--%>
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
            <tr><td>No complaints found</td></tr>
            <% } %>
            </tbody>
        </table>
    </div>

</div>

</body>
</html>
