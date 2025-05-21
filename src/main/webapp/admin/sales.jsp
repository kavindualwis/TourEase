<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="tourism.model.User" %>
<%@ page import="tourism.model.Booking" %>
<%@ page import="tourism.util.BookingFileHandler" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TourEase - Sales Management</title>
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
        .stat-card {
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .data-table {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
        }
        /* Status badges styling */
        .badge-completed {
            background-color: #28a745;
        }
        .badge-pending {
            background-color: #ffc107;
        }
        .badge-cancelled {
            background-color: #dc3545;
        }
        .badge-refunded {
            background-color: #17a2b8;
        }
        /* Modal styling for viewing bookings */
        .booking-detail {
            display: flex;
            align-items: flex-start;
            margin-bottom: 15px;
            border-bottom: 1px solid #e9ecef;
            padding-bottom: 15px;
        }
        .booking-detail:last-child {
            border-bottom: none;
        }
        .booking-detail i {
            color: #22A699;
            margin-right: 15px;
            margin-top: 3px;
            width: 16px;
        }
        .booking-detail-content {
            flex: 1;
        }
        .booking-detail-label {
            font-weight: 500;
            margin-bottom: 5px;
        }
        .booking-detail-value {
            color: #495057;
        }
        /* Status update select styling */
        #updateStatusSelect {
            border: 2px solid #ced4da;
            border-radius: 6px;
            padding: 8px 12px;
            transition: all 0.3s;
        }
        #updateStatusSelect:focus {
            border-color: #22A699;
            box-shadow: 0 0 0 0.25rem rgba(34, 166, 153, 0.25);
        }
        .status-update-btn {
            padding: 8px 15px;
            font-weight: 500;
            border-radius: 6px;
            transition: all 0.3s;
        }
        .status-update-btn:hover {
            transform: translateY(-2px);
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
        
        // Create BookingFileHandler instance
        BookingFileHandler bookingHandler = new BookingFileHandler();
        
        // Get all bookings for sales dashboard
        List<Booking> allBookings = bookingHandler.getAllBookings();
        
        // Sort bookings by booking date (most recent first)
        Collections.sort(allBookings, new Comparator<Booking>() {
            @Override
            public int compare(Booking b1, Booking b2) {
                try {
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                    LocalDateTime date1 = LocalDateTime.parse(b1.getBookingDate(), formatter);
                    LocalDateTime date2 = LocalDateTime.parse(b2.getBookingDate(), formatter);
                    return date2.compareTo(date1); // Most recent first
                } catch (Exception e) {
                    return 0; // Keep original order if date parsing fails
                }
            }
        });
        
        // Calculate statistics for dashboard
        double totalRevenue = 0;
        int totalBookings = allBookings.size();
        int completedBookings = 0;
        int pendingBookings = 0;
        
        for (Booking booking : allBookings) {
            String amount = booking.getAmount().replace("$", "").replace(",", "");
            try {
                totalRevenue += Double.parseDouble(amount);
            } catch (NumberFormatException e) {
                // Skip if amount isn't parseable
            }
            
            if ("Completed".equals(booking.getStatus())) {
                completedBookings++;
            } else if ("Pending".equals(booking.getStatus())) {
                pendingBookings++;
            }
        }
        
        double avgBookingValue = totalBookings > 0 ? totalRevenue / totalBookings : 0;
        double completionRate = totalBookings > 0 ? (double) completedBookings / totalBookings * 100 : 0;
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
                    <a class="nav-link active" href="sales.jsp">
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
                        <h2 class="border-bottom pb-2"><i class="fas fa-chart-line me-2"></i>Bookings Management</h2>
                    </div>
                </div>

                <!-- Stats Overview Cards -->
                <div class="row mb-4">
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="stat-card card bg-primary text-white h-100 py-2">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-uppercase mb-1">Total Revenue</div>
                                        <div class="h3 mb-0 font-weight-bold">$<%= String.format("%,.2f", totalRevenue) %></div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-dollar-sign fa-2x opacity-75"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="stat-card card bg-success text-white h-100 py-2">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-uppercase mb-1">Total Bookings</div>
                                        <div class="h3 mb-0 font-weight-bold"><%= totalBookings %></div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-calendar-check fa-2x opacity-75"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="stat-card card bg-info text-white h-100 py-2">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-uppercase mb-1">Completed Bookings</div>
                                        <div class="h3 mb-0 font-weight-bold"><%= completedBookings %></div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-check-circle fa-2x opacity-75"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="stat-card card bg-warning text-white h-100 py-2">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-uppercase mb-1">Pending Bookings</div>
                                        <div class="h3 mb-0 font-weight-bold"><%= pendingBookings %></div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-clock fa-2x opacity-75"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Add a notification badge for pending bookings -->
                <% if (pendingBookings > 0) { %>
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="alert alert-warning" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <strong><%= pendingBookings %> booking<%= pendingBookings > 1 ? "s" : "" %> pending approval</strong> - Please review these bookings and update their status.
                        </div>
                    </div>
                </div>
                <% } %>

                <!-- Sales Filter and Table -->
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="card shadow">
                            <div class="card-header py-3 bg-light d-flex justify-content-between align-items-center">
                                <h6 class="m-0 font-weight-bold">All Bookings</h6>
                                <span class="badge bg-primary"><%= totalBookings %> Total Records</span>
                            </div>
                            <div class="card-body">
                                <div class="row mb-3">
                                    <div class="col-md-3 mb-2">
                                        <label for="statusFilter" class="form-label">Filter by Status</label>
                                        <select class="form-select" id="statusFilter">
                                            <option value="all" selected>All Statuses</option>
                                            <option value="Completed">Completed</option>
                                            <option value="Pending">Pending</option>
                                            <option value="Cancelled">Cancelled</option>
                                            <option value="Refunded">Refunded</option>
                                        </select>
                                    </div>
                                    <div class="col-md-7 mb-2">
                                        <label for="searchBooking" class="form-label">Search</label>
                                        <input type="text" class="form-control" id="searchBooking" placeholder="Search by Order ID, Customer, Package...">
                                    </div>
                                    <div class="col-md-2 mb-2 d-flex align-items-end">
                                        <button class="btn btn-primary w-100" id="applyFiltersBtn">Apply Filters</button>
                                    </div>
                                </div>
                                
                                <div class="table-responsive data-table">
                                    <table class="table table-bordered table-hover" id="salesTable" width="100%" cellspacing="0">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Order ID</th>
                                                <th>Customer</th>
                                                <th>Package</th>
                                                <th>Date</th>
                                                <th>Amount</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% for (Booking booking : allBookings) { %>
                                            <tr data-order-id="<%= booking.getOrderId() %>">
                                                <td><%= booking.getOrderId() %></td>
                                                <td><%= booking.getUsername() %></td>
                                                <td><%= booking.getPackageName() %></td>
                                                <td><%= booking.getBookingDate().split(" ")[0] %></td>
                                                <td><%= booking.getAmount() %></td>
                                                <td>
                                                    <span class="badge badge-<%= booking.getStatus().toLowerCase() %> bg-<%= 
                                                        booking.getStatus().equals("Completed") ? "success" : 
                                                        booking.getStatus().equals("Pending") ? "warning" : 
                                                        booking.getStatus().equals("Cancelled") ? "danger" : "info" 
                                                    %>"><%= booking.getStatus() %></span>
                                                </td>
                                                <td>
                                                    <button class="btn btn-sm btn-info view-booking" 
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#viewBookingModal" 
                                                            data-order-id="<%= booking.getOrderId() %>"
                                                            data-customer="<%= booking.getUsername() %>"
                                                            data-package="<%= booking.getPackageName() %>"
                                                            data-amount="<%= booking.getAmount() %>"
                                                            data-date="<%= booking.getBookingDate() %>"
                                                            data-departure="<%= booking.getDepartureDate() %>"
                                                            data-destination="<%= booking.getDestination() %>"
                                                            data-status="<%= booking.getStatus() %>"
                                                            data-booking-type="<%= booking.getBookingType() %>"
                                                            data-participants="<%= booking.getParticipants() %>"
                                                            data-duration="<%= booking.getDuration() %>"
                                                            data-image="<%= booking.getPackageImage() %>">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                    <button class="btn btn-sm btn-warning edit-status" 
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#editStatusModal" 
                                                            data-order-id="<%= booking.getOrderId() %>"
                                                            data-status="<%= booking.getStatus() %>">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
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
    
    <!-- View Booking Modal -->
    <div class="modal fade" id="viewBookingModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title">Booking Details</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-5">
                            <img id="modalPackageImage" src="" class="img-fluid rounded mb-3" alt="Package Image">
                            <div class="card mb-3">
                                <div class="card-body">
                                    <h5 class="card-title" id="modalPackageName">Package Name</h5>
                                    <p class="card-text">
                                        <span id="modalPackageDestination">Destination</span> • 
                                        <span id="modalPackageDuration">Duration</span>
                                    </p>
                                    <h5 class="text-primary" id="modalPackagePrice">$0</h5>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-7">
                            <div class="booking-detail">
                                <i class="fas fa-tag"></i>
                                <div class="booking-detail-content">
                                    <div class="booking-detail-label">Order ID</div>
                                    <div class="booking-detail-value" id="modalOrderId">-</div>
                                </div>
                            </div>
                            <div class="booking-detail">
                                <i class="fas fa-user"></i>
                                <div class="booking-detail-content">
                                    <div class="booking-detail-label">Customer</div>
                                    <div class="booking-detail-value" id="modalCustomer">-</div>
                                </div>
                            </div>
                            <div class="booking-detail">
                                <i class="fas fa-calendar-check"></i>
                                <div class="booking-detail-content">
                                    <div class="booking-detail-label">Booking Date</div>
                                    <div class="booking-detail-value" id="modalBookingDate">-</div>
                                </div>
                            </div>
                            <div class="booking-detail">
                                <i class="fas fa-plane-departure"></i>
                                <div class="booking-detail-content">
                                    <div class="booking-detail-label">Departure Date</div>
                                    <div class="booking-detail-value" id="modalDepartureDate">-</div>
                                </div>
                            </div>
                            <div class="booking-detail">
                                <i class="fas fa-users"></i>
                                <div class="booking-detail-content">
                                    <div class="booking-detail-label">Participants</div>
                                    <div class="booking-detail-value" id="modalParticipants">-</div>
                                </div>
                            </div>
                            <div class="booking-detail">
                                <i class="fas fa-tag"></i>
                                <div class="booking-detail-content">
                                    <div class="booking-detail-label">Booking Type</div>
                                    <div class="booking-detail-value" id="modalBookingType">-</div>
                                </div>
                            </div>
                            <div class="booking-detail">
                                <i class="fas fa-clipboard-check"></i>
                                <div class="booking-detail-content">
                                    <div class="booking-detail-label">Status</div>
                                    <div class="booking-detail-value">
                                        <span class="badge" id="modalStatus">-</span>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="d-flex justify-content-end mt-3">
                                <button type="button" class="btn btn-secondary me-2" data-bs-dismiss="modal">Close</button>
                                <button type="button" class="btn btn-primary" id="openEditStatusBtn">
                                    <i class="fas fa-edit me-1"></i> Update Status
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Edit Status Modal -->
    <div class="modal fade" id="editStatusModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-warning">
                    <h5 class="modal-title">Update Booking Status</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="updateStatusForm">
                        <input type="hidden" id="updateOrderId" name="orderId">
                        
                        <div class="mb-3">
                            <label for="updateStatusSelect" class="form-label">Booking Status</label>
                            <select class="form-select" id="updateStatusSelect" name="status" required>
                                <option value="Completed">Completed</option>
                                <option value="Pending">Pending</option>
                                <option value="Cancelled">Cancelled</option>
                                <option value="Refunded">Refunded</option>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label for="statusNotes" class="form-label">Notes (optional)</label>
                            <textarea class="form-control" id="statusNotes" name="notes" rows="3" placeholder="Add notes about this status change..."></textarea>
                        </div>
                        
                        <div id="updateStatusAlert" class="alert d-none"></div>
                        
                        <div class="d-flex justify-content-end">
                            <button type="button" class="btn btn-secondary me-2" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-warning status-update-btn">
                                <i class="fas fa-save me-1"></i> Update Status
                            </button>
                        </div>
                    </form>
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
            const salesTable = $('#salesTable').DataTable({
                pageLength: 10,
                lengthMenu: [[5, 10, 25, 50, -1], [5, 10, 25, 50, "All"]],
                order: [[3, 'desc']] // Sort by date column descending
            });
            
            // Changed default filter to show all bookings instead of just Pending
            $('#statusFilter').val('all');
            
            // Apply filters when button is clicked
            $('#applyFiltersBtn').on('click', function() {
                const statusFilter = $('#statusFilter').val();
                const searchText = $('#searchBooking').val();
                
                // Clear existing filters
                salesTable.search('').columns().search('').draw();
                
                // Apply search if entered
                if (searchText) {
                    salesTable.search(searchText).draw();
                }
                
                // Apply status filter if not "all"
                if (statusFilter !== 'all') {
                    salesTable.column(5).search(statusFilter).draw();
                }
            });
            
            // View Booking Modal - Fixed to ensure data appears correctly
            $('.view-booking').on('click', function() {
                // Extract data attributes from button
                const orderId = $(this).data('order-id');
                const customer = $(this).data('customer');
                const packageName = $(this).data('package');
                const amount = $(this).data('amount');
                const bookingDate = $(this).data('date');
                const departureDate = $(this).data('departure');
                const destination = $(this).data('destination');
                const status = $(this).data('status');
                const bookingType = $(this).data('booking-type');
                const participants = $(this).data('participants');
                const duration = $(this).data('duration');
                const image = $(this).data('image');
                
                console.log("Debug - Viewing booking:", {
                    orderId, customer, packageName, amount, destination,
                    status, bookingType, participants, duration, image
                });
                
                // Clear previous modal data to avoid stale data
                $('#modalOrderId, #modalCustomer, #modalPackageName, #modalPackagePrice, ' +
                  '#modalBookingDate, #modalDepartureDate, #modalPackageDestination, ' +
                  '#modalParticipants, #modalBookingType, #modalPackageDuration').text('');
                
                // Populate modal with booking details - ensure we handle empty values
                $('#modalOrderId').text(orderId || 'N/A');
                $('#modalCustomer').text(customer || 'N/A');
                $('#modalPackageName').text(packageName || 'N/A');
                $('#modalPackagePrice').text(amount || '$0');
                $('#modalBookingDate').text(bookingDate || 'N/A');
                $('#modalDepartureDate').text(departureDate || 'N/A');
                $('#modalPackageDestination').text(destination || 'Not specified');
                $('#modalParticipants').text(participants || 'Not specified');
                
                // Proper handling of booking type
                let bookingTypeText = 'Not specified';
                if (bookingType) {
                    bookingTypeText = bookingType === 'standard' ? 'Standard Package' : 'Custom Package';
                }
                $('#modalBookingType').text(bookingTypeText);
                
                // Handle duration formatting
                $('#modalPackageDuration').text(duration ? duration + ' days' : 'Not specified');
                
                // Handle package image with proper error fallback
                const imagePlaceholder = 'https://via.placeholder.com/400x300?text=No+Image';
                const imageElement = $('#modalPackageImage');
                imageElement.off('error'); // Remove any previous error handlers
                
                if (image && image.trim() !== '') {
                    imageElement.attr('src', image).on('error', function() {
                        $(this).attr('src', imagePlaceholder);
                    });
                } else {
                    imageElement.attr('src', imagePlaceholder);
                }
                
                // Set status badge with proper coloring
                let badgeClass = 'badge bg-secondary'; // Default
                if (status) {
                    badgeClass = 'badge bg-' + 
                        (status === 'Completed' ? 'success' : 
                        (status === 'Pending' ? 'warning' : 
                        (status === 'Cancelled' ? 'danger' : 'info')));
                }
                $('#modalStatus').attr('class', badgeClass).text(status || 'Unknown');
                
                // Set orderId for the Update Status button
                $('#openEditStatusBtn').data('order-id', orderId);
                $('#openEditStatusBtn').data('current-status', status);
                
                // Force modal refresh to ensure content is displayed
                $('#viewBookingModal').modal('show');
            });
            
            // Open Edit Status modal from View Booking modal
            $('#openEditStatusBtn').on('click', function() {
                const orderId = $(this).data('order-id');
                const currentStatus = $(this).data('current-status');
                
                // Hide View Booking modal and show Edit Status modal
                $('#viewBookingModal').modal('hide');
                
                // Set values in Edit Status modal
                $('#updateOrderId').val(orderId);
                $('#updateStatusSelect').val(currentStatus);
                
                // Show Edit Status modal
                $('#editStatusModal').modal('show');
            });
            
            // Edit Status Modal
            $('.edit-status').on('click', function() {
                const orderId = $(this).data('order-id');
                const status = $(this).data('status');
                
                $('#updateOrderId').val(orderId);
                $('#updateStatusSelect').val(status);
            });
            
            // Handle form submission for status update
            $('#updateStatusForm').on('submit', function(e) {
                e.preventDefault();
                
                const orderId = $('#updateOrderId').val();
                const newStatus = $('#updateStatusSelect').val();
                const notes = $('#statusNotes').val();
                
                // Disable form elements and show loading state
                const submitBtn = $(this).find('button[type="submit"]');
                const originalBtnText = submitBtn.html();
                submitBtn.prop('disabled', true).html('<span class="spinner-border spinner-border-sm me-2"></span> Updating...');
                
                // AJAX request to update status
                $.ajax({
                    url: '../api/updateBookingStatus',
                    method: 'POST',
                    data: {
                        orderId: orderId,
                        status: newStatus,
                        notes: notes
                    },
                    success: function(response) {
                        // Show success message
                        const alertElem = $('#updateStatusAlert');
                        alertElem.removeClass('d-none alert-danger').addClass('alert-success')
                            .html('<i class="fas fa-check-circle me-2"></i> Status updated successfully!');
                        
                        // Update status in the table
                        const row = $(`tr[data-order-id="${orderId}"]`);
                        const statusBadge = row.find('td:eq(5) .badge');
                        
                        // Set new badge class based on status
                        const badgeClass = 'badge badge-' + newStatus.toLowerCase() + ' bg-' + 
                            (newStatus === 'Completed' ? 'success' : 
                            (newStatus === 'Pending' ? 'warning' : 
                            (newStatus === 'Cancelled' ? 'danger' : 'info')));
                        
                        statusBadge.attr('class', badgeClass).text(newStatus);
                        
                        // Update data attribute for future edits
                        row.find('.edit-status').data('status', newStatus);
                        
                        // Close modal after a delay
                        setTimeout(function() {
                            $('#editStatusModal').modal('hide');
                            // Reset form
                            $('#updateStatusForm')[0].reset();
                            alertElem.addClass('d-none');
                        }, 1500);
                    },
                    error: function(xhr) {
                        // Show error message
                        const alertElem = $('#updateStatusAlert');
                        alertElem.removeClass('d-none alert-success').addClass('alert-danger')
                            .html('<i class="fas fa-exclamation-circle me-2"></i> Failed to update status. Please try again.');
                    },
                    complete: function() {
                        // Re-enable form elements
                        submitBtn.prop('disabled', false).html(originalBtnText);
                    }
                });
            });
        });
    </script></body></html>