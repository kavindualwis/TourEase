<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="tourism.model.User" %>
<%@ page import="tourism.model.Inquiry" %>
<%@ page import="tourism.util.InquiryFileHandler" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TourEase - Inquiry Management</title>
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
        .inquiry-card {
            border-left: 4px solid #0d6efd;
            transition: transform 0.2s;
        }
        .inquiry-card:hover {
            transform: translateY(-3px);
        }
        .priority-high {
            border-left-color: #dc3545;
        }
        .priority-medium {
            border-left-color: #ffc107;
        }
        .priority-low {
            border-left-color: #198754;
        }
        .status-badge {
            font-size: 0.8rem;
            padding: 0.25rem 0.5rem;
        }
        .inquiry-filters {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
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
        
        // Create InquiryFileHandler instance
        InquiryFileHandler inquiryHandler = new InquiryFileHandler();
        
        // Get all inquiries
        List<Inquiry> allInquiries = inquiryHandler.getAllInquiries();
        
        // Count inquiries by status
        int newCount = 0;
        int answeredCount = 0;
        
        for (Inquiry inquiry : allInquiries) {
            if (inquiry.getResponseMessage() == null || inquiry.getResponseMessage().trim().isEmpty()) {
                newCount++;
            } else {
                answeredCount++;
            }
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
                    <a class="nav-link active" href="inquiries.jsp">
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
                        <h2 class="border-bottom pb-2"><i class="fas fa-question-circle me-2"></i>Inquiry Management</h2>
                    </div>
                </div>

                <!-- Success/Error Messages -->
                <% 
                    String deleted = request.getParameter("deleted");
                    String responded = request.getParameter("responded");
                    
                    if ("true".equals(deleted)) { 
                %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i> Inquiry has been deleted successfully.
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                <% } else if ("false".equals(deleted)) { %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-times-circle me-2"></i> There was an error deleting the inquiry.
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                <% }
                    
                    if ("true".equals(responded)) { 
                %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i> Your response has been sent successfully.
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                <% } else if ("false".equals(responded)) { %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-times-circle me-2"></i> There was an error sending your response.
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                <% } %>

                <!-- Summary Stats -->
                <div class="row mb-4">
                    <div class="col-md-6 mb-4">
                        <div class="card border-left-primary shadow h-100 py-2">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                            New Inquiries</div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800"><%= newCount %></div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-envelope fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6 mb-4">
                        <div class="card border-left-success shadow h-100 py-2">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                            Answered</div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800"><%= answeredCount %></div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-check-circle fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Inquiries Table -->
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="card shadow">
                            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                                <h6 class="m-0 font-weight-bold">All Inquiries</h6>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover" id="inquiryTable">
                                        <thead class="table-light">
                                            <tr>
                                                <th>ID</th>
                                                <th>Subject</th>
                                                <th>Customer</th>
                                                <th>Package</th>
                                                <th>Type</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% for (Inquiry inquiry : allInquiries) {
                                                boolean hasResponse = inquiry.getResponseMessage() != null && !inquiry.getResponseMessage().trim().isEmpty();
                                                
                                                // Properly escape values for JavaScript
                                                String escapedSubject = inquiry.getSubject().replace("'", "\\'");
                                                String escapedUserName = inquiry.getUserFullName().replace("'", "\\'");
                                                String escapedMessage = inquiry.getMessage().replace("'", "\\'");
                                                String escapedPackageName = inquiry.getPackageName().replace("'", "\\'");
                                                String escapedResponse = hasResponse ? inquiry.getResponseMessage().replace("'", "\\'") : "";
                                            %>
                                            <tr>
                                                <td>#<%= inquiry.getId() %></td>
                                                <td><%= inquiry.getSubject() %></td>
                                                <td><%= inquiry.getUserFullName() %></td>
                                                <td><%= inquiry.getPackageName() %></td>
                                                <td><%= inquiry.getType() %></td>
                                                <td>
                                                    <span class="badge <%= hasResponse ? "bg-success" : "bg-primary" %>">
                                                        <%= hasResponse ? "Answered" : "New" %>
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="btn-group">
                                                        <button class="btn btn-sm btn-info" 
                                                                onclick="viewInquiry('<%= inquiry.getId() %>', '<%= escapedSubject %>', '<%= escapedUserName %>', '<%= escapedMessage %>', '<%= escapedPackageName %>', '<%= inquiry.getContactMethod() %>', '<%= escapedResponse %>')">
                                                            <i class="fas fa-eye"></i>
                                                        </button>
                                                        <% if (!hasResponse) { %>
                                                        <button class="btn btn-sm btn-success" 
                                                                onclick="respondInquiry('<%= inquiry.getId() %>', '<%= escapedSubject %>', '<%= escapedUserName %>', '<%= escapedMessage %>', '<%= escapedPackageName %>')">
                                                            <i class="fas fa-reply"></i>
                                                        </button>
                                                        <% } %>
                                                        <button class="btn btn-sm btn-danger delete-inquiry-btn" 
                                                                data-id="<%= inquiry.getId() %>"
                                                                data-subject="<%= escapedSubject %>"
                                                                data-bs-toggle="modal" data-bs-target="#deleteInquiryModal">
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
        </div>
    </div>

    <!-- View Inquiry Modal -->
    <div class="modal fade" id="viewInquiryModal" tabindex="-1" aria-labelledby="viewInquiryModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="viewInquiryModalLabel">View Inquiry Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="inquiry-details">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <h5 id="inquirySubject"></h5>
                                <p class="text-muted mb-1" id="inquiryId"></p>
                                <p class="mb-1"><strong>From:</strong> <span id="inquiryCustomer"></span></p>
                                <p class="mb-1"><strong>Package:</strong> <span id="inquiryPackage"></span></p>
                            </div>
                            <div class="col-md-6 text-md-end">
                                <p class="mb-1"><strong>Contact via:</strong> <span id="inquiryContact"></span></p>
                            </div>
                        </div>
                        
                        <hr>
                        
                        <div class="row mb-4">
                            <div class="col-12">
                                <h6>Customer's Message:</h6>
                                <div class="card bg-light">
                                    <div class="card-body" id="inquiryMessage">
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row response-section" id="responseSection">
                            <div class="col-12">
                                <h6>Your Response:</h6>
                                <div class="card bg-light">
                                    <div class="card-body" id="responseMessage">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Respond to Inquiry Modal -->
    <div class="modal fade" id="respondInquiryModal" tabindex="-1" aria-labelledby="respondInquiryModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title" id="respondInquiryModalLabel">Respond to Inquiry</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="respondForm" action="${pageContext.request.contextPath}/respondToInquiry" method="post">
                    <div class="modal-body">
                        <!-- Important: Fixed input name to match what servlet expects -->
                        <input type="hidden" id="respondInquiryId" name="inquiryId">
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <h5 id="respondSubject"></h5>
                                <p class="mb-1"><strong>From:</strong> <span id="respondCustomer"></span></p>
                                <p class="mb-1"><strong>Package:</strong> <span id="respondPackage"></span></p>
                            </div>
                        </div>
                        
                        <hr>
                        
                        <div class="row mb-4">
                            <div class="col-12">
                                <h6>Customer's Message:</h6>
                                <div class="card bg-light mb-3">
                                    <div class="card-body" id="respondMessage">
                                    </div>
                                </div>
                                
                                <h6>Your Response:</h6>
                                <textarea class="form-control" id="responseMessage" name="responseMessage" rows="6" required></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-success" id="submitResponseBtn">Send Response</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Delete Inquiry Modal -->
    <div class="modal fade" id="deleteInquiryModal" tabindex="-1" aria-labelledby="deleteInquiryModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="deleteInquiryModalLabel">Delete Inquiry</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete inquiry <strong>#<span id="deleteId"></span></strong> about "<span id="deleteSubject"></span>"?</p>
                    <p class="mb-0 text-danger"><strong>Warning:</strong> This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <form action="<%= request.getContextPath() %>/deleteInquiry" method="post">
                        <input type="hidden" id="deleteInquiryId" name="inquiryId">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger">Delete Inquiry</button>
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
            // Initialize DataTables
            $('#inquiryTable').DataTable({
                pageLength: 10,
                lengthMenu: [[5, 10, 25, 50, -1], [5, 10, 25, 50, "All"]]
            });
            
            // Delete inquiry setup
            $('.delete-inquiry-btn').click(function() {
                const id = $(this).data('id');
                const subject = $(this).data('subject');
                
                $('#deleteId').text(id);
                $('#deleteSubject').text(subject);
                $('#deleteInquiryId').val(id);
            });
        });
        
        // View Inquiry Details
        function viewInquiry(id, subject, customer, message, packageName, contact, response) {
            document.getElementById('inquiryId').textContent = '#' + id;
            document.getElementById('inquirySubject').textContent = subject;
            document.getElementById('inquiryCustomer').textContent = customer;
            document.getElementById('inquiryMessage').textContent = message;
            document.getElementById('inquiryPackage').textContent = packageName;
            document.getElementById('inquiryContact').textContent = contact;
            
            const responseSection = document.getElementById('responseSection');
            const responseMessage = document.getElementById('responseMessage');
            
            if (response && response.trim() !== '') {
                responseSection.style.display = 'block';
                responseMessage.textContent = response;
            } else {
                responseSection.style.display = 'none';
            }
            
            $('#viewInquiryModal').modal('show');
        }
        
        // Respond to Inquiry - Fixed function to properly set the inquiry ID
        function respondInquiry(id, subject, customer, message, packageName) {
            console.log("Setting up response for inquiry ID:", id);
            
            // Set hidden field value
            document.getElementById('respondInquiryId').value = id;
            
            // Set other display fields
            document.getElementById('respondSubject').textContent = subject;
            document.getElementById('respondCustomer').textContent = customer;
            document.getElementById('respondMessage').textContent = message;
            document.getElementById('respondPackage').textContent = packageName;
            
            // Debug: print the values that were set
            console.log("Form values set:", {
                inquiryId: document.getElementById('respondInquiryId').value,
                subject: subject,
                customer: customer
            });
            
            // Show the modal
            $('#respondInquiryModal').modal('show');
            
            // Additional safety check - attach an event listener to the form submission
            $('#respondForm').off('submit').on('submit', function(e) {
                const idValue = document.getElementById('respondInquiryId').value;
                const responseText = document.getElementById('responseMessage').value;
                
                console.log("Form submitted with inquiry ID:", idValue);
                console.log("Response text:", responseText);
                
                if (!idValue || idValue.trim() === '') {
                    console.error("Missing inquiry ID! Preventing submission.");
                    e.preventDefault();
                    alert("Error: Missing inquiry ID. Please try again or contact support.");
                    return false;
                }
                
                return true;
            });
        }
    </script>
</body>
</html>
