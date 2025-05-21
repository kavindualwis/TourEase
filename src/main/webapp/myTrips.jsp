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
    <title>My Trips - TourEase</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- AOS Animation library -->
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="css/myTrips.css">
</head>
<body>
    <%
        // Check if user is logged in
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        
        // Create an instance of BookingFileHandler
        BookingFileHandler bookingHandler = new BookingFileHandler();
        
        // Get user's bookings using the instance method
        List<Booking> userBookings = bookingHandler.getBookingsByUsername(user.getUsername());
        
        // Sort bookings by booking date (most recent first)
        Collections.sort(userBookings, new Comparator<Booking>() {
            @Override
            public int compare(Booking b1, Booking b2) {
                // Parse dates and compare
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
        
        // Check for success message
        Boolean orderSuccess = (Boolean) session.getAttribute("orderSuccess");
        String orderId = (String) session.getAttribute("orderId");
        
        // Clear session attributes after reading
        session.removeAttribute("orderSuccess");
        session.removeAttribute("orderId");
    %>

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
                        <a class="nav-link active" href="myTrips.jsp">
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
                    <span class="text-light me-3">Welcome, <%= user.getFullName() %></span>
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
        <% if (orderSuccess != null && orderSuccess) { %>
        <div class="alert success-alert alert-dismissible fade show mt-4" role="alert" data-aos="fade-down">
            <i class="fas fa-check-circle me-2"></i>
            <strong>Success!</strong> Your booking request has been submitted with Order ID: <%= orderId %>
            <p class="mb-0 mt-1 small">Your booking is <strong>pending admin approval</strong>. Please check back later for updates.</p>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <% } %>
        
        <!-- Page Header -->
        <div class="page-header" data-aos="fade-up">
            <h1>My Trips</h1>
            <p>View and manage all your booked travel experiences</p>
        </div>

        <% if (userBookings.isEmpty()) { %>
        <!-- Empty state when no bookings -->
        <div class="card animate-fade-up" data-aos="fade-up">
            <div class="empty-trips">
                <i class="fas fa-suitcase"></i>
                <h3>No trips booked yet!</h3>
                <p>Explore our amazing packages and book your next adventure.</p>
                <div class="text-center mt-3">
                    <a href="dashboard.jsp" class="btn btn-primary btn-sm">
                        Explore Packages
                    </a>
                </div>
            </div>
        </div>
        <% } else { %>
        <!-- Trips Grid -->
        <div class="row" id="tripsContainer">
            <% for (Booking booking : userBookings) { %>
            <div class="col-lg-4 col-md-6 trip-item" 
                 data-status="<%= booking.getStatus() %>" 
                 data-destination="<%= booking.getDestination() %>"
                 data-price="<%= booking.getAmount().replace("$", "").replace(",", "") %>"
                 data-departure="<%= booking.getDepartureDate() %>"
                 data-aos="fade-up">
                <div class="card trip-card">
                    <div class="position-relative">
                        <img src="<%= booking.getPackageImage() %>" class="card-img-top trip-image" alt="<%= booking.getPackageName() %>">
                        <div class="trip-date">
                            <i class="far fa-calendar-alt me-1"></i> <%= booking.getDepartureDate() %>
                        </div>
                        <div class="trip-status status-<%= booking.getStatus().toLowerCase() %>">
                            <%= booking.getStatus() %>
                        </div>
                    </div>
                    <div class="trip-body">
                        <h5 class="trip-title"><%= booking.getPackageName() %></h5>
                        <div class="trip-detail">
                            <i class="fas fa-map-marker-alt"></i>
                            <div><%= booking.getDestination() %></div>
                        </div>
                        <div class="trip-detail">
                            <i class="fas fa-clock"></i>
                            <div><%= booking.getDuration() %> days</div>
                        </div>
                        <div class="trip-detail">
                            <i class="fas fa-users"></i>
                            <div><%= booking.getParticipants() %> participants</div>
                        </div>
                    </div>
                    <div class="trip-footer">
                        <div class="trip-price">
                            $<%= booking.getAmount() %>
                        </div>
                        <button class="btn-view-details" data-bs-toggle="modal" data-bs-target="#tripModal<%= booking.getOrderId().replaceAll("[^a-zA-Z0-9]", "") %>">
                            View Details
                        </button>
                    </div>
                </div>
            </div>
            
            <!-- Trip Details Modal -->
            <div class="modal fade" id="tripModal<%= booking.getOrderId().replaceAll("[^a-zA-Z0-9]", "") %>" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-lg modal-dialog-centered">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title"><%= booking.getPackageName() %></h5>
                            <div class="modal-order-id ms-3">Order ID: <%= booking.getOrderId() %></div>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <img src="<%= booking.getPackageImage() %>" class="modal-image" alt="<%= booking.getPackageName() %>">
                            
                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <div class="modal-detail">
                                        <i class="fas fa-clock"></i>
                                        <div class="modal-detail-content">
                                            <div class="modal-detail-label">Booking Date</div>
                                            <div class="modal-detail-value"><%= booking.getBookingDate().split(" ")[0] %></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="modal-detail">
                                        <i class="fas fa-tag"></i>
                                        <div class="modal-detail-content">
                                            <div class="modal-detail-label">Status</div>
                                            <div class="modal-detail-value">
                                                <span class="badge bg-<%= 
                                                    booking.getStatus().equals("Completed") ? "success" : 
                                                    booking.getStatus().equals("Pending") ? "warning" : 
                                                    booking.getStatus().equals("Cancelled") ? "danger" : "info" 
                                                %>"><%= booking.getStatus() %></span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <div class="modal-detail">
                                        <i class="fas fa-map-marker-alt"></i>
                                        <div class="modal-detail-content">
                                            <div class="modal-detail-label">Destination</div>
                                            <div class="modal-detail-value"><%= booking.getDestination() %></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="modal-detail">
                                        <i class="fas fa-calendar-alt"></i>
                                        <div class="modal-detail-content">
                                            <div class="modal-detail-label">Departure Date</div>
                                            <div class="modal-detail-value"><%= booking.getDepartureDate() %></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <div class="modal-detail">
                                        <i class="fas fa-clock"></i>
                                        <div class="modal-detail-content">
                                            <div class="modal-detail-label">Duration</div>
                                            <div class="modal-detail-value"><%= booking.getDuration() %> days</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="modal-detail">
                                        <i class="fas fa-users"></i>
                                        <div class="modal-detail-content">
                                            <div class="modal-detail-label">Participants</div>
                                            <div class="modal-detail-value"><%= booking.getParticipants() %></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <div class="modal-detail">
                                        <i class="fas fa-suitcase"></i>
                                        <div class="modal-detail-content">
                                            <div class="modal-detail-label">Booking Type</div>
                                            <div class="modal-detail-value">
                                                <%= booking.getBookingType().equals("standard") ? "Standard Package" : "Custom Package" %>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="modal-detail">
                                        <i class="fas fa-money-bill-wave"></i>
                                        <div class="modal-detail-content">
                                            <div class="modal-detail-label">Total Price</div>
                                            <div class="modal-detail-value fw-bold">$<%= booking.getAmount() %></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <% if (booking.getStatus().equals("Completed")) { %>
                            <div class="d-flex justify-content-between mt-4">
                                <button class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
                                <button class="btn btn-primary">
                                    <i class="fas fa-download me-2"></i> Download Itinerary
                                </button>
                            </div>
                            <% } else if (booking.getStatus().equals("Pending")) { %>
                            <div class="d-flex justify-content-between mt-4">
                                <button class="btn btn-outline-danger cancel-booking" data-order-id="<%= booking.getOrderId() %>">
                                    <i class="fas fa-times-circle me-2"></i> Cancel Booking
                                </button>
                                <div>
                                    <span class="badge bg-warning me-2">Pending Admin Approval</span>
                                    <button class="btn btn-primary" data-bs-dismiss="modal">Close</button>
                                </div>
                            </div>
                            <% } else { %>
                            <div class="d-flex justify-content-end mt-4">
                                <button class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        <% } %>
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
        
        document.addEventListener('DOMContentLoaded', function() {
            // Cancel booking functionality (would need a server endpoint to handle this)
            const cancelButtons = document.querySelectorAll('.cancel-booking');
            cancelButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const orderId = this.dataset.orderId;
                    if (confirm('Are you sure you want to cancel this booking?')) {
                        // Here you would send a request to the server to cancel the booking
                        alert('This functionality would be implemented with a server call to cancel booking ' + orderId);
                    }
                });
            });
        });
    </script>
</body>
</html>
``` 