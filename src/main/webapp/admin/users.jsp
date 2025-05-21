<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="tourism.model.User" %>
<%@ page import="tourism.util.FileHandler" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - Admin Dashboard</title>
    <link rel="stylesheet" href="../css/styles.css">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap5.min.css">
    <style>
        .sidebar {
            min-height: 100vh;
            background-color: #343a40;
            color: white;
            box-shadow: 2px 0 5px rgba(0,0,0,0.2);
        }
        .sidebar .nav-link {
            color: rgba(255,255,255,0.75);
            padding: 0.75rem 1rem;
            border-radius: 0.25rem;
            margin: 0.2rem 0;
        }
        .sidebar .nav-link:hover {
            color: rgba(255,255,255,1);
            background-color: rgba(255,255,255,0.1);
        }
        .sidebar .nav-link.active {
            color: white;
            background-color: #0d6efd;
        }
        .sidebar .logo {
            padding: 1rem;
            font-size: 1.5rem;
            font-weight: bold;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        .content {
            padding: 20px;
        }
        .main-container {
            margin-left: 250px;
            transition: margin-left 0.3s;
        }
        @media (max-width: 768px) {
            .sidebar {
                width: 100%;
                position: static;
                height: auto;
            }
            .main-container {
                margin-left: 0;
            }
        }
        
        /* Table styles */
        #usersTable {
            width: 100% !important;
            font-size: 14px;
        }
        
        #usersTable th {
            font-weight: 600;
            background-color: #f8f9fa;
        }
    </style>
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
        
        // Process delete request (if any)
        String deleteUsername = request.getParameter("deleteUsername");
        String successMessage = null;
        String errorMessage = null;
        
        if (deleteUsername != null && !deleteUsername.isEmpty()) {
            boolean deleted = fileHandler.deleteUser(deleteUsername);
            if (deleted) {
                successMessage = "User '" + deleteUsername + "' has been deleted successfully";
            } else {
                errorMessage = "Failed to delete user '" + deleteUsername + "'";
            }
        }
        
        // Process update request (if any)
        String updateUsername = request.getParameter("username");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String newPassword = request.getParameter("newPassword");
        
        if (updateUsername != null && !updateUsername.isEmpty() && 
            fullName != null && !fullName.isEmpty() && 
            email != null && !email.isEmpty()) {
            
            User existingUser = fileHandler.getUserByUsername(updateUsername);
            
            if (existingUser != null) {
                User updatedUser = new User();
                updatedUser.setUsername(updateUsername);
                updatedUser.setFullName(fullName);
                updatedUser.setEmail(email);
                
                // Only update password if a new one was provided
                if (newPassword != null && !newPassword.trim().isEmpty()) {
                    updatedUser.setPassword(newPassword);
                } else if (existingUser.getPassword() != null) {
                    updatedUser.setPassword(existingUser.getPassword());
                }
                
                boolean updated = fileHandler.updateUser(updatedUser);
                if (updated) {
                    successMessage = "User '" + updateUsername + "' has been updated successfully";
                } else {
                    errorMessage = "Failed to update user '" + updateUsername + "'";
                }
            }
        }
        
        // Get messages from session (if redirected)
        if (successMessage == null) {
            successMessage = (String) session.getAttribute("successMessage");
            session.removeAttribute("successMessage");
        }
        
        if (errorMessage == null) {
            errorMessage = (String) session.getAttribute("errorMessage");
            session.removeAttribute("errorMessage");
        }
        
        // Get all users for display
        List<User> users = fileHandler.getAllUsers();
        int totalUsers = users.size();
    %>
    
    <div class="d-flex">
        <!-- Sidebar -->
        <div class="sidebar" style="width: 250px; position: fixed; top: 0; left: 0; height: 100%;">
            <div class="logo d-flex align-items-center">
                <i class="fas fa-plane-departure me-2"></i>
                <span>TourEase Admin</span>
            </div>
            <div class="mt-2">
                <div class="text-muted small px-3 py-2">
                    Welcome, <%= user.getUsername() %>
                </div>
            </div>
            <hr class="mx-3 my-2">
            <ul class="nav flex-column px-2">
                <li class="nav-item">
                    <a class="nav-link" href="dashboard.jsp">
                        <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="packages.jsp">
                        <i class="fas fa-box me-2"></i>Packages
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="users.jsp">
                        <i class="fas fa-users me-2"></i>Users
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="inquiries.jsp">
                        <i class="fas fa-question-circle me-2"></i>Inquiries
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="sales.jsp">
                        <i class="fas fa-chart-line me-2"></i>Sales
                    </a>
                </li>
                <li class="nav-item mt-4">
                    <a class="nav-link text-danger" href="../logout">
                        <i class="fas fa-sign-out-alt me-2"></i>Logout
                    </a>
                </li>
            </ul>
        </div>
    
        <!-- Main Content -->
        <div class="main-container">
            <div class="content">
                <div class="row mb-4">
                    <div class="col">
                        <h2 class="border-bottom pb-2"><i class="fas fa-users me-2"></i>User Management</h2>
                    </div>
                </div>
                
                <% if (successMessage != null) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i><%= successMessage %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% } %>
                
                <% if (errorMessage != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i><%= errorMessage %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% } %>
            
                <!-- Stats Card -->
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col-md-4 text-center">
                                        <div class="display-4 text-primary fw-bold mb-2"><%= totalUsers %></div>
                                        <div class="h5 text-muted">Total Users</div>
                                    </div>
                                    <div class="col-md-8">
                                        <h4 class="card-title">User Management Dashboard</h4>
                                        <p class="card-text">Manage all aspects of user accounts from this control panel. You can view all registered users, search for specific users, update information and manage account settings.</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Users Table -->
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-users me-2"></i>All Users
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table id="usersTable" class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>Username</th>
                                        <th>Full Name</th>
                                        <th>Email</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (User currentUser : users) { %>
                                        <tr>
                                            <td><%= currentUser.getUsername() %></td>
                                            <td><%= currentUser.getFullName() %></td>
                                            <td><%= currentUser.getEmail() %></td>
                                            <td>
                                                <div class="btn-group btn-group-sm">
                                                    <button class="btn btn-warning edit-user-btn" 
                                                            data-username="<%= currentUser.getUsername() %>"
                                                            data-fullname="<%= currentUser.getFullName() %>"
                                                            data-email="<%= currentUser.getEmail() %>">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
                                                    <button class="btn btn-danger delete-user-btn" 
                                                            data-username="<%= currentUser.getUsername() %>">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Delete User Confirmation Modal -->
    <div class="modal fade" id="deleteUserModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title">
                        <i class="fas fa-exclamation-triangle me-2"></i>Confirm Deletion
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="deleteUserForm" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="deleteUsername" id="delete-username-input">
                        <p>Are you sure you want to delete this user?</p>
                        <p><strong>Username: </strong><span id="deleteUsername"></span></p>
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            This action cannot be undone. All data associated with this account will be permanently removed.
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger">Delete User</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Edit User Modal -->
    <div class="modal fade" id="editUserModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-warning text-dark">
                    <h5 class="modal-title">
                        <i class="fas fa-user-edit me-2"></i>Edit User
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="editUserForm" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="username" id="edit-username">
                        
                        <div class="mb-3">
                            <label for="edit-fullname" class="form-label">Full Name</label>
                            <input type="text" class="form-control" id="edit-fullname" name="fullName" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="edit-email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="edit-email" name="email" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="edit-password" class="form-label">New Password (leave blank to keep unchanged)</label>
                            <input type="password" class="form-control" id="edit-password" name="newPassword">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-warning">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Status Modal -->
    <div class="modal fade" id="statusModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div id="statusModalHeader" class="modal-header">
                    <h5 class="modal-title" id="statusModalTitle"></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p id="statusModalMessage"></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-bs-dismiss="modal">OK</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap5.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // Initialize DataTable
            var table = $('#usersTable').DataTable({
                "responsive": true,
                "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
                "language": {
                    "search": "Search users:",
                    "lengthMenu": "Show _MENU_ users per page",
                    "info": "Showing _START_ to _END_ of _TOTAL_ users",
                    "infoEmpty": "Showing 0 to 0 of 0 users",
                    "infoFiltered": "(filtered from _MAX_ total users)"
                }
            });
            
            // Handle delete button clicks
            $('.delete-user-btn').on('click', function() {
                const username = $(this).data('username');
                $('#deleteUsername').text(username);
                $('#delete-username-input').val(username);
                $('#deleteUserModal').modal('show');
            });
            
            // Handle edit button clicks
            $('.edit-user-btn').on('click', function() {
                const username = $(this).data('username');
                const fullname = $(this).data('fullname');
                const email = $(this).data('email');
                
                $('#edit-username').val(username);
                $('#edit-fullname').val(fullname);
                $('#edit-email').val(email);
                $('#edit-password').val(''); // Clear password field
                
                $('#editUserModal').modal('show');
            });
            
            // Handle form submission without page reload
            $('#deleteUserForm').submit(function(e) {
                e.preventDefault();
                const username = $('#delete-username-input').val();
                
                $.ajax({
                    url: 'users.jsp',
                    type: 'POST',
                    data: $(this).serialize(),
                    success: function(response) {
                        // Hide the modal
                        $('#deleteUserModal').modal('hide');
                        
                        // Remove the row from the table
                        table.row($("button[data-username='" + username + "']").closest('tr'))
                            .remove()
                            .draw();
                            
                        // Show alert
                        alert("User '" + username + "' has been deleted successfully");
                        
                        // Reload page to update the user count stats
                        location.reload();
                    }
                });
            });
            
            // Handle edit form submission without page reload
            $('#editUserForm').submit(function(e) {
                e.preventDefault();
                const formData = $(this).serialize();
                const username = $('#edit-username').val();
                const fullName = $('#edit-fullname').val();
                const email = $('#edit-email').val();
                
                $.ajax({
                    url: 'users.jsp',
                    type: 'POST',
                    data: formData,
                    success: function(response) {
                        // Hide the modal
                        $('#editUserModal').modal('hide');
                        
                        // Update the row in the table
                        var row = $("button[data-username='" + username + "']").closest('tr');
                        table.cell(row, 0).data(username);
                        table.cell(row, 1).data(fullName);
                        table.cell(row, 2).data(email);
                        
                        // Update the data attributes
                        $("button[data-username='" + username + "'].edit-user-btn")
                            .attr('data-fullname', fullName)
                            .attr('data-email', email);
                            
                        // Show alert
                        alert("User '" + username + "' has been updated successfully");
                    }
                });
            });
        });
    </script>
</body>
</html>
