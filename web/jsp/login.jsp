<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Employee Complaint Manager</title>
    <link rel="stylesheet" type="text/css" href="../css/login.css">
    <script src="../js/loginValidation.js" defer></script>
</head>
<body>
<div class="login-container">
    <h2>Login</h2>
    <form action="LoginServlet" method="post" onsubmit="return validateLoginForm();">
        <div class="form-group">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required>
        </div>

        <div class="form-group">
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
        </div>

        <div class="form-group">
            <button type="submit">Login</button>
        </div>

        <%-- Optional error message display --%>
        <%
            String error = request.getParameter("error");
            if (error != null) {
        %>
        <p class="error-message"><%= error %></p>
        <%
            }
        %>
    </form>
</div>
</body>
</html>
