package tourism.controller;

import tourism.model.User;
import tourism.util.FileHandler;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private FileHandler fileHandler;
    
    @Override
    public void init() throws ServletException {
        super.init();
        fileHandler = new FileHandler();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get form parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");

        // Log registration attempt
        System.out.println("Registration attempt - Username: " + username);

        // Validate input
        if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                confirmPassword == null || confirmPassword.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                fullName == null || fullName.trim().isEmpty()) {

            // Check if it's an AJAX request
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"All fields are required\"}");
            } else {
                request.setAttribute("errorMessage", "All fields are required");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }
            return;
        }

        // Check if passwords match
        if (!password.equals(confirmPassword)) {
            // Check if it's an AJAX request
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Passwords do not match\"}");
            } else {
                request.setAttribute("errorMessage", "Passwords do not match");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }
            return;
        }

        // Check if username already exists
        if (fileHandler.userExists(username)) {
            // Check if it's an AJAX request
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Username already exists\"}");
            } else {
                request.setAttribute("errorMessage", "Username already exists");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }
            return;
        }

        // Create user object
        User user = new User();
        user.setUsername(username);
        user.setPassword(password); 
        user.setEmail(email);
        user.setFullName(fullName);

        // Save the user
        boolean success = fileHandler.saveUser(user);
        
        if (success) {
            // Registration successful
            System.out.println("User registered successfully: " + username);
            
            // Check if it's an AJAX request
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": true, \"message\": \"Registration successful\"}");
            } else {
                response.sendRedirect(request.getContextPath() + "/login?registered=true");
            }
        } else {
            // Registration failed
            System.out.println("User registration failed for: " + username);
            
            // Check if it's an AJAX request
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Registration failed. Please try again.\"}");
            } else {
                request.setAttribute("errorMessage", "Registration failed. Please try again.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }
        }
    }
}