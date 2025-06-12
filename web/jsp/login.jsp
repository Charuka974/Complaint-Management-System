<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Login / Sign Up - Employee Complaint Manager</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" type="text/css" href="../css/login.css">
    <script src="../js/login.js" defer></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>

<div class="container">
    <div class="flip-card" id="flipCard">
        <div class="flip-card-inner">

            <!-- Login Side -->
            <div class="flip-card-front">
                <h2 class="flip-card-header">Login</h2>
                <form action="${pageContext.request.contextPath}/LoginServlet" method="post" onsubmit="return validateLoginForm();">
                    <div class="form-group">
                        <label for="login-email">Email:</label>
                        <input type="email" id="login-email" name="loginEmail" required>
                    </div>

                    <div class="form-group">
                        <label for="login-password">Password:</label>
                        <input type="password" id="login-password" name="loginPassword" required>
                    </div>

                    <button type="submit">Login</button>

                    <%
                        String loginError = request.getParameter("login-error");
                        if (loginError != null && !loginError.isEmpty()) {

                            String icon = "error"; // default

                            if (loginError.toLowerCase().contains("success")) {
                                icon = "success";
                            } else if (loginError.toLowerCase().contains("invalid credentials")) {
                                icon = "error";
                            } else if (loginError.toLowerCase().contains("info")) {
                                icon = "info";
                            } else if (loginError.toLowerCase().contains("please login first")) {
                                icon = "warning";
                            }
                    %>
                    <script>
                        Swal.fire({
                            position: "center",
                            icon: "<%= icon %>",
                            title: "<%= loginError.replace("+", " ") %>",
                            showConfirmButton: true
                        });
                    </script>
                    <%
                        }
                    %>
                    <span class="toggle-link" onclick="toggleCard()">Don't have an account? Sign up</span>
                </form>
            </div>

            <!-- Sign Up Side -->
            <div class="flip-card-back">
                <h2 class="flip-card-header">Sign Up</h2>
                <form action="${pageContext.request.contextPath}/RegisterServlet" method="post" onsubmit="return validateSignupForm();">
                    <div class="form-group">
                        <label for="fullName">Full Name:</label>
                        <input type="text" id="fullName" name="fullName" required>
                    </div>

                    <div class="form-group">
                        <label for="email">Email:</label>
                        <input type="email" id="email" name="email" required>
                    </div>

                    <div class="form-group">
                        <label for="newPassword">Password:</label>
                        <input type="password" id="newPassword" name="password" required>
                    </div>

                    <div class="form-group">
                        <label for="role">Role:</label>
                        <select id="role" name="role" required>
                            <option value="EMPLOYEE">Employee</option>
                            <option value="ADMIN">Admin</option>
                        </select>
                    </div>

                    <button type="submit">Register</button>
                    <%
                        String registerError = request.getParameter("register-msg");
                        if (registerError != null && !registerError.isEmpty()) {

                            String icon = "error"; // default

                            if (registerError.toLowerCase().contains("account created")) {
                                icon = "success";
                            } else if (registerError.toLowerCase().contains("could not create user")) {
                                icon = "error";
                            }
                    %>
                    <script>
                        Swal.fire({
                            position: "center",
                            icon: "<%= icon %>",
                            title: "<%= registerError.replace("+", " ") %>",
                            showConfirmButton: true
                        });
                    </script>
                    <%
                        }
                    %>
                    <span class="toggle-link" onclick="toggleCard()">Already have an account? Login</span>
                </form>
            </div>

        </div>
    </div>
</div>

</body>
</html>
