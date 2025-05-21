<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="tourism.model.User" %>
<%@ page import="tourism.model.Booking" %>
<%@ page import="tourism.util.BookingFileHandler" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - TourEase</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- AOS Animation library -->
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="css/dashboard.css">
    <link rel="stylesheet" href="css/userPages.css">
    <style>
        .profile-edit-form {
            display: none;
        }
        .form-buttons {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 15px;
        }
        .alert {
            margin-top: 15px;
        }
        .profile-container {
            max-width: 900px;
            margin: 40px auto;
        }
        .profile-header {
            text-align: center;
            padding: 35px 20px;
            background: linear-gradient(135deg, #077f43 0%, #0a9654 100%);
            border-radius: 10px 10px 0 0;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .booking-stats {
            display: flex;
            justify-content: center;
            margin: 25px auto 10px;
            gap: 30px;
        }
        .stat-item {
            text-align: center;
            background: rgba(255,255,255,0.15);
            padding: 12px 15px;
            border-radius: 12px;
            min-width: 110px;
            backdrop-filter: blur(5px);
            transition: transform 0.2s;
        }
        .stat-item:hover {
            transform: translateY(-3px);
            background: rgba(255,255,255,0.2);
        }
        .stat-value {
            font-size: 26px;
            font-weight: 600;
            color: #ffffff;
            margin-bottom: 5px;
        }
        .stat-label {
            font-size: 14px;
            color: rgba(255,255,255,0.85);
        }
        .profile-name {
            margin-top: 20px;
            color: white;
            font-size: 32px;
            font-weight: 600;
            letter-spacing: 0.5px;
            text-shadow: 0 2px 4px rgba(0,0,0,0.15);
        }
        .profile-username {
            color: rgba(255,255,255,0.85);
            margin: 8px 0 15px;
            font-size: 18px;
            font-weight: 400;
        }
        .profile-role {
            display: inline-block;
            background: rgba(255,255,255,0.25);
            padding: 6px 18px;
            border-radius: 25px;
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 15px;
            color: #fff;
            text-transform: uppercase;
            letter-spacing: 1px;
            box-shadow: 0 3px 8px rgba(0,0,0,0.08);
        }
        .profile-content {
            background: #ffffff;
            padding: 30px;
            border-radius: 0 0 10px 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }
        .profile-section {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }
        .profile-section:last-child {
            margin-bottom: 0;
            padding-bottom: 0;
            border-bottom: none;
        }
        .profile-section h3 {
            font-size: 20px;
            color: #333;
            font-weight: 600;
            margin-bottom: 20px;
        }
        .edit-button {
            background-color: transparent;
            border: 1px solid #0a9654;
            color: #0a9654;
            border-radius: 6px;
            padding: 6px 15px;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.2s ease;
        }
        .edit-button:hover {
            background-color: #0a9654;
            color: white;
        }
        .card {
            border: none;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            border-radius: 8px;
        }
        .profile-info-item {
            display: flex;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #f0f0f0;
        }
        .profile-info-item:last-child {
            margin-bottom: 0;
            padding-bottom: 0;
            border-bottom: none;
        }
        .info-label {
            width: 120px;
            color: #666;
            font-weight: 500;
        }
        .info-value {
            flex: 1;
            color: #333;
            font-weight: 400;
        }
    </style>
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
        
        // Get user's bookings for stats using the instance method
        List<Booking> userBookings = bookingHandler.getBookingsByUsername(user.getUsername());
        int completedTrips = 0;
        int upcomingTrips = 0;
        
        for (Booking booking : userBookings) {
            if (booking.getStatus().equals("Completed")) {
                completedTrips++;
            } else if (booking.getStatus().equals("Pending")) {
                upcomingTrips++;
            }
        }
        
        // Check for success message from session
        String successMessage = (String) session.getAttribute("successMessage");
        String errorMessage = (String) session.getAttribute("errorMessage");
        if (successMessage != null) {
            session.removeAttribute("successMessage");
        }
        if (errorMessage != null) {
            session.removeAttribute("errorMessage");
        }
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
    <div class="profile-container">
        <div class="card" data-aos="fade-up">
            <% if (successMessage != null) { %>
                <div class="alert alert-success alert-dismissible fade show mx-3 mt-3" role="alert">
                    <%= successMessage %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>
            
            <% if (errorMessage != null) { %>
                <div class="alert alert-danger alert-dismissible fade show mx-3 mt-3" role="alert">
                    <%= errorMessage %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>
            
            <div class="profile-header">
                <div class="profile-role">Tourist</div>
                <h2 class="profile-name"><%= user.getFullName() %></h2>
                <div class="profile-username">@<%= user.getUsername() %></div>
                
                <div class="booking-stats">
                    <div class="stat-item">
                        <div class="stat-value"><%= userBookings.size() %></div>
                        <div class="stat-label">Total Bookings</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value"><%= completedTrips %></div>
                        <div class="stat-label">Completed</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value"><%= upcomingTrips %></div>
                        <div class="stat-label">Upcoming</div>
                    </div>
                </div>
            </div>

            <div class="profile-content">
                <div class="profile-section">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h3><i class="fas fa-user-circle me-2"></i> Personal Information</h3>
                        <button class="edit-button" onclick="toggleEditForm('personal-info')"><i class="fas fa-pencil-alt me-2"></i> Edit</button>
                    </div>
                    
                    <!-- Display View -->
                    <div class="card" id="personal-info-display">
                        <div class="card-body">
                            <div class="profile-info-item">
                                <div class="info-label">Full Name:</div>
                                <div class="info-value"><%= user.getFullName() %></div>
                            </div>
                            <div class="profile-info-item">
                                <div class="info-label">Email:</div>
                                <div class="info-value"><%= user.getEmail() %></div>
                            </div>
                            <div class="profile-info-item">
                                <div class="info-label">Username:</div>
                                <div class="info-value"><%= user.getUsername() %></div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Edit Form -->
                    <div class="card profile-edit-form" id="personal-info-edit">
                        <div class="card-body">
                            <form action="updateProfile" method="post">
                                <input type="hidden" name="action" value="updateInfo">
                                
                                <div class="mb-3">
                                    <label for="fullName" class="form-label">Full Name</label>
                                    <input type="text" class="form-control" id="fullName" name="fullName" value="<%= user.getFullName() %>" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="email" name="email" value="<%= user.getEmail() %>" required>
                                </div>
                                
                                <div class="form-buttons">
                                    <button type="button" class="btn btn-secondary" onclick="toggleEditForm('personal-info')">Cancel</button>
                                    <button type="submit" class="btn btn-success">Save Changes</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="profile-section">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h3><i class="fas fa-lock me-2"></i> Password Management</h3>
                        <button class="edit-button" onclick="toggleEditForm('password')"><i class="fas fa-key me-2"></i> Change Password</button>
                    </div>
                    
                    <!-- Password Edit Form -->
                    <div class="card profile-edit-form" id="password-edit">
                        <div class="card-body">
                            <form action="updateProfile" method="post">
                                <input type="hidden" name="action" value="updatePassword">
                                
                                <div class="mb-3">
                                    <label for="currentPassword" class="form-label">Current Password</label>
                                    <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="newPassword" class="form-label">New Password</label>
                                    <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="confirmPassword" class="form-label">Confirm New Password</label>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                </div>
                                
                                <div class="form-buttons">
                                    <button type="button" class="btn btn-secondary" onclick="toggleEditForm('password')">Cancel</button>
                                    <button type="submit" class="btn btn-success">Update Password</button>
                                </div>
                            </form>
                        </div>
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
        
        // Toggle edit forms
        function toggleEditForm(section) {
            if (section === 'personal-info') {
                const displayEl = document.getElementById('personal-info-display');
                const editEl = document.getElementById('personal-info-edit');
                
                if (displayEl.style.display === 'none') {
                    displayEl.style.display = 'block';
                    editEl.style.display = 'none';
                } else {
                    displayEl.style.display = 'none';
                    editEl.style.display = 'block';
                }
            } else if (section === 'password') {
                const editEl = document.getElementById('password-edit');
                
                if (editEl.style.display === 'block') {
                    editEl.style.display = 'none';
                } else {
                    editEl.style.display = 'block';
                }
            }
        }
    </script>
</body>
</html>
