<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="tourism.model.User" %>
<%@ page import="tourism.util.FileHandler" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View All Users - Admin Dashboard</title>
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
        
        #usersTable td, #usersTable th {
            padding: 12px 15px;
            vertical-align: middle;
        }
        
        .card {
            border-radius: 8px;
            overflow: hidden;
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
        
        // Get all users
        List<User> users = fileHandler.getAllUsers();
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
                    <div class="col-md-8">
                        <h2 class="border-bottom pb-2">
                            <i class="fas fa-users me-2"></i>All Users
                        </h2>
                    </div>
                    <div class="col-md-4 text-end">
                        <a href="users.jsp" class="btn btn-secondary">
                            <i class="fas fa-arrow-left me-2"></i>Back to User Management
                        </a>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-12">
                        <div class="card shadow">
                            <div class="card-body">
                                <% if (request.getAttribute("successMessage") != null) { %>
                                    <div class="alert alert-success" role="alert">
                                        <%= request.getAttribute("successMessage") %>
                                    </div>
                                <% } %>
                                
                                <% if (request.getAttribute("errorMessage") != null) { %>
                                    <div class="alert alert-danger" role="alert">
                                        <%= request.getAttribute("errorMessage") %>
                                    </div>
                                <% } %>
                                
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
                                                            <a href="edit-user.jsp?username=<%= currentUser.getUsername() %>" class="btn btn-warning">
                                                                <i class="fas fa-edit"></i> Edit
                                                            </a>
                                                            <button class="btn btn-danger delete-user-btn" data-username="<%= currentUser.getUsername() %>">
                                                                <i class="fas fa-trash"></i> Delete
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
                <div class="modal-body">
                    <p>Are you sure you want to delete this user?</p>
                    <p><strong>Username: </strong><span id="deleteUsername"></span></p>
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        This action cannot be undone. All data associated with this account will be permanently removed.
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <a href="#" id="confirmDeleteBtn" class="btn btn-danger">Delete User</a>
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
            $('#usersTable').DataTable({
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
                $('#confirmDeleteBtn').attr('href', 'delete-user.jsp?username=' + username);
                $('#deleteUserModal').modal('show');
            });
        });
    </script>
</body>
</html>
