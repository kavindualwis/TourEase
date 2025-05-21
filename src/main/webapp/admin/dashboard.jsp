<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="tourism.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TourEase - Admin</title>
    <link rel="stylesheet" href="../css/styles.css">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
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
                    <a class="nav-link active" href="dashboard.jsp">
                        <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="packages.jsp">
                        <i class="fas fa-box me-2"></i>Packages
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="users.jsp">
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
                    <div class="col-12">
                        <h2 class="border-bottom pb-2"><i class="fas fa-tachometer-alt me-2"></i>Dashboard</h2>
                    </div>
                </div>

                <div class="row">
                    <!-- Package Management Card -->
                    <div class="col-md-6 mb-4">
                        <div class="card shadow h-100">
                            <div class="card-header bg-success text-white">
                                <h4><i class="fas fa-box me-2"></i>Package Management</h4>
                            </div>
                            <div class="card-body">
                                <p>Create, update, delete, and view all tourism packages.</p>
                                <div class="list-group">
                                    <a href="#" class="list-group-item list-group-item-action" data-bs-toggle="modal" data-bs-target="#addPackageModal">
                                        <i class="fas fa-plus me-2"></i>Add New Package
                                    </a>
                                    <a href="packages.jsp" class="list-group-item list-group-item-action">
                                        <i class="fas fa-list me-2"></i>View All Packages
                                    </a>
                                </div>
                                <div class="d-grid mt-3">
                                    <a href="packages.jsp" class="btn btn-success">Manage All Packages</a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- User Management Card -->
                    <div class="col-md-6 mb-4">
                        <div class="card shadow h-100">
                            <div class="card-header bg-info text-white">
                                <h4><i class="fas fa-users me-2"></i>User Management</h4>
                            </div>
                            <div class="card-body">
                                <p>View, edit, and manage user accounts.</p>
                                <div class="list-group">
                                    <a href="view-users.jsp" class="list-group-item list-group-item-action">
                                        <i class="fas fa-user-friends me-2"></i>View All Users
                                    </a>
                                    <a href="edit-user.jsp" class="list-group-item list-group-item-action">
                                        <i class="fas fa-user-edit me-2"></i>Edit User Details
                                    </a>
                                    <a href="delete-user.jsp" class="list-group-item list-group-item-action">
                                        <i class="fas fa-user-minus me-2"></i>Delete Users
                                    </a>
                                </div>
                                <div class="d-grid mt-3">
                                    <a href="users.jsp" class="btn btn-info text-white">Manage All Users</a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Inquiry Management Card -->
                    <div class="col-md-6 mb-4">
                        <div class="card shadow h-100">
                            <div class="card-header bg-warning text-dark">
                                <h4><i class="fas fa-question-circle me-2"></i>Inquiry Management</h4>
                            </div>
                            <div class="card-body">
                                <p>View and respond to user inquiries.</p>
                                <div class="list-group">
                                    <a href="new-inquiries.jsp" class="list-group-item list-group-item-action">
                                        <i class="fas fa-envelope me-2"></i>New Inquiries <span class="badge bg-danger">5</span>
                                    </a>
                                    <a href="processed-inquiries.jsp" class="list-group-item list-group-item-action">
                                        <i class="fas fa-envelope-open me-2"></i>Processed Inquiries
                                    </a>
                                </div>
                                <div class="d-grid mt-3">
                                    <a href="inquiries.jsp" class="btn btn-warning text-dark">Manage All Inquiries</a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Sold Packages Card -->
                    <div class="col-md-6 mb-4">
                        <div class="card shadow h-100">
                            <div class="card-header bg-danger text-white">
                                <h4><i class="fas fa-shopping-cart me-2"></i>Sold Packages</h4>
                            </div>
                            <div class="card-body">
                                <p>Track and manage sold packages and bookings.</p>
                                <div class="list-group">
                                    <a href="recent-sales.jsp" class="list-group-item list-group-item-action">
                                        <i class="fas fa-chart-line me-2"></i>Recent Sales
                                    </a>
                                    <a href="sales-report.jsp" class="list-group-item list-group-item-action">
                                        <i class="fas fa-file-invoice-dollar me-2"></i>Generate Sales Reports
                                    </a>
                                    <a href="booking-management.jsp" class="list-group-item list-group-item-action">
                                        <i class="fas fa-calendar-check me-2"></i>Manage Bookings
                                    </a>
                                </div>
                                <div class="d-grid mt-3">
                                    <a href="sales.jsp" class="btn btn-danger">View All Sales</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Package Modal -->
    <div class="modal fade" id="addPackageModal" tabindex="-1" aria-labelledby="addPackageModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title" id="addPackageModalLabel">Add New Package</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="addPackageForm" action="${pageContext.request.contextPath}/admin/package/add" method="post">
                        <!-- Hidden field for packageId with more randomness -->
                        <input type="hidden" id="packageId" name="packageId" 
                               value="pkg_<%= System.currentTimeMillis() %>_<%= (int)(Math.random() * 1000) %>">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="packageName" class="form-label">Package Name</label>
                                <input type="text" class="form-control" id="packageName" name="packageName" required>
                            </div>
                            <div class="col-md-6">
                                <label for="destination" class="form-label">Destination</label>
                                <input type="text" class="form-control" id="destination" name="destination" required>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="duration" class="form-label">Duration (days)</label>
                                <input type="number" class="form-control" id="duration" name="duration" min="1" required>
                            </div>
                            <div class="col-md-6">
                                <label for="price" class="form-label">Price ($)</label>
                                <input type="number" class="form-control" id="price" name="price" min="0" step="0.01" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="description" class="form-label">Description</label>
                            <textarea class="form-control" id="description" name="description" rows="4" required></textarea>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="maxParticipants" class="form-label">Max Participants</label>
                                <input type="number" class="form-control" id="maxParticipants" name="maxParticipants" min="1" required>
                            </div>
                            <div class="col-md-6">
                                <label for="departureDate" class="form-label">Departure Date</label>
                                <input type="date" class="form-control" id="departureDate" name="departureDate" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="packageImage" class="form-label">Package Image</label>
                            <input class="form-control" type="text" id="packageImage" name="packageImage" value="default.jpg">
                        </div>
                        <div class="mb-3">
                            <label for="status" class="form-label">Status</label>
                            <select class="form-select" id="status" name="status" required>
                                <option value="active">Active</option>
                                <option value="limited">Limited Availability</option>
                                <option value="soldout">Sold Out</option>
                                <option value="hidden">Hidden</option>
                            </select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" onclick="submitPackage()" class="btn btn-success">Add Package</button>
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
        function submitPackage() {
            const form = document.getElementById('addPackageForm');
            const formData = new FormData(form);
            
            // Generate a unique ID for the package
            const packageId = document.getElementById('packageId').value || ('pkg_' + Date.now() + '_' + Math.floor(Math.random() * 1000));
            
            const packageObj = {
                packageId: packageId,
                packageName: formData.get('packageName'),
                description: formData.get('description'),
                price: parseFloat(formData.get('price')),
                duration: parseInt(formData.get('duration')),
                destination: formData.get('destination'),
                maxParticipants: parseInt(formData.get('maxParticipants')),
                departureDate: formData.get('departureDate'),
                packageImage: formData.get('packageImage') || 'default.jpg',
                status: formData.get('status') || 'active'
            };

            // Debug logs
            console.log("Sending package data:", JSON.stringify(packageObj));

            fetch('${pageContext.request.contextPath}/admin/package/add', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(packageObj)
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok: ' + response.status);
                }
                return response.text();
            })
            .then(text => {
                // Debug log the raw response
                console.log("Raw response:", text);
                
                if (!text || text.trim() === '') {
                    throw new Error('Empty response from server');
                }
                
                // Parse the response as JSON
                try {
                    const data = JSON.parse(text);
                    if(data.success) {
                        alert('Package created successfully!');
                        // Use Bootstrap's modal hide method
                        var modal = bootstrap.Modal.getInstance(document.getElementById('addPackageModal'));
                        modal.hide();
                        // Redirect to packages.jsp after successful creation
                        window.location.href = "${pageContext.request.contextPath}/admin/packages.jsp";
                    } else {
                        alert('Error creating package: ' + data.message);
                    }
                } catch (e) {
                    throw new Error('Invalid JSON response: ' + e.message);
                }
            })
            .catch(error => {
                console.error("Error details:", error);
                alert('Error: ' + error.message);
            });
        }
    </script>
</body>
</html>
