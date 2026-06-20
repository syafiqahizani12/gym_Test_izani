package com.lab.controller;

import com.lab.dao.UserDAO;
import com.lab.model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/trainer-management")
public class TrainerServlet extends HttpServlet {

    private final UserDAO userDao = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isManager(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Managers only");
            return;
        }

        String action = request.getParameter("action");
        System.out.println("=== TRAINER MANAGEMENT === " + action);

        if ("add".equals(action)) {
            addTrainer(request);
        } else if ("delete".equals(action)) {
            int trainerId = Integer.parseInt(request.getParameter("trainerID"));
            userDao.deleteTrainer(trainerId);
        }

        response.sendRedirect(request.getContextPath() + "/manager/trainerList.jsp");
    }

    private boolean isManager(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");
        return user != null && "Manager".equalsIgnoreCase(user.getRole());
    }

    private void addTrainer(HttpServletRequest request) {
        User trainer = new User();
        trainer.setFullName(request.getParameter("fullName"));
        trainer.setEmail(request.getParameter("email"));
        trainer.setPhoneNumber(request.getParameter("phone"));
        trainer.setPassword(request.getParameter("password"));
        trainer.setRole("Trainer");

        if (trainer.getFullName() == null || trainer.getFullName().trim().isEmpty()
                || trainer.getEmail() == null || trainer.getEmail().trim().isEmpty()
                || trainer.getPassword() == null || trainer.getPassword().trim().isEmpty()) {
            System.out.println("Trainer add failed: missing required fields");
            return;
        }

        if (userDao.getUserByEmail(trainer.getEmail()) == null) {
            userDao.addTrainer(trainer);
        } else {
            System.out.println("Trainer add skipped: duplicate email " + trainer.getEmail());
        }
    }
}
