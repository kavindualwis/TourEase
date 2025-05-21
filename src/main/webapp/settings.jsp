<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="tourism.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Settings - TourEase</title>
    
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
        .settings-container {
            max-width: 900px;
            margin: 30px auto;
            padding: 20px;
        }
        
        .card {
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .settings-header {
            background-color: var(--primary-color);
            color: white;
            padding: 20px;
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
        }
        
        .settings-header h1 {
            font-size: 24px;
            margin-bottom: 10px;
        }
        
        .settings-content {
            padding: 30px;
        }
        
        .nav-tabs {
            border-bottom: 2px solid #f0f0f0;
        }
        
        .nav-tabs .nav-link {
            border: none;
            color: #555;
            font-weight: 500;
            padding: 10px 20px;
            border-radius: 0;
        }
        
        .nav-tabs .nav-link.active {
            border-bottom: 3px solid var(--primary-color);
            color: var(--primary-color);
            font-weight: 600;
            background-color: transparent;
        }
        
        .tab-content {
            padding: 30px 0;
        }
        
        .form-label {
            font-weight: 500;
        }
        
        .form-switch .form-check-input {
            width: 3em;
            height: 1.5em;
        }
        
        .form-switch .form-check-input:checked {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
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
        
        // Check for success message from session
        String successMessage = (String) session.getAttribute("settingsSuccessMessage");
        String errorMessage = (String) session.getAttribute("settingsErrorMessage");
        if (successMessage != null) {
            session.removeAttribute("settingsSuccessMessage");
        }
        if (errorMessage != null) {
            session.removeAttribute("settingsErrorMessage");
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
                </ul>
                <div class="d-flex align-items-center">
                    <span class="text-light me-3">Welcome, <%= user.getFullName() %></span>
                    <a href="profile.jsp" class="btn btn-outline-light btn-sm me-2" title="Profile">
                        <i class="fas fa-user-circle"></i>
                    </a>
                    <a href="settings.jsp" class="btn btn-outline-light btn-sm me-2" title="Settings">
                        <i class="fas fa-cog"></i>
                    </a>
                    <a href="logout" class="btn btn-outline-light btn-sm" title="Logout">
                        <i class="fas fa-sign-out-alt"></i>
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Container -->
    <div class="settings-container">
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
            
            <div class="settings-header">
                <h1><i class="fas fa-cog me-2"></i> Settings</h1>
                <p class="mb-0">Manage your account preferences and settings</p>
            </div>
            
            <div class="settings-content">
                <ul class="nav nav-tabs" id="settingsTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="notifications-tab" data-bs-toggle="tab" data-bs-target="#notifications" type="button" role="tab" aria-controls="notifications" aria-selected="true">Notifications</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="privacy-tab" data-bs-toggle="tab" data-bs-target="#privacy" type="button" role="tab" aria-controls="privacy" aria-selected="false">Privacy</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="preferences-tab" data-bs-toggle="tab" data-bs-target="#preferences" type="button" role="tab" aria-controls="preferences" aria-selected="false">Preferences</button>
                    </li>
                </ul>
                
                <div class="tab-content" id="settingsTabContent">
                    <!-- Notifications Tab -->
                    <div class="tab-pane fade show active" id="notifications" role="tabpanel" aria-labelledby="notifications-tab">
                        <form>
                            <div class="mb-4">
                                <h5>Email Notifications</h5>
                                <div class="form-check form-switch mb-3">
                                    <input class="form-check-input" type="checkbox" id="bookingConfirmation" checked>
                                    <label class="form-check-label" for="bookingConfirmation">
                                        Booking confirmations
                                    </label>
                                </div>
                                <div class="form-check form-switch mb-3">
                                    <input class="form-check-input" type="checkbox" id="specialOffers" checked>
                                    <label class="form-check-label" for="specialOffers">
                                        Special offers and promotions
                                    </label>
                                </div>
                                <div class="form-check form-switch mb-3">
                                    <input class="form-check-input" type="checkbox" id="travelUpdates">
                                    <label class="form-check-label" for="travelUpdates">
                                        Travel updates and tips
                                    </label>
                                </div>
                                <div class="form-check form-switch mb-3">
                                    <input class="form-check-input" type="checkbox" id="accountActivity" checked>
                                    <label class="form-check-label" for="accountActivity">
                                        Account activity alerts
                                    </label>
                                </div>
                            </div>
                            
                            <div class="mb-4">
                                <h5>Mobile Notifications</h5>
                                <div class="form-check form-switch mb-3">
                                    <input class="form-check-input" type="checkbox" id="mobileBookingConfirmation" checked>
                                    <label class="form-check-label" for="mobileBookingConfirmation">
                                        Booking confirmations
                                    </label>
                                </div>
                                <div class="form-check form-switch mb-3">
                                    <input class="form-check-input" type="checkbox" id="mobileSpecialOffers">
                                    <label class="form-check-label" for="mobileSpecialOffers">
                                        Special offers and promotions
                                    </label>
                                </div>
                            </div>
                            
                            <button type="submit" class="btn btn-primary">Save Changes</button>
                        </form>
                    </div>
                    
                    <!-- Privacy Tab -->
                    <div class="tab-pane fade" id="privacy" role="tabpanel" aria-labelledby="privacy-tab">
                        <form>
                            <div class="mb-4">
                                <h5>Privacy Settings</h5>
                                <div class="form-check form-switch mb-3">
                                    <input class="form-check-input" type="checkbox" id="showProfile" checked>
                                    <label class="form-check-label" for="showProfile">
                                        Allow others to see my profile
                                    </label>
                                </div>
                                <div class="form-check form-switch mb-3">
                                    <input class="form-check-input" type="checkbox" id="shareActivity" checked>
                                    <label class="form-check-label" for="shareActivity">
                                        Share my activity with others
                                    </label>
                                </div>
                                <div class="form-check form-switch mb-3">
                                    <input class="form-check-input" type="checkbox" id="analyticsConsent" checked>
                                    <label class="form-check-label" for="analyticsConsent">
                                        Allow analytics cookies
                                    </label>
                                </div>
                            </div>
                            
                            <div class="mb-4">
                                <h5>Data Management</h5>
                                <p class="text-muted mb-3">Manage how your data is stored and used by TourEase</p>
                                <a href="#" class="btn btn-outline-secondary btn-sm me-2">Download my data</a>
                                <a href="#" class="btn btn-outline-danger btn-sm">Delete my account</a>
                            </div>
                            
                            <button type="submit" class="btn btn-primary">Save Changes</button>
                        </form>
                    </div>
                    
                    <!-- Preferences Tab -->
                    <div class="tab-pane fade" id="preferences" role="tabpanel" aria-labelledby="preferences-tab">
                        <form>
                            <div class="mb-4">
                                <h5>Travel Preferences</h5>
                                <div class="mb-3">
                                    <label for="preferredCurrency" class="form-label">Preferred Currency</label>
                                    <select class="form-select" id="preferredCurrency">
                                        <option value="USD" selected>USD - US Dollar</option>
                                        <option value="EUR">EUR - Euro</option>
                                        <option value="GBP">GBP - British Pound</option>
                                        <option value="JPY">JPY - Japanese Yen</option>
                                        <option value="AUD">AUD - Australian Dollar</option>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label for="preferredLanguage" class="form-label">Preferred Language</label>
                                    <select class="form-select" id="preferredLanguage">
                                        <option value="en" selected>English</option>
                                        <option value="fr">Français</option>
                                        <option value="es">Español</option>
                                        <option value="de">Deutsch</option>
                                        <option value="ja">日本語</option>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label for="travelInterests" class="form-label">Travel Interests</label>
                                    <select class="form-select" id="travelInterests" multiple>
                                        <option value="beach" selected>Beaches</option>
                                        <option value="mountain" selected>Mountains</option>
                                        <option value="city">City Breaks</option>
                                        <option value="adventure">Adventure</option>
                                        <option value="cultural">Cultural</option>
                                        <option value="food">Food & Cuisine</option>
                                    </select>
                                    <div class="form-text">Hold Ctrl/Cmd to select multiple options</div>
                                </div>
                            </div>
                            
                            <button type="submit" class="btn btn-primary">Save Changes</button>
                        </form>
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
        
        // Form submission handler (demo only)
        document.querySelectorAll('form').forEach(form => {
            form.addEventListener('submit', function(e) {
                e.preventDefault();
                // Show a success message (in a real app, you would save the settings)
                alert('Settings saved successfully!');
            });
        });
    </script>
</body>
</html>
