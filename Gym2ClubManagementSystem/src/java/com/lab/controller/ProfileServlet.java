package com.lab.controller;

import com.lab.dao.UserDAO;
import com.lab.model.User;
import java.io.IOException;
import java.util.regex.Pattern;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private final UserDAO userDao = new UserDAO();
    private static final Pattern EMAIL = Pattern.compile("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$");
    private static final Pattern PHONE = Pattern.compile("^[0-9+() -]{7,20}$");

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
        if (!"Member".equals(user.getRole())) { response.sendError(HttpServletResponse.SC_FORBIDDEN); return; }

        String fullName = clean(request.getParameter("fullName"));
        String email = clean(request.getParameter("email")).toLowerCase();
        String phone = clean(request.getParameter("phone"));
        if (fullName.length() < 2 || fullName.length() > 100 || !EMAIL.matcher(email).matches() || !PHONE.matcher(phone).matches()) {
            response.sendRedirect(request.getContextPath() + "/student/profile.jsp?error=validation"); return;
        }
        if (userDao.emailUsedByAnotherUser(email, user.getUserId())) {
            response.sendRedirect(request.getContextPath() + "/student/profile.jsp?error=email"); return;
        }
        boolean updated = userDao.updateProfile(user.getUserId(), fullName, email, phone);
        System.out.println("=== PROFILE UPDATE === userID=" + user.getUserId() + ", success=" + updated);
        if (updated) {
            User refreshed = userDao.getUserById(user.getUserId());
            session.setAttribute("user", refreshed);
            session.setAttribute("name", refreshed.getFullName());
            response.sendRedirect(request.getContextPath() + "/student/profile.jsp?updated=true");
        } else {
            response.sendRedirect(request.getContextPath() + "/student/profile.jsp?error=failed");
        }
    }

    private String clean(String value) { return value == null ? "" : value.trim(); }
}
