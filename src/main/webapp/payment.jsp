<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="tourism.model.User" %>
<%@ page import="tourism.model.Package" %>
<%@ page import="tourism.util.PackageFileHandler" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Random" %>
<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login");
        return;
    }
    
    // Create an instance of PackageFileHandler
    PackageFileHandler packageHandler = new PackageFileHandler();
    
    // Get package information from request parameters
    String packageId = request.getParameter("packageId");
    String packageName = request.getParameter("packageName");
    String packagePrice = request.getParameter("packagePrice");
    String packageDuration = request.getParameter("packageDuration");
    String packageDestination = request.getParameter("packageDestination");
    String packageDepartureDate = request.getParameter("packageDepartureDate");
    String bookingType = request.getParameter("bookingType");
    String participants = request.getParameter("participants");
    
    // If any essential parameter is missing, redirect back
    if (packageId == null || packageName == null || packagePrice == null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
    
    // Default values for participants if not provided (for standard booking)
    if (participants == null || participants.trim().isEmpty()) {
        participants = "1";
    }
    
    // Get the package object to access more details if needed using instance method
    Package pkg = packageHandler.getPackageById(packageId);
    if (pkg == null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
    
    // Get the first package image
    String packageImage = "https://via.placeholder.com/400x300?text=No+Image";
    if (pkg.getPackageImages() != null && !pkg.getPackageImages().isEmpty()) {
        String imgString = pkg.getPackageImages().get(0);
        if (imgString.contains(",")) {
            packageImage = imgString.split(",")[0].trim();
        } else {
            packageImage = imgString.trim();
        }
    }
    
    // Generate a reservation ID
    Random random = new Random();
    String reservationId = "RES" + (10000 + random.nextInt(90000));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complete Your Booking - <%= packageName %></title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- AOS Animation library -->
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/payment.css">
</head>
<body>
    <!-- Navigation Bar - Updated to match dashboard.jsp -->
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
                        <a class="nav-link" href="myInquiries.jsp">
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
        </div>
    </nav>

    <!-- Main Container -->
    <div class="container main-container">
        <a href="packageDetails.jsp?id=<%= packageId %>" class="btn-back">
            <i class="fas fa-arrow-left"></i> Back to Package Details
        </a>
        
        <div class="page-header" data-aos="fade-up">
            <h1>Complete Your Booking</h1>
            <p>You're just one step away from your amazing journey!</p>
        </div>

        <div class="row">
            <!-- Order Summary Column -->
            <div class="col-lg-4" data-aos="fade-up">
                <div class="card card-glass">
                    <div class="order-summary">
                        <div class="summary-header">
                            <div class="summary-header-icon">
                                <i class="fas fa-suitcase"></i>
                            </div>
                            <h5 class="summary-title">Order Summary</h5>
                        </div>
                        
                        <div class="reservation-id">
                            <i class="fas fa-tag"></i> Reservation: <%= reservationId %>
                        </div>

                        <div class="package-image-wrapper">
                            <img src="<%= packageImage %>" alt="<%= packageName %>" class="package-image">
                            <div class="package-info-badge">
                                <%= bookingType.equals("standard") ? "Standard Package" : "Custom Package" %>
                            </div>
                        </div>

                        <div class="summary-detail">
                            <div class="summary-label">Package</div>
                            <div class="summary-value"><%= packageName %></div>
                        </div>

                        <div class="summary-detail">
                            <div class="summary-label">Destination</div>
                            <div class="summary-value"><%= packageDestination %></div>
                        </div>

                        <div class="summary-detail">
                            <div class="summary-label">Departure Date</div>
                            <div class="summary-value"><%= packageDepartureDate %></div>
                        </div>

                        <div class="summary-detail">
                            <div class="summary-label">Duration</div>
                            <div class="summary-value"><%= bookingType.equals("standard") ? packageDuration + " days" : packageDuration + " nights" %></div>
                        </div>

                        <% if (bookingType.equals("custom")) { %>
                        <div class="summary-detail">
                            <div class="summary-label">Participants</div>
                            <div class="summary-value"><%= participants %></div>
                        </div>
                        <% } %>

                        <div class="total-price">
                            <div class="total-price-label">Total Price</div>
                            <div class="total-price-value">$<%= packagePrice %></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Payment Form Column -->
            <div class="col-lg-8" data-aos="fade-up" data-aos-delay="100">
                <div class="card">
                    <div class="payment-card">
                        <h5 class="payment-title">
                            <i class="fas fa-credit-card"></i> Payment Details
                        </h5>

                        <div class="payment-methods mb-4">
                            <i class="fab fa-cc-visa card-icon visa"></i>
                            <i class="fab fa-cc-mastercard card-icon mastercard"></i>
                            <i class="fab fa-cc-amex card-icon amex"></i>
                            <i class="fab fa-cc-discover card-icon discover"></i>
                        </div>

                        <!-- Payment Form -->
                        <form id="paymentForm">
                            <div class="row mb-3">
                                <div class="col-md-12">
                                    <label for="cardholderName" class="form-label">Cardholder Name</label>
                                    <input type="text" class="form-control" id="cardholderName" placeholder="Name as it appears on your card" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="cardNumber" class="form-label">Card Number</label>
                                <div class="input-group">
                                    <input type="text" class="form-control" id="cardNumber" placeholder="1234 5678 9012 3456" maxlength="19" required>
                                    <span class="input-group-text">
                                        <i class="far fa-credit-card"></i>
                                    </span>
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="expirationDate" class="form-label">Expiration Date</label>
                                    <input type="text" class="form-control" id="expirationDate" placeholder="MM/YY" maxlength="5" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="cvv" class="form-label">Security Code (CVV)</label>
                                    <div class="input-group">
                                        <input type="text" class="form-control" id="cvv" placeholder="123" maxlength="4" required>
                                        <span class="input-group-text" data-bs-toggle="tooltip" data-bs-placement="top" title="3 or 4 digits usually found on the back of your card">
                                            <i class="fas fa-question-circle"></i>
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-12">
                                    <label for="billingAddress" class="form-label">Billing Address</label>
                                    <input type="text" class="form-control" id="billingAddress" placeholder="Street Address" required>
                                </div>
                            </div>

                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <label for="city" class="form-label">City</label>
                                    <input type="text" class="form-control" id="city" placeholder="City" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="zipCode" class="form-label">ZIP/Postal Code</label>
                                    <input type="text" class="form-control" id="zipCode" placeholder="ZIP/Postal Code" required>
                                </div>
                            </div>

                            <div class="form-check mb-3">
                                <input class="form-check-input" type="checkbox" id="savePaymentInfo">
                                <label class="form-check-label" for="savePaymentInfo">
                                    Save my payment information for future bookings
                                </label>
                            </div>

                            <button type="submit" class="btn-payment">
                                <i class="fas fa-lock me-2"></i> Pay Securely $<%= packagePrice %>
                            </button>

                            <div class="security-note">
                                <i class="fas fa-shield-alt"></i>
                                <p class="security-text">Your payment information is encrypted and secure. We never store your CVV code.</p>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Payment Success Modal -->
    <div class="modal fade modal-success" id="paymentSuccessModal" tabindex="-1" aria-labelledby="paymentSuccessModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="paymentSuccessModalLabel">Booking Request Submitted!</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="success-animation">
                        <i class="fas fa-check"></i>
                    </div>
                    <div class="success-message">
                        <h4>Payment Successful!</h4>
                        <p>Your booking request for <strong><%= packageName %></strong> has been submitted.</p>
                        <p>The booking is <span class="badge bg-warning">Pending</span> admin approval. You'll receive a confirmation email once approved.</p>
                        <p>Reservation ID: <strong><%= reservationId %></strong></p>
                        <button class="btn-continue" onclick="window.location.href='myTrips.jsp'">
                            View My Trips
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

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
        
        // Initialize tooltips
        const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
        const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl));
        
        // Form handling
        document.addEventListener('DOMContentLoaded', function() {
            const cardNumberInput = document.getElementById('cardNumber');
            const expirationDateInput = document.getElementById('expirationDate');
            const cvvInput = document.getElementById('cvv');
            
            // Format card number as user types (add spaces)
            cardNumberInput.addEventListener('input', function() {
                let value = this.value.replace(/\D/g, '');
                value = value.replace(/(\d{4})(?=\d)/g, '$1 ');
                this.value = value;
            });
            
            // Format expiration date as MM/YY
            expirationDateInput.addEventListener('input', function() {
                let value = this.value.replace(/\D/g, '');
                
                if (value.length > 2) {
                    value = value.substring(0, 2) + '/' + value.substring(2, 4);
                }
                
                this.value = value;
            });
            
            // Only allow numbers for CVV
            cvvInput.addEventListener('input', function() {
                this.value = this.value.replace(/\D/g, '');
            });
            
            // Form submission
            document.getElementById('paymentForm').addEventListener('submit', function(e) {
                e.preventDefault();
                
                // Validate form fields
                const form = this;
                if (!form.checkValidity()) {
                    e.stopPropagation();
                    form.classList.add('was-validated');
                    return;
                }
                
                // Show loading state on button
                const submitBtn = this.querySelector('button[type="submit"]');
                const originalBtnText = submitBtn.innerHTML;
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span> Processing...';
                
                // Get the current context path
                const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1));
                
                // Instead of using hidden form, create a direct form submission to the servlet
                const orderForm = document.createElement('form');
                orderForm.method = 'POST';
                orderForm.action = contextPath + '/createOrder'; // Use the context path
                orderForm.style.display = 'none';
                
                // Add order information as hidden fields
                const formFields = {
                    'orderId': '<%= reservationId %>',
                    'packageId': '<%= packageId %>',
                    'packageName': '<%= packageName %>',
                    'amount': '<%= packagePrice %>',
                    'duration': '<%= packageDuration %>',
                    'destination': '<%= packageDestination %>',
                    'departureDate': '<%= packageDepartureDate %>',
                    'bookingType': '<%= bookingType %>',
                    'participants': '<%= participants %>',
                    'packageImage': '<%= packageImage %>'
                };
                
                // Create and append hidden fields to form
                for (const [key, value] of Object.entries(formFields)) {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = key;
                    input.value = value;
                    orderForm.appendChild(input);
                }
                
                // Append the form to the document body
                document.body.appendChild(orderForm);
                
                // Simulate payment processing
                setTimeout(function() {
                    // Show success modal first
                    const successModal = new bootstrap.Modal(document.getElementById('paymentSuccessModal'));
                    successModal.show();
                    
                    console.log('Submitting form to: ' + orderForm.action);
                    
                    // After showing the success modal, submit the form
                    setTimeout(function() {
                        orderForm.submit();
                    }, 3000); // Give user 3 seconds to see success message
                }, 2000); // Simulate 2 second payment processing
            });
        });
    </script>
</body>
</html>
