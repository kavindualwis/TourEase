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
            padding: 25px;
            min-height: calc(100vh - 40px);
            width: 100%;
        }
        .main-container {
            margin-left: 250px;
            transition: margin-left 0.3s;
            width: calc(100% - 250px);
        }
        .card.shadow {
            min-height: auto;
            display: block;
            margin: 0;
            padding: 1rem;
        }
        .card-body {
            overflow: visible;
            padding: 1rem;
        }
        .table-responsive {
            width: 100%;
            padding: 0;
            overflow: visible;
        }
        #packagesTable {
            width: 100% !important;
            font-size: 14px;
        }
        #packagesTable th {
            font-weight: 600;
            background-color: #f8f9fa;
            padding: 12px 10px;
            text-align: left;
        }
        #packagesTable td {
            padding: 10px;
            vertical-align: middle;
        }
        .dataTables_wrapper {
            height: 100%;
            width: 100%;
            display: flex;
            flex-direction: column;
            padding: 0.5rem;
        }
        .dataTables_info, .dataTables_paginate, .dataTables_length, .dataTables_filter {
            padding: 15px 10px;
        }
        .modal-body {
            padding: 1.5rem;
        }
        .modal-header, .modal-footer {
            padding: 1rem 1.5rem;
        }
        .form-label {
            margin-bottom: 0.5rem;
            font-weight: 500;
        }
        .badge {
            padding: 0.5rem 0.75rem;
            font-weight: 500;
        }
        .btn-sm {
            padding: 0.4rem 0.6rem;
        }
        @media (max-width: 768px) {
            .sidebar {
                width: 100%;
                position: static;
                height: auto;
            }
            .main-container {
                margin-left: 0;
                width: 100%;
            }
            .card.shadow {
                height: auto;
                min-height: 500px;
            }
        }
        .image-preview-container {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 10px;
        }
        .image-preview {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .image-input-container {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }
        .image-input-container .btn {
            margin-left: 10px;
        }
        .package-image-item {
            position: relative;
            display: inline-block;
        }
        .remove-image {
            position: absolute;
            top: -8px;
            right: -8px;
            background-color: #dc3545;
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            text-align: center;
            line-height: 20px;
            cursor: pointer;
            font-size: 12px;
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
                    <a class="nav-link" href="dashboard.jsp">
                        <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="packages.jsp">
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
                    <div class="col-md-8">
                        <h2><i class="fas fa-box me-2"></i>Package Management</h2>
                    </div>
                    <div class="col-md-4 text-end">
                        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addPackageModal">
                            <i class="fas fa-plus me-2"></i>Add New Package
                        </button>
                    </div>
                </div>

                <div class="card shadow">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table id="packagesTable" class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Package Name</th>
                                        <th>Destination</th>
                                        <th>Category</th>
                                        <th>Duration</th>
                                        <th>Price</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="packageTableBody">
                                    <!-- Package data will be loaded dynamically -->
                                </tbody>
                            </table>
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
                        <!-- Hidden field for packageId with shorter format -->
                        <input type="hidden" id="packageId" name="packageId" 
                               value="PKG_<%= String.format("%04d", (int)(Math.random() * 10000)) %>">
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
                                <label for="category" class="form-label">Category</label>
                                <select class="form-select" id="category" name="category" required>
                                    <option value="Western Province / Colombo & Surroundings">Western Province / Colombo & Surroundings</option>
                                    <option value="Wildlife & Nature Reserves">Wildlife & Nature Reserves</option>
                                    <option value="Northern Region">Northern Region</option>
                                    <option value="East Coast">East Coast</option>
                                    <option value="Cultural Triangle (Middle Country / Ancient Cities)">Cultural Triangle (Middle Country / Ancient Cities)</option>
                                    <option value="Upcountry / Hill Country (Central Highlands)">Upcountry / Hill Country (Central Highlands)</option>
                                    <option value="Down South (Southern Coast)">Down South (Southern Coast)</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="status" class="form-label">Status</label>
                                <select class="form-select" id="status" name="status" required>
                                    <option value="active">Active</option>
                                    <option value="limited">Limited Availability</option>
                                    <option value="soldout">Sold Out</option>
                                    <option value="hidden">Hidden</option>
                                </select>
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
                            <label class="form-label">Package Images</label>
                            <div id="packageImagesContainer">
                                <div class="image-input-container">
                                    <input type="text" class="form-control" name="packageImages[]" placeholder="Image URL">
                                    <button type="button" class="btn btn-sm btn-primary add-more-images">+</button>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" form="addPackageForm" class="btn btn-success">Add Package</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Package Modal -->
    <div class="modal fade" id="editPackageModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-info text-white">
                    <h5 class="modal-title">Edit Package</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="editPackageForm">
                        <input type="hidden" id="edit_packageId" name="packageId">
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="edit_packageName" class="form-label">Package Name</label>
                                <input type="text" class="form-control" id="edit_packageName" name="packageName" required>
                            </div>
                            <div class="col-md-6">
                                <label for="edit_destination" class="form-label">Destination</label>
                                <input type="text" class="form-control" id="edit_destination" name="destination" required>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="edit_category" class="form-label">Category</label>
                                <select class="form-select" id="edit_category" name="category" required>
                                    <option value="Western Province / Colombo & Surroundings">Western Province / Colombo & Surroundings</option>
                                    <option value="Wildlife & Nature Reserves">Wildlife & Nature Reserves</option>
                                    <option value="Northern Region">Northern Region</option>
                                    <option value="East Coast">East Coast</option>
                                    <option value="Cultural Triangle (Middle Country / Ancient Cities)">Cultural Triangle (Middle Country / Ancient Cities)</option>
                                    <option value="Upcountry / Hill Country (Central Highlands)">Upcountry / Hill Country (Central Highlands)</option>
                                    <option value="Down South (Southern Coast)">Down South (Southern Coast)</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="edit_status" class="form-label">Status</label>
                                <select class="form-select" id="edit_status" name="status" required>
                                    <option value="active">Active</option>
                                    <option value="limited">Limited Availability</option>
                                    <option value="soldout">Sold Out</option>
                                    <option value="hidden">Hidden</option>
                                </select>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="edit_duration" class="form-label">Duration (days)</label>
                                <input type="number" class="form-control" id="edit_duration" name="duration" min="1" required>
                            </div>
                            <div class="col-md-6">
                                <label for="edit_price" class="form-label">Price ($)</label>
                                <input type="number" class="form-control" id="edit_price" name="price" min="0" step="0.01" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="edit_description" class="form-label">Description</label>
                            <textarea class="form-control" id="edit_description" name="description" rows="3" required></textarea>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="edit_maxParticipants" class="form-label">Max Participants</label>
                                <input type="number" class="form-control" id="edit_maxParticipants" name="maxParticipants" min="1" required>
                            </div>
                            <div class="col-md-6">
                                <label for="edit_departureDate" class="form-label">Departure Date</label>
                                <input type="date" class="form-control" id="edit_departureDate" name="departureDate" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Package Images</label>
                            <div id="edit_packageImagesContainer">
                                <!-- Will be populated dynamically -->
                            </div>
                            <button type="button" class="btn btn-sm btn-primary mt-2" id="edit_add_more_images">Add More Images</button>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Current Images</label>
                            <div id="edit_current_images" class="image-preview-container">
                                <!-- Will be populated dynamically -->
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" id="updatePackageBtn" class="btn btn-primary">Update</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title">Confirm Delete</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete this package?</p>
                    <p id="deletePackageName" class="fw-bold"></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" id="confirmDeleteBtn" class="btn btn-danger">Delete</button>
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
            // Initialize DataTable with improved options for larger display
            var table = $('#packagesTable').DataTable({
                "responsive": true,
                "scrollY": false,
                "scrollCollapse": false,
                "paging": true,
                "lengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                "pageLength": 10,
                "ordering": false, // Disable sorting functionality
                "autoWidth": true,
                "language": {
                    "search": "Search packages:  ",
                    "lengthMenu": "Show _MENU_ packages per page",
                    "info": "Showing _START_ to _END_ of _TOTAL_ packages",
                    "infoEmpty": "Showing 0 to 0 of 0 packages",
                    "infoFiltered": "(filtered from _MAX_ total packages)"
                },
                "columnDefs": [
                    { "width": "7%", "targets": 0, "className": "ps-3" },
                    { "width": "15%", "targets": 1 },
                    { "width": "13%", "targets": 2 },
                    { "width": "16%", "targets": 3 },
                    { "width": "8%", "targets": 4, "className": "text-center" },
                    { "width": "8%", "targets": 5, "className": "text-center" },
                    { "width": "10%", "targets": 6, "className": "text-center" },
                    { "width": "13%", "targets": 7, "className": "text-center" }
                ]
            });
            
            // Remove automatic adjustment
            $(window).resize(function() {
                // No need to adjust columns
            });
            
            // Remove initial adjustment
            setTimeout(function() {
                // No need to adjust columns
            }, 100);
            
            // Load packages when page loads
            loadPackages();
            
            // Function to generate short package ID
            function generateShortPackageId() {
                return "PKG_" + String(Math.floor(1000 + Math.random() * 9000));
            }
            
            // Update the package ID when modal is shown
            $('#addPackageModal').on('show.bs.modal', function() {
                $('#packageId').val(generateShortPackageId());
            });
            
            // Add more image fields in add package form
            $(document).on('click', '.add-more-images', function() {
                $('#packageImagesContainer').append(
                    '<div class="image-input-container">' +
                    '<input type="text" class="form-control" name="packageImages[]" placeholder="Image URL">' +
                    '<button type="button" class="btn btn-sm btn-danger remove-image-field">x</button>' +
                    '</div>'
                );
            });
            
            // Remove image field in add package form
            $(document).on('click', '.remove-image-field', function() {
                $(this).closest('.image-input-container').remove();
            });
            
            // Add more image fields in edit package form
            $('#edit_add_more_images').click(function() {
                $('#edit_packageImagesContainer').append(
                    '<div class="image-input-container">' +
                    '<input type="text" class="form-control" name="packageImages[]" placeholder="Image URL">' +
                    '<button type="button" class="btn btn-sm btn-danger remove-image-field">x</button>' +
                    '</div>'
                );
            });
            
            // Remove image from edit form
            $(document).on('click', '.remove-package-image', function() {
                $(this).closest('.package-image-item').remove();
            });
            
            // Function to load all packages
            function loadPackages() {
                console.log("Loading packages...");
                $.ajax({
                    // Update URL to match new servlet pattern
                    url: '${pageContext.request.contextPath}/admin/packages/manage',
                    method: 'GET',
                    cache: false,
                    dataType: 'text',
                    success: function(response) {
                        console.log("Packages loaded");
                        table.clear().draw();
                        
                        // Parse the text response into package objects
                        var packages = parsePackagesResponse(response);
                        console.log("Parsed packages:", packages);
                        
                        // Add each package to the table
                        $.each(packages, function(i, pkg) {
                            // Create status badge
                            let statusBadge = '';
                            if (pkg.status === 'active') {
                                statusBadge = '<span class="badge bg-success">Active</span>';
                            } else if (pkg.status === 'limited') {
                                statusBadge = '<span class="badge bg-warning text-dark">Limited</span>';
                            } else if (pkg.status === 'soldout') {
                                statusBadge = '<span class="badge bg-danger">Sold Out</span>';
                            } else {
                                statusBadge = '<span class="badge bg-secondary">Hidden</span>';
                            }
                            
                            // Format price with $ and 2 decimal places
                            let formattedPrice = '$' + parseFloat(pkg.price).toFixed(2);
                            
                            // Default category if not present
                            let category = pkg.category || 'Western Province / Colombo & Surroundings';
                            
                            // Add row to table with category column
                            table.row.add([
                                '<span class="ps-2">' + pkg.packageId + '</span>',
                                '<span class="fw-medium">' + pkg.packageName + '</span>',
                                pkg.destination,
                                category,
                                '<span class="text-center d-block">' + pkg.duration + ' days</span>',
                                '<span class="text-center d-block">' + formattedPrice + '</span>',
                                '<div class="text-center">' + statusBadge + '</div>',
                                '<div class="d-flex justify-content-center py-1">' +
                                '<button class="btn btn-sm btn-info text-white me-2 edit-btn" data-id="' + pkg.packageId + '">' +
                                '<i class="fas fa-edit"></i></button>' +
                                '<button class="btn btn-sm btn-danger delete-btn" data-id="' + pkg.packageId + '" ' +
                                'data-name="' + pkg.packageName + '"><i class="fas fa-trash"></i></button>' +
                                '</div>'
                            ]).draw(false);
                        });
                    },
                    error: function(xhr, status, error) {
                        console.error("Error loading packages:", error);
                        console.error("Status:", status);
                        console.error("XHR:", xhr);
                        alert("Failed to load packages. Please try again.");
                    }
                });
            }
            
            // Function to parse text response into package objects
            function parsePackagesResponse(text) {
                var packages = [];
                var lines = text.split('\n');
                var currentPackage = null;
                
                for (var i = 0; i < lines.length; i++) {
                    var line = lines[i].trim();
                    
                    if (line.startsWith("Total Packages:")) {
                        // Skip the header line
                        continue;
                    } else if (line.startsWith("Package ID:")) {
                        // Start of a new package
                        if (currentPackage !== null) {
                            packages.push(currentPackage);
                        }
                        currentPackage = {};
                        currentPackage.packageId = line.substring("Package ID:".length).trim();
                    } else if (line.startsWith("Name:") && currentPackage) {
                        currentPackage.packageName = line.substring("Name:".length).trim();
                    } else if (line.startsWith("Destination:") && currentPackage) {
                        currentPackage.destination = line.substring("Destination:".length).trim();
                    } else if (line.startsWith("Category:") && currentPackage) {
                        currentPackage.category = line.substring("Category:".length).trim();
                    } else if (line.startsWith("Duration:") && currentPackage) {
                        currentPackage.duration = parseInt(line.substring("Duration:".length).trim());
                    } else if (line.startsWith("Price:") && currentPackage) {
                        currentPackage.price = parseFloat(line.substring("Price:".length).trim());
                    } else if (line.startsWith("Description:") && currentPackage) {
                        currentPackage.description = line.substring("Description:".length).trim();
                    } else if (line.startsWith("Max Participants:") && currentPackage) {
                        currentPackage.maxParticipants = parseInt(line.substring("Max Participants:".length).trim());
                    } else if (line.startsWith("Departure Date:") && currentPackage) {
                        currentPackage.departureDate = line.substring("Departure Date:".length).trim();
                    } else if (line.startsWith("Status:") && currentPackage) {
                        currentPackage.status = line.substring("Status:".length).trim();
                    } else if (line.startsWith("Images:") && currentPackage) {
                        var imagesStr = line.substring("Images:".length).trim();
                        if (imagesStr !== "None") {
                            currentPackage.packageImages = imagesStr.split(', ');
                        } else {
                            currentPackage.packageImages = [];
                        }
                    }
                    
                    // End of package indicated by empty line
                    if (line === "" && currentPackage !== null && i > 0 && lines[i-1].trim() !== "") {
                        packages.push(currentPackage);
                        currentPackage = null;
                    }
                }
                
                // Add the last package if it exists and wasn't added
                if (currentPackage !== null) {
                    packages.push(currentPackage);
                }
                
                return packages;
            }
            
            // Handle form submission for adding new package
            $('#addPackageForm').on('submit', function(e) {
                e.preventDefault();
                
                // Collect package images
                var packageImages = [];
                $('input[name="packageImages[]"]').each(function() {
                    if ($(this).val().trim() !== '') {
                        packageImages.push($(this).val().trim());
                    }
                });
                
                // If no images added, use default
                if (packageImages.length === 0) {
                    packageImages.push("default.jpg");
                }
                
                $.ajax({
                    // Update URL to match new servlet pattern
                    url: '${pageContext.request.contextPath}/admin/packages/manage',
                    type: 'POST',
                    data: {
                        packageId: $('#packageId').val(),
                        packageName: $('#packageName').val(),
                        destination: $('#destination').val(),
                        category: $('#category').val(),
                        duration: $('#duration').val(),
                        price: $('#price').val(),
                        description: $('#description').val(),
                        maxParticipants: $('#maxParticipants').val(),
                        departureDate: $('#departureDate').val(),
                        status: $('#status').val(),
                        packageImage: packageImages.join(',') // Join multiple images with comma
                    },
                    dataType: 'text',
                    success: function(response) {
                        console.log("Add package response:", response);
                        
                        // Check if response contains success message
                        if (response.includes("added successfully")) {
                            $('#addPackageModal').modal('hide');
                            loadPackages();
                            alert('Package added successfully!');
                            $('#addPackageForm')[0].reset();
                        } else {
                            alert('Error: ' + response);
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error("Error adding package:", error);
                        alert("Failed to add package. Please try again.");
                    }
                });
            });
            
            // Handle edit button click
            $('#packagesTable').on('click', '.edit-btn', function() {
                var packageId = $(this).data('id');
                
                // Get package details
                $.ajax({
                    url: '${pageContext.request.contextPath}/admin/packages/manage?id=' + packageId,
                    method: 'GET',
                    cache: false,
                    dataType: 'text',
                    success: function(response) {
                        // Parse the text response into a package object
                        var pkg = parsePackageDetailResponse(response);
                        
                        // Populate edit form
                        $('#edit_packageId').val(pkg.packageId);
                        $('#edit_packageName').val(pkg.packageName);
                        $('#edit_destination').val(pkg.destination);
                        $('#edit_category').val(pkg.category || 'Western Province / Colombo & Surroundings');
                        $('#edit_duration').val(pkg.duration);
                        $('#edit_price').val(pkg.price);
                        $('#edit_description').val(pkg.description);
                        $('#edit_maxParticipants').val(pkg.maxParticipants);
                        $('#edit_departureDate').val(pkg.departureDate);
                        $('#edit_status').val(pkg.status || 'active');
                        
                        // Clear existing image fields
                        $('#edit_packageImagesContainer').empty();
                        $('#edit_current_images').empty();
                        
                        // Display current images
                        if (pkg.packageImages && pkg.packageImages.length > 0) {
                            pkg.packageImages.forEach(function(image, index) {
                                $('#edit_current_images').append(
                                    '<div class="package-image-item">' +
                                    '<img src="' + image + '" alt="Package image ' + (index+1) + '" class="image-preview">' +
                                    '<div class="remove-image remove-package-image" data-image="' + image + '">×</div>' +
                                    '<input type="hidden" name="existingImages[]" value="' + image + '">' +
                                    '</div>'
                                );
                            });
                        }
                        
                        // Add one empty image field
                        $('#edit_packageImagesContainer').append(
                            '<div class="image-input-container">' +
                            '<input type="text" class="form-control" name="packageImages[]" placeholder="Image URL">' +
                            '<button type="button" class="btn btn-sm btn-primary add-more-images">+</button>' +
                            '</div>'
                        );
                        
                        // Show edit modal
                        $('#editPackageModal').modal('show');
                    },
                    error: function(xhr, status, error) {
                        console.error("Error loading package details:", error);
                        alert("Failed to load package details. Please try again.");
                    }
                });
            });
            
            // Function to parse package detail response
            function parsePackageDetailResponse(text) {
                var pkg = {};
                var lines = text.split('\n');
                
                for (var i = 0; i < lines.length; i++) {
                    var line = lines[i].trim();
                    
                    if (line.startsWith("Package ID:")) {
                        pkg.packageId = line.substring("Package ID:".length).trim();
                    } else if (line.startsWith("Name:")) {
                        pkg.packageName = line.substring("Name:".length).trim();
                    } else if (line.startsWith("Destination:")) {
                        pkg.destination = line.substring("Destination:".length).trim();
                    } else if (line.startsWith("Category:")) {
                        pkg.category = line.substring("Category:".length).trim();
                    } else if (line.startsWith("Duration:")) {
                        pkg.duration = parseInt(line.substring("Duration:".length).trim());
                    } else if (line.startsWith("Price:")) {
                        pkg.price = parseFloat(line.substring("Price:".length).trim());
                    } else if (line.startsWith("Description:")) {
                        pkg.description = line.substring("Description:".length).trim();
                    } else if (line.startsWith("Max Participants:")) {
                        pkg.maxParticipants = parseInt(line.substring("Max Participants:".length).trim());
                    } else if (line.startsWith("Departure Date:")) {
                        pkg.departureDate = line.substring("Departure Date:".length).trim();
                    } else if (line.startsWith("Status:")) {
                        pkg.status = line.substring("Status:".length).trim();
                    } else if (line.startsWith("Images:")) {
                        var imagesStr = line.substring("Images:".length).trim();
                        if (imagesStr !== "None") {
                            pkg.packageImages = imagesStr.split(', ');
                        } else {
                            pkg.packageImages = [];
                        }
                    }
                }
                
                return pkg;
            }
            
            // Handle update button click
            $('#updatePackageBtn').click(function() {
                // Collect form data
                var packageId = $('#edit_packageId').val();
                var packageName = $('#edit_packageName').val();
                var destination = $('#edit_destination').val();
                var category = $('#edit_category').val();
                var duration = $('#edit_duration').val();
                var price = $('#edit_price').val();
                var description = $('#edit_description').val();
                var maxParticipants = $('#edit_maxParticipants').val();
                var departureDate = $('#edit_departureDate').val();
                var status = $('#edit_status').val();
                
                // Collect existing images
                var existingImages = [];
                $('input[name="existingImages[]"]').each(function() {
                    existingImages.push($(this).val());
                });
                
                // Collect new images
                var newImages = [];
                $('#edit_packageImagesContainer input[name="packageImages[]"]').each(function() {
                    if ($(this).val().trim() !== '') {
                        newImages.push($(this).val().trim());
                    }
                });
                
                // Combine existing and new images
                var allImages = existingImages.concat(newImages);
                
                // If no images, use default
                if (allImages.length === 0) {
                    allImages = ["default.jpg"];
                }
                
                // Prepare data as form-urlencoded format
                var formData = 
                    'packageId=' + encodeURIComponent(packageId) +
                    '&packageName=' + encodeURIComponent(packageName) +
                    '&destination=' + encodeURIComponent(destination) +
                    '&category=' + encodeURIComponent(category) +
                    '&duration=' + encodeURIComponent(duration) +
                    '&price=' + encodeURIComponent(price) +
                    '&description=' + encodeURIComponent(description) +
                    '&maxParticipants=' + encodeURIComponent(maxParticipants) +
                    '&departureDate=' + encodeURIComponent(departureDate) +
                    '&status=' + encodeURIComponent(status) +
                    '&packageImage=' + encodeURIComponent(allImages.join(','));
                
                console.log("Sending update with data:", formData);
                
                // Update package using form-urlencoded data
                $.ajax({
                    url: '${pageContext.request.contextPath}/admin/packages/manage',
                    method: 'PUT',
                    data: formData,
                    contentType: 'application/x-www-form-urlencoded',
                    dataType: 'text',
                    success: function(response) {
                        console.log("Update response:", response);
                        
                        if (response.includes("updated successfully")) {
                            $('#editPackageModal').modal('hide');
                            loadPackages();
                            alert('Package updated successfully!');
                        } else {
                            alert('Error: ' + response);
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error("Error updating package:", error);
                        console.error("Status:", status);
                        console.error("XHR response:", xhr.responseText);
                        alert("Failed to update package. Please try again.");
                    }
                });
            });
            
            // Handle delete button click in table
            $(document).on('click', '.delete-btn', function() {
                var packageId = $(this).data('id');
                var packageName = $(this).data('name');
                
                console.log("Delete clicked for package ID:", packageId, "Name:", packageName);
                
                // Set package name in confirmation modal
                $('#deletePackageName').text(packageName);
                
                // Store packageId for deletion
                $('#confirmDeleteBtn').data('id', packageId);
                
                // Show delete modal
                $('#deleteModal').modal('show');
            });
            
            // Handle confirm delete button click
            $('#confirmDeleteBtn').click(function() {
                var packageId = $(this).data('id');
                
                console.log("Confirming delete for package ID:", packageId);
                
                // Delete package with better error logging
                $.ajax({
                    url: '${pageContext.request.contextPath}/admin/packages/manage?id=' + packageId,
                    method: 'DELETE',
                    dataType: 'text',
                    success: function(response) {
                        console.log("Delete response:", response);
                        $('#deleteModal').modal('hide');
                        
                        if (response.includes("deleted successfully")) {
                            loadPackages();
                            alert('Package deleted successfully!');
                        } else {
                            alert('Error: ' + response);
                        }
                    },
                    error: function(xhr, status, error) {
                        $('#deleteModal').modal('hide');
                        console.error("Error deleting package:", error);
                        console.error("Status:", status);
                        console.error("XHR response:", xhr.responseText);
                        alert("Failed to delete package. Please try again.");
                    }
                });
            });
        });
    </script>
</body>
</html>
