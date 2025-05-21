package tourism.servlet;

import tourism.model.User;
import tourism.util.FileHandler;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class UpdateProfileServlet extends HttpServlet {

    private FileHandler fileHandler;
    
    @Override
    public void init() throws ServletException {
        super.init();
        fileHandler = new FileHandler();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");

        if ("updateInfo".equals(action)) {
            updateUserInfo(request, response, currentUser, session);
        } else if ("updatePassword".equals(action)) {
            updatePassword(request, response, currentUser, session);
        } else if ("adminUpdateInfo".equals(action)) {
            // Check if current user is admin
            Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
            if (isAdmin != null && isAdmin) {
                adminUpdateUserInfo(request, response, session);
            } else {
                session.setAttribute("errorMessage", "Unauthorized access");
                response.sendRedirect("profile.jsp");
            }
        } else {
            session.setAttribute("errorMessage", "Invalid action requested");
            response.sendRedirect("profile.jsp");
        }
    }

    private void updateUserInfo(HttpServletRequest request, HttpServletResponse response, User currentUser, HttpSession session) throws IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");

        if (fullName != null && !fullName.trim().isEmpty() &&
            email != null && !email.trim().isEmpty()) {

            // Create updated user object
            User updatedUser = new User();
            updatedUser.setUsername(currentUser.getUsername());
            updatedUser.setFullName(fullName);
            updatedUser.setEmail(email);
            updatedUser.setPassword(currentUser.getPassword());

            // Update user in file
            boolean success = fileHandler.updateUser(updatedUser);

            if (success) {
                // Update session with new user info
                session.setAttribute("user", updatedUser);
                session.setAttribute("successMessage", "Profile information updated successfully");
            } else {
                session.setAttribute("errorMessage", "Failed to update profile information");
            }
        } else {
            session.setAttribute("errorMessage", "Name and email are required");
        }

        response.sendRedirect("profile.jsp");
    }

    private void updatePassword(HttpServletRequest request, HttpServletResponse response, User currentUser, HttpSession session) throws IOException {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (currentPassword == null || newPassword == null || confirmPassword == null ||
            currentPassword.trim().isEmpty() || newPassword.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
            session.setAttribute("errorMessage", "All password fields are required");
            response.sendRedirect("profile.jsp");
            return;
        }

        // Verify current password
        if (!currentPassword.equals(currentUser.getPassword())) {
            session.setAttribute("errorMessage", "Current password is incorrect");
            response.sendRedirect("profile.jsp");
            return;
        }

        // Check if new passwords match
        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("errorMessage", "New passwords do not match");
            response.sendRedirect("profile.jsp");
            return;
        }

        // Update password
        User updatedUser = new User();
        updatedUser.setUsername(currentUser.getUsername());
        updatedUser.setFullName(currentUser.getFullName());
        updatedUser.setEmail(currentUser.getEmail());
        updatedUser.setPassword(newPassword);

        boolean success = fileHandler.updateUser(updatedUser);

        if (success) {
            session.setAttribute("user", updatedUser);
            session.setAttribute("successMessage", "Password updated successfully");
        } else {
            session.setAttribute("errorMessage", "Failed to update password");
        }

        response.sendRedirect("profile.jsp");
    }
    
    // New method for admin to update user info
    private void adminUpdateUserInfo(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws IOException {
        String username = request.getParameter("username");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String newPassword = request.getParameter("newPassword");
        
        if (username == null || username.trim().isEmpty() ||
            fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty()) {
            
            session.setAttribute("errorMessage", "Username, name and email are required");
            response.sendRedirect("admin/delete-user.jsp?username=" + username);
            return;
        }
        
        // Get current user data to preserve password if not changing it
        User existingUser = fileHandler.getUserByUsername(username);
        if (existingUser == null) {
            session.setAttribute("errorMessage", "User not found");
            response.sendRedirect("admin/users.jsp");
            return;
        }
        
        // Create updated user object
        User updatedUser = new User();
        updatedUser.setUsername(username);
        updatedUser.setFullName(fullName);
        updatedUser.setEmail(email);
        
        // Only update password if a new one was provided
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            updatedUser.setPassword(newPassword);
        } else {
            // Use existing password if a new one wasn't provided
            updatedUser.setPassword(existingUser.getPassword());
        }
        
        // Update user in file
        boolean success = fileHandler.updateUser(updatedUser);
        
        if (success) {
            session.setAttribute("successMessage", "User information updated successfully");
        } else {
            session.setAttribute("errorMessage", "Failed to update user information");
        }
        
        response.sendRedirect("admin/delete-user.jsp?username=" + username);
    }
}
