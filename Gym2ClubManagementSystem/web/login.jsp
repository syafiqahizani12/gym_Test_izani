<%-- 
    Document   : login
    Created on : 26 May 2026, 5:23:22 pm
    Author     : DELL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login | UniGym</title>

        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Icons -->
        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

        <!-- CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login_style.css">

    </head>

    <body>

        <div class="login-container">

            <!-- LEFT SIDE -->
            <div class="left-panel">

                <div class="overlay"></div>

                <div class="left-content">

                    <h1>
                        Push Your Limits Now.
                    </h1>

                    <p>
                        Access your gym dashboard, attendance,
                        bookings and membership in one place.
                    </p>

                </div>

            </div>

            <!-- RIGHT SIDE -->
            <div class="right-panel">

                <div class="login-box">

                    <h2>Welcome Back</h2>

                    <p class="subtitle">
                        Login to continue your fitness journey
                    </p>

                    <form action="${pageContext.request.contextPath}/login" method="POST">

                        <!-- EMAIL -->
                        <div class="input-group-custom">
                            <i class="fa-solid fa-envelope"></i>
                            <input type="email"
                                   name="email"
                                   placeholder="Enter your email"
                                   required>
                        </div>

                        <!-- PASSWORD -->
                        <div class="input-group-custom">
                            <i class="fa-solid fa-lock"></i>
                            <input type="password"
                                   name="password"
                                   placeholder="Enter your password"
                                   required>
                        </div>

                        <!-- REMEMBER -->
                        <div class="extra-options">
                            <div>
                                <input type="checkbox">
                                Remember me
                            </div>
                            <a href="#">
                                Forgot Password?
                            </a>
                        </div>

                        <!-- BUTTON -->
                        <button type="submit" class="btn-login">
                            Login
                        </button>

                    </form>

                    <!-- REGISTER -->
                    <div class="register-text">
                        Don't have an account?
                        <a href="${pageContext.request.contextPath}/register.jsp">
                            Register
                        </a>
                    </div>

                </div>

            </div>

        </div>

        <%
            String error = request.getParameter("error");
            String login = request.getParameter("login");

            if ("invalid".equals(error)) {
        %>
        <script>
            alert("Invalid login details!");
        </script>
        <%
        } else if ("notfound".equals(error)) {
        %>
        <script>
            alert("Account not found! Please register first.");
        </script>
        <%
        } else if ("wrongpass".equals(error)) {
        %>
        <script>
            alert("Wrong password! Please try again.");
        </script>
        <%
            }
            if ("success".equals(login)) {
        %>
        <script>
            alert("Login successful!");
        </script>
        <%
            }
        %>
    </body>
</html>
