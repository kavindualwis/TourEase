<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="tourism.model.User" %>
<%@ page import="tourism.model.Inquiry" %>
<%@ page import="tourism.util.InquiryFileHandler" %>
<%@ page import="java.util.List" %>
<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login");
        return;
    }
    
    // Create an instance of InquiryFileHandler
    InquiryFileHandler inquiryHandler = new InquiryFileHandler();
    
    // Get all inquiries for this user using the instance method
    List<Inquiry> inquiries = inquiryHandler.getInquiriesByUsername(user.getUsername());
    
    // Debug: Count inquiries with and without responses
    int withResponseCount = 0;
    int withoutResponseCount = 0;
    
    for (Inquiry inq : inquiries) {
        if (inq.getResponseMessage() != null && !inq.getResponseMessage().trim().isEmpty()) {
            withResponseCount++;
        } else {
            withoutResponseCount++;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Inquiries - TourEase</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- AOS Animation library -->
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2c3e50;
            --secondary-color: #e67e22;
            --accent-color: #16a085;
            --text-color: #333;
            --bg-light: #f8f9fa;
            --bg-dark: #2c3e50;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            color: var(--text-color);
            background-color: #f5f5f5;
        }
        
        .navbar {
            background-color: var(--bg-dark);
            padding: 1rem 0;
        }
        
        .navbar-brand {
            font-size: 1.5rem;
            color: white !important;
        }
        
        .nav-link {
            color: rgba(255, 255, 255, 0.85) !important;
            font-weight: 500;
            transition: all 0.3s ease;
            padding: 0.5rem 1rem;
            border-radius: 4px;
            margin: 0 3px;
        }
        
        .nav-link:hover, .nav-link.active {
            color: white !important;
            background-color: rgba(255, 255, 255, 0.1);
        }
        
        .dropdown-menu {
            border: none;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        }
        
        .dropdown-item {
            font-weight: 500;
            padding: 0.5rem 1rem;
            transition: all 0.2s ease;
        }
        
        .dropdown-item:hover {
            background-color: rgba(44, 62, 80, 0.05);
        }
        
        .page-header {
            background-color: var(--primary-color);
            padding: 2rem 0;
            color: white;
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .inquiry-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            margin-bottom: 1.5rem;
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .inquiry-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .inquiry-header {
            padding: 1rem 1.5rem;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .inquiry-body {
            padding: 1.5rem;
        }
        
        .inquiry-footer {
            padding: 1rem 1.5rem;
            border-top: 1px solid #eee;
            background-color: #f9f9f9;
        }
        
        .inquiry-package-name {
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 0.25rem;
        }
        
        .inquiry-subject {
            font-size: 1.1rem;
            font-weight: 600;
        }
        
        .inquiry-date {
            color: #6c757d;
            font-size: 0.9rem;
        }
        
        .badge-status {
            font-size: 0.75rem;
            padding: 0.35rem 0.5rem;
            border-radius: 30px;
        }
        
        .status-pending {
            background-color: #ffeeba;
            color: #856404;
        }
        
        .status-answered {
            background-color: #d4edda;
            color: #155724;
        }
        
        .status-in-progress {
            background-color: #cce5ff;
            color: #004085;
        }
        
        .badge-type {
            background-color: #e9ecef;
            color: #495057;
            font-size: 0.75rem;
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
        }
        
        .inquiry-message {
            margin-top: 1rem;
            margin-bottom: 1.5rem;
            white-space: pre-line;
        }
        
        .response-box {
            background-color: #f0f9ff;
            border-left: 3px solid var(--accent-color);
            padding: 1rem;
            margin-top: 1.5rem;
        }
        
        .btn-view-package {
            color: var(--accent-color);
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-view-package:hover {
            color: #0f7460;
            text-decoration: none;
        }
        
        footer {
            background-color: var(--bg-dark);
            color: #fff;
            padding: 3rem 0 1.5rem;
            margin-top: 3rem;
        }

        footer h5 {
            color: #fff;
            font-weight: 600;
            margin-bottom: 1.5rem;
            position: relative;
            padding-bottom: 10px;
        }

        footer h5:after {
            content: '';
            position: absolute;
            left: 0;
            bottom: 0;
            width: 50px;
            height: 2px;
            background: var(--secondary-color);
        }

        .footer-link {
            color: rgba(255, 255, 255, 0.7);
            transition: color 0.3s ease;
            display: block;
            margin-bottom: 0.75rem;
            text-decoration: none;
        }

        .footer-link:hover {
            color: var(--secondary-color);
            text-decoration: none;
        }

        .social-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            height: 40px;
            width: 40px;
            background-color: rgba(255, 255, 255, 0.1);
            color: #fff;
            border-radius: 50%;
            transition: all 0.3s ease;
        }

        .social-icon:hover {
            background-color: var(--secondary-color);
            color: #fff;
            transform: translateY(-3px);
        }

        .footer-divider {
            height: 1px;
            background-color: rgba(255, 255, 255, 0.1);
            margin: 2rem 0 1.5rem;
        }

        .footer-bottom {
            text-align: center;
            color: rgba(255, 255, 255, 0.7);
        }
        
        @media (max-width: 768px) {
            .counter-box {
                margin-bottom: 1rem;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand fw-bold" href="dashboard.jsp">
                <i class="fas fa-globe-americas me-2"></i>
                TourEase
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="dashboard.jsp#packages">
                            <i class="fas fa-compass me-1"></i> Explore
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="myTrips.jsp">
                            <i class="fas fa-suitcase me-1"></i> My Trips
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="myInquiries.jsp">
                            <i class="fas fa-question-circle me-1"></i> My Inquiries
                        </a>
                    </li>
                </ul>
                <div class="d-flex align-items-center">
                <a href="profile.jsp" class="btn btn-outline-light btn-sm me-2" title="Profile">
                    <i class="fas fa-user-circle"></i>
                </a>
                <a href="logout" class="btn btn-outline-light btn-sm" title="Logout">
                    <i class="fas fa-sign-out-alt"></i>
                </a>
            </div>
        </div>
    </nav>

    <!-- Page Header -->
    <div class="page-header">
        <div class="container">
            <h1 class="mb-0">My Inquiries</h1>
        </div>
    </div>
    
    <!-- Main Content -->
    <div class="container">
        <!-- Success/Error Messages -->
        <% 
            String deleted = request.getParameter("deleted");
            if ("true".equals(deleted)) { 
        %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i> Your inquiry has been deleted successfully.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } else if ("false".equals(deleted)) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-times-circle me-2"></i> There was an error deleting your inquiry.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        
        <% 
            String edited = request.getParameter("edited");
            if ("true".equals(edited)) { 
        %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i> Your inquiry has been updated successfully.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } else if ("false".equals(edited)) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-times-circle me-2"></i> There was an error updating your inquiry.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        
        <!-- Inquiries List -->
        <div class="inquiries-section">
            <h4 class="mb-4">Your Inquiries</h4>
            
            <% if (inquiries.isEmpty()) { %>
                <div class="text-center py-5">
                    <i class="fas fa-question-circle fa-4x text-muted mb-3"></i>
                    <h5>No inquiries found</h5>
                    <p>You haven't made any inquiries yet. Browse packages and ask questions to get started.</p>
                    <a href="dashboard.jsp" class="btn btn-primary mt-3">
                        <i class="fas fa-search me-2"></i>Explore Packages
                    </a>
                </div>
            <% } else {
                for (Inquiry inquiry : inquiries) {
                    boolean hasResponse = inquiry.getResponseMessage() != null && !inquiry.getResponseMessage().trim().isEmpty();
            %>
                <div class="inquiry-card" data-aos="fade-up">
                    <div class="inquiry-header">
                        <div>
                            <div class="inquiry-package-name">
                                <i class="fas fa-map-marker-alt me-1"></i>
                                <%= inquiry.getPackageName() %>
                            </div>
                        </div>
                        <div>
                            <span class="badge <%= hasResponse ? "bg-success" : "bg-warning text-dark" %>">
                                <i class="fas <%= hasResponse ? "fa-check-circle" : "fa-clock" %> me-1"></i>
                                <%= hasResponse ? "Answered" : "Awaiting Response" %>
                            </span>
                        </div>
                    </div>
                    
                    <div class="inquiry-body">
                        <span class="badge-type mb-2">
                            <i class="fas fa-tag me-1"></i>
                            <%= inquiry.getType().substring(0, 1).toUpperCase() + inquiry.getType().substring(1) %>
                        </span>
                        
                        <h5 class="inquiry-subject mt-2"><%= inquiry.getSubject() %></h5>
                        <p class="inquiry-message"><%= inquiry.getMessage() %></p>
                        
                        <div class="text-muted small">
                            <strong>Contact method:</strong> <%= "email".equals(inquiry.getContactMethod()) ? "Email" : "Phone" %>
                        </div>
                        
                        <% if (hasResponse) { %>
                            <div class="response-box">
                                <h6 class="text-primary mb-2">
                                    <i class="fas fa-reply me-2"></i>Response from TourEase
                                </h6>
                                <p class="mb-0"><%= inquiry.getResponseMessage() %></p>
                            </div>
                        <% } %>
                    </div>
                    
                    <div class="inquiry-footer">
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="small text-muted">
                                Inquiry ID: #<%= inquiry.getId() %>
                            </div>
                            <div class="d-flex align-items-center">
                                <% if (!hasResponse) { %>
                                    <button type="button" class="btn btn-sm btn-outline-primary me-2 edit-inquiry-btn"
                                            data-id="<%= inquiry.getId() %>"
                                            data-subject="<%= inquiry.getSubject() %>"
                                            data-message="<%= inquiry.getMessage() %>"
                                            data-package-name="<%= inquiry.getPackageName() %>"
                                            data-package-id="<%= inquiry.getPackageId() %>"
                                            data-type="<%= inquiry.getType() %>"
                                            data-contact-method="<%= inquiry.getContactMethod() %>"
                                            data-bs-toggle="modal" data-bs-target="#editInquiryModal">
                                        <i class="fas fa-edit me-1"></i> Edit
                                    </button>
                                    <button type="button" class="btn btn-sm btn-outline-danger me-2 delete-inquiry-btn"
                                            data-id="<%= inquiry.getId() %>"
                                            data-subject="<%= inquiry.getSubject() %>"
                                            data-package-name="<%= inquiry.getPackageName() %>"
                                            data-bs-toggle="modal" data-bs-target="#deleteInquiryModal">
                                        <i class="fas fa-trash-alt me-1"></i> Delete
                                    </button>
                                <% } %>
                                <a href="packageDetails.jsp?id=<%= inquiry.getPackageId() %>" class="btn-view-package">
                                    <i class="fas fa-external-link-alt me-1"></i>
                                    View Package Details
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            <% } } %>
        </div>
    </div>

    <!-- Delete Inquiry Modal -->
    <div class="modal fade" id="deleteInquiryModal" tabindex="-1" aria-labelledby="deleteInquiryModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="deleteInquiryModalLabel">Delete Inquiry</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="text-center mb-4">
                        <i class="fas fa-exclamation-triangle text-warning fa-3x mb-3"></i>
                        <h5>Are you sure you want to delete this inquiry?</h5>
                        <p class="text-muted">This action cannot be undone.</p>
                    </div>
                    
                    <div class="p-3 bg-light rounded mb-3">
                        <p class="mb-1"><strong>Package:</strong> <span id="deletePackageName"></span></p>
                        <p class="mb-1"><strong>Subject:</strong> <span id="deleteSubject"></span></p>
                        <p class="mb-0"><strong>Inquiry ID:</strong> #<span id="deleteInquiryId"></span></p>
                    </div>
                </div>
                <div class="modal-footer">
                    <form action="deleteInquiry" method="post">
                        <input type="hidden" id="inquiryIdInput" name="inquiryId">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger">Delete Inquiry</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Inquiry Modal -->
    <div class="modal fade" id="editInquiryModal" tabindex="-1" aria-labelledby="editInquiryModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="editInquiryModalLabel">Edit Inquiry</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="editInquiryForm" action="editInquiry" method="post">
                        <input type="hidden" id="editInquiryId" name="inquiryId">
                        <input type="hidden" id="editPackageId" name="packageId">
                        
                        <div class="mb-3">
                            <label class="form-label">Package Name</label>
                            <input type="text" class="form-control" id="editPackageName" readonly>
                        </div>
                        
                        <div class="mb-3">
                            <label for="editSubject" class="form-label">Subject</label>
                            <input type="text" class="form-control" id="editSubject" name="subject" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="editType" class="form-label">Inquiry Type</label>
                            <select class="form-select" id="editType" name="type" required>
                                <option value="general">General Information</option>
                                <option value="booking">Booking Question</option>
                                <option value="pricing">Pricing Question</option>
                                <option value="itinerary">Itinerary Details</option>
                                <option value="accommodation">Accommodation Query</option>
                                <option value="transportation">Transportation Query</option>
                                <option value="other">Other</option>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label for="editMessage" class="form-label">Message</label>
                            <textarea class="form-control" id="editMessage" name="message" rows="5" required></textarea>
                        </div>
                        
                        <div class="mb-3">
                            <label for="editContactMethod" class="form-label">Preferred Contact Method</label>
                            <select class="form-select" id="editContactMethod" name="contactMethod" required>
                                <option value="email">Email</option>
                                <option value="phone">Phone</option>
                            </select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" form="editInquiryForm" class="btn btn-primary">Save Changes</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Enhanced Footer -->
    <footer class="py-5">
        <div class="container">
            <div class="row">
                <div class="col-lg-4 col-md-6 mb-4 mb-md-0">
                    <h5>Explore World</h5>
                    <p class="mb-4">Your gateway to extraordinary destinations and unforgettable experiences. Let us help you discover the world's hidden gems and create memories that last a lifetime.</p>
                    <div class="d-flex mb-4">
                        <a href="#" class="social-icon me-2"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" class="social-icon me-2"><i class="fab fa-twitter"></i></a>
                        <a href="#" class="social-icon me-2"><i class="fab fa-instagram"></i></a>
                        <a href="#" class="social-icon"><i class="fab fa-pinterest"></i></a>
                    </div>
                </div>
                <div class="col-lg-2 col-md-6 mb-4 mb-md-0">
                    <h5>Destinations</h5>
                    <ul class="list-unstyled">
                        <li><a href="#" class="footer-link"><i class="fas fa-angle-right me-2"></i>Asia</a></li>
                        <li><a href="#" class="footer-link"><i class="fas fa-angle-right me-2"></i>Europe</a></li>
                        <li><a href="#" class="footer-link"><i class="fas fa-angle-right me-2"></i>Americas</a></li>
                        <li><a href="#" class="footer-link"><i class="fas fa-angle-right me-2"></i>Africa</a></li>
                        <li><a href="#" class="footer-link"><i class="fas fa-angle-right me-2"></i>Oceania</a></li>
                    </ul>
                </div>
                <div class="col-lg-2 col-md-6 mb-4 mb-md-0">
                    <h5>Quick Links</h5>
                    <ul class="list-unstyled">
                        <li><a href="#" class="footer-link"><i class="fas fa-angle-right me-2"></i>About Us</a></li>
                        <li><a href="#" class="footer-link"><i class="fas fa-angle-right me-2"></i>Contact</a></li>
                        <li><a href="#" class="footer-link"><i class="fas fa-angle-right me-2"></i>Privacy Policy</a></li>
                        <li><a href="#" class="footer-link"><i class="fas fa-angle-right me-2"></i>Terms of Service</a></li>
                        <li><a href="#" class="footer-link"><i class="fas fa-angle-right me-2"></i>FAQ</a></li>
                    </ul>
                </div>
                <div class="col-lg-4 col-md-6 mb-4 mb-md-0">
                    <h5>Contact Us</h5>
                    <ul class="list-unstyled">
                        <li class="mb-3">
                            <i class="fas fa-home me-3"></i> 123 Adventure Street, Travel City, TC 10000
                        </li>
                        <li class="mb-3">
                            <i class="fas fa-envelope me-3"></i> info@exploreworld.com
                        </li>
                        <li class="mb-3">
                            <i class="fas fa-phone me-3"></i> +1 (234) 567-8900
                        </li>
                        <li class="mb-3">
                            <i class="fas fa-clock me-3"></i> Monday - Friday: 9:00 AM - 5:00 PM
                        </li>
                    </ul>
                </div>
            </div>
            <div class="footer-divider"></div>
            <div class="footer-bottom">
                <p class="mb-0">&copy; 2025 Explore World. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <!-- AOS Animation Library -->
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script>
        // Initialize AOS animation
        AOS.init({
            duration: 800,
            easing: 'ease',
            once: true
        });
        
        // Populate delete modal when opened
        document.addEventListener('DOMContentLoaded', function() {
            const deleteInquiryButtons = document.querySelectorAll('.delete-inquiry-btn');
            deleteInquiryButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const inquiryId = this.getAttribute('data-id');
                    const subject = this.getAttribute('data-subject');
                    const packageName = this.getAttribute('data-package-name');
                    
                    // Set values in the modal
                    document.getElementById('deleteInquiryId').textContent = inquiryId;
                    document.getElementById('deleteSubject').textContent = subject;
                    document.getElementById('deletePackageName').textContent = packageName;
                    document.getElementById('inquiryIdInput').value = inquiryId;
                });
            });
            
            // Populate edit modal when opened
            const editInquiryButtons = document.querySelectorAll('.edit-inquiry-btn');
            editInquiryButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const inquiryId = this.getAttribute('data-id');
                    const subject = this.getAttribute('data-subject');
                    const message = this.getAttribute('data-message');
                    const packageName = this.getAttribute('data-package-name');
                    const packageId = this.getAttribute('data-package-id');
                    const type = this.getAttribute('data-type');
                    const contactMethod = this.getAttribute('data-contact-method');
                    
                    // Set values in the edit modal
                    document.getElementById('editInquiryId').value = inquiryId;
                    document.getElementById('editSubject').value = subject;
                    document.getElementById('editMessage').value = message;
                    document.getElementById('editPackageName').value = packageName;
                    document.getElementById('editPackageId').value = packageId;
                    document.getElementById('editType').value = type;
                    document.getElementById('editContactMethod').value = contactMethod;
                });
            });
        });
    </script>
</body>
</html>
