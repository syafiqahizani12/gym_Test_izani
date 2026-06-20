/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package com.lab.filter;

import com.lab.dao.MembershipDAO;
import com.lab.model.Membership;
import com.lab.model.User;
import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();

        // Allow public resources (CSS, JS, images, login, register, index)
        if (uri.endsWith(".css") || uri.endsWith(".js") || uri.endsWith(".png") || uri.endsWith(".jpg") ||
            uri.endsWith(".jpeg") || uri.endsWith(".gif") || uri.endsWith(".svg") ||
            uri.endsWith("/index.jsp") || uri.equals(contextPath + "/") ||
            uri.endsWith("/login.jsp") || uri.endsWith("/register.jsp") ||
            uri.endsWith("/login") || uri.endsWith("/register")) {
            chain.doFilter(req, res);
            return;
        }

        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(contextPath + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String role = user.getRole();

        System.out.println("=== AUTH FILTER ===");
        System.out.println("User: " + user.getFullName());
        System.out.println("Role from DB: " + role);
        System.out.println("Request URI: " + uri);

        // Role-based access control - Match your database roles
        // Your database uses: "Member", "Trainer", "Manager"
        if (uri.contains("/student/") && !role.equalsIgnoreCase("Member")) {
            System.out.println("ACCESS DENIED: " + role + " is not Member");
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Students/Members only");
            return;
        } else if (uri.contains("/trainer/") && !role.equalsIgnoreCase("Trainer")) {
            System.out.println("ACCESS DENIED: " + role + " is not Trainer");
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Trainers only");
            return;
        } else if (uri.contains("/manager/") && !role.equalsIgnoreCase("Manager")) {
            System.out.println("ACCESS DENIED: " + role + " is not Manager");
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Managers only");
            return;
        }

        if ("Member".equalsIgnoreCase(role) && uri.contains("/student/")) {
            boolean statusPage = uri.endsWith("/pending.jsp")
                    || uri.endsWith("/expired.jsp")
                    || uri.endsWith("/billing.jsp")
                    || uri.endsWith("/payment.jsp")
                    || uri.endsWith("/renewMembership.jsp")
                    || uri.endsWith("/profile.jsp");

            if (!statusPage) {
                MembershipDAO membershipDao = new MembershipDAO();
                Membership membership = membershipDao.getMembershipByStudentId(user.getUserId());
                if (membership == null) {
                    response.sendRedirect(contextPath + "/index.jsp?needPlan=true");
                    return;
                }
                if ("Pending".equalsIgnoreCase(membership.getStatus())) {
                    response.sendRedirect(contextPath + "/student/pending.jsp");
                    return;
                }
                if (!membershipDao.isActive(user.getUserId())) {
                    response.sendRedirect(contextPath + "/student/expired.jsp");
                    return;
                }
            }
        }

        System.out.println("ACCESS GRANTED for: " + role);
        chain.doFilter(req, res);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}
}
