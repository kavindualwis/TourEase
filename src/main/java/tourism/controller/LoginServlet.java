package tourism.controller;

import tourism.model.User;
import tourism.util.FileHandler;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private FileHandler fileHandler;
    
    @Override
    public void init() throws ServletException {
        super.init();
        fileHandler = new FileHandler();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get form parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // Check if it's an AJAX request
        boolean isAjaxRequest = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));

        // Log debugging information
        System.out.println("Login attempt - Username: " + username);
        System.out.println("Is AJAX request: " + isAjaxRequest);

        // Validate input
        if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            
            if (isAjaxRequest) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Username and password are required\"}");
                return;
            } else {
                request.setAttribute("errorMessage", "Username and password are required");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }
        }

        // Check for admin credentials
        if ("admin".equals(username) && "admin1".equals(password)) {
            // Create admin user object
            User adminUser = new User();
            adminUser.setUsername("admin");
            adminUser.setFullName("Administrator");

            // Create admin session
            HttpSession session = request.getSession();
            session.setAttribute("user", adminUser);
            session.setAttribute("isAdmin", true);
            
            System.out.println("Admin login successful");
            
            if (isAjaxRequest) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": true, \"isAdmin\": true, \"redirect\": \"admin/dashboard.jsp\"}");
            } else {
                // Redirect to admin dashboard
                response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
            }
            return;
        }

        // Validate regular user credentials
        User user = fileHandler.validateUser(username, password);
        System.out.println("User validation result: " + (user != null ? "Success" : "Failed"));

        if (user != null) {
            // Login successful, create session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("isAdmin", false);
            
            System.out.println("User login successful for: " + user.getUsername());
            
            if (isAjaxRequest) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": true, \"isAdmin\": false, \"redirect\": \"dashboard.jsp\"}");
            } else {
                // Redirect to dashboard
                response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
            }
        } else {
            // Login failed
            System.out.println("User login failed for username: " + username);
            
            if (isAjaxRequest) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Invalid username or password\"}");
            } else {
                request.setAttribute("errorMessage", "Invalid username or password");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        }
    }
}