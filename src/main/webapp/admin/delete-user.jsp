<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="tourism.model.User" %>
<%@ page import="tourism.util.FileHandler" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage User - Admin Dashboard</title>
    <link rel="stylesheet" href="../css/styles.css">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-light">
    <%
        // Check if user is logged in and is admin
        User user = (User) session.getAttribute("user");
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        
        if (user == null || isAdmin == null || !isAdmin) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Create FileHandler instance
        FileHandler fileHandler = new FileHandler();
        
        String usernameToManage = request.getParameter("username");
        User userToManage = null;
        
        if (usernameToManage != null && !usernameToManage.isEmpty()) {
            userToManage = fileHandler.getUserByUsername(usernameToManage);
        }
        
        // Handle action
        String action = request.getParameter("action");
        String message = null;
        String messageType = null;
        
        if ("delete".equals(action) && userToManage != null) {
            boolean deleted = fileHandler.deleteUser(usernameToManage);
            if (deleted) {
                message = "User " + usernameToManage + " has been successfully deleted.";
                messageType = "success";
                userToManage = null;
            } else {
                message = "Failed to delete user. Please try again.";
                messageType = "danger";
            }
        }
    %>
    
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="#">Tourism Admin Panel</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="dashboard.jsp">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="packages.jsp">Packages</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="users.jsp">Users</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="inquiries.jsp">Inquiries</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="sales.jsp">Sales</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="../logout">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h3><i class="fas fa-user-cog me-2"></i>Manage User</h3>
                    </div>
                    <div class="card-body">
                        <% if (message != null) { %>
                            <div class="alert alert-<%= messageType %> alert-dismissible fade show" role="alert">
                                <%= message %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        <% } %>
                        
                        <% if (userToManage != null) { %>
                            <ul class="nav nav-tabs mb-4" id="userTab" role="tablist">
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link active" id="edit-tab" data-bs-toggle="tab" 
                                            data-bs-target="#edit" type="button" role="tab" 
                                            aria-controls="edit" aria-selected="true">Edit User</button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link" id="delete-tab" data-bs-toggle="tab" 
                                            data-bs-target="#delete" type="button" role="tab" 
                                            aria-controls="delete" aria-selected="false">Delete User</button>
                                </li>
                            </ul>
                            
                            <div class="tab-content" id="userTabContent">
                                <!-- Edit User Tab -->
                                <div class="tab-pane fade show active" id="edit" role="tabpanel" aria-labelledby="edit-tab">
                                    <h4 class="mb-3">Update User Details</h4>
                                    <form id="updateUserForm" action="../updateProfile" method="post">
                                        <input type="hidden" name="action" value="adminUpdateInfo">
                                        <input type="hidden" name="username" value="<%= userToManage.getUsername() %>">
                                        
                                        <div class="mb-3">
                                            <label for="username" class="form-label">Username</label>
                                            <input type="text" class="form-control" id="username" value="<%= userToManage.getUsername() %>" readonly>
                                            <small class="text-muted">Username cannot be changed</small>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="fullName" class="form-label">Full Name</label>
                                            <input type="text" class="form-control" id="fullName" name="fullName" 
                                                  value="<%= userToManage.getFullName() %>" required>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="email" class="form-label">Email</label>
                                            <input type="email" class="form-control" id="email" name="email" 
                                                  value="<%= userToManage.getEmail() %>" required>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="newPassword" class="form-label">New Password (Leave blank to keep current)</label>
                                            <input type="password" class="form-control" id="newPassword" name="newPassword">
                                        </div>
                                        
                                        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-save me-1"></i>Update User
                                            </button>
                                        </div>
                                    </form>
                                </div>
                                
                                <!-- Delete User Tab -->
                                <div class="tab-pane fade" id="delete" role="tabpanel" aria-labelledby="delete-tab">
                                    <div class="alert alert-warning">
                                        <h4><i class="fas fa-exclamation-triangle me-2"></i>Confirm Deletion</h4>
                                        <p>Are you sure you want to delete the following user?</p>
                                        <ul>
                                            <li><strong>Username:</strong> <%= userToManage.getUsername() %></li>
                                            <li><strong>Full Name:</strong> <%= userToManage.getFullName() %></li>
                                            <li><strong>Email:</strong> <%= userToManage.getEmail() %></li>
                                        </ul>
                                        <p><strong>Warning:</strong> This action cannot be undone!</p>
                                        
                                        <div class="mt-3">
                                            <button onclick="deleteUser('<%= userToManage.getUsername() %>')" 
                                                   class="btn btn-danger me-2">
                                                <i class="fas fa-trash me-1"></i>Yes, Delete User
                                            </button>
                                            <button class="btn btn-secondary" data-bs-toggle="tab" data-bs-target="#edit">
                                                <i class="fas fa-times me-1"></i>Cancel
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        <% } else { %>
                            <div class="alert alert-info">
                                <p>Please select a user to manage from the <a href="view-users.jsp">user list</a>.</p>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        function deleteUser(username) {
            if (confirm("Are you absolutely sure you want to delete this user?")) {
                fetch('delete-user.jsp?action=delete&username=' + username, {
                    method: 'GET'
                })
                .then(response => response.text())
                .then(() => {
                    // Show success message and redirect to users list
                    alert('User has been successfully deleted');
                    window.location.href = 'users.jsp';
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('An error occurred while deleting the user');
                });
            }
        }
    </script>
</body>
</html>
