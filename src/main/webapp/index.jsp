<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TourEase - Your Travel Companion</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- AOS Animation library -->
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">
</head>
<body>
<!-- Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container">
        <a class="navbar-brand" href="#">
            <i class="fas fa-globe-americas me-2"></i>
            TourEase
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link" href="#features">
                        <i class="fas fa-star me-1"></i> Features
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#destinations">
                        <i class="fas fa-map-marker-alt me-1"></i> Destinations
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#testimonials">
                        <i class="fas fa-comment me-1"></i> Testimonials
                    </a>
                </li>
                <li class="nav-item">
                    <button class="btn btn-light rounded-pill ms-2" data-bs-toggle="modal" data-bs-target="#loginModal">
                        <i class="fas fa-user me-1"></i> Login
                    </button>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Hero Section -->
<section class="hero-section">
    <div class="container">
        <div class="hero-content">
            <h1 class="hero-title" data-aos="fade-up">Discover Your Dream Journey</h1>
            <p class="hero-subtitle" data-aos="fade-up" data-aos-delay="200">
                Personalize your travel experience and explore the world's most stunning destinations
            </p>
            <div data-aos="fade-up" data-aos-delay="400">
                <button class="btn btn-primary hero-btn" data-bs-toggle="modal" data-bs-target="#loginModal">
                    <i class="fas fa-user me-2"></i>Sign In
                </button>
                <button class="btn btn-outline-light hero-btn" data-bs-toggle="modal" data-bs-target="#registerModal">
                    <i class="fas fa-user-plus me-2"></i>Register
                </button>
            </div>
        </div>
    </div>
</section>

<!-- Features Section -->
<section class="features-section" id="features">
    <div class="container">
        <div class="text-center mb-5">
            <h2 class="section-title section-center-title" data-aos="fade-up">Why Choose TourEase?</h2>
            <p class="lead text-muted" data-aos="fade-up" data-aos-delay="100">
                We offer the best travel experiences with personalized options for every adventurer
            </p>
        </div>

        <div class="row g-4">
            <div class="col-md-4" data-aos="fade-up" data-aos-delay="100">
                <div class="feature-card">
                    <i class="fas fa-map-marked-alt feature-icon"></i>
                    <h4 class="feature-title">Customizable Packages</h4>
                    <p class="text-muted">Create your perfect travel itinerary based on your preferences, schedule, and budget.</p>
                </div>
            </div>

            <div class="col-md-4" data-aos="fade-up" data-aos-delay="200">
                <div class="feature-card">
                    <i class="fas fa-dollar-sign feature-icon"></i>
                    <h4 class="feature-title">Best Price Guarantee</h4>
                    <p class="text-muted">We offer competitive pricing with transparent billing and no hidden fees.</p>
                </div>
            </div>

            <div class="col-md-4" data-aos="fade-up" data-aos-delay="300">
                <div class="feature-card">
                    <i class="fas fa-headset feature-icon"></i>
                    <h4 class="feature-title">24/7 Customer Support</h4>
                    <p class="text-muted">Our dedicated team is always ready to assist you throughout your journey.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Destinations Section -->
<section class="destinations-section" id="destinations">
    <div class="container">
        <div class="text-center mb-5">
            <h2 class="section-title section-center-title" data-aos="fade-up">Popular Destinations</h2>
            <p class="lead text-muted" data-aos="fade-up" data-aos-delay="100">
                Explore our most sought-after travel experiences and start planning your next adventure
            </p>
        </div>

        <div class="row g-4">
            <div class="col-md-4" data-aos="fade-up" data-aos-delay="100">
                <div class="destination-card">
                    <div class="overflow-hidden">
                        <img src="https://images.unsplash.com/photo-1520483601560-389dff434fdf?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1074&q=80" 
                            class="card-img-top destination-img" alt="Beach Paradise">
                    </div>
                    <div class="card-body">
                        <h5 class="destination-title">Beach Paradise</h5>
                        <p class="card-text">White sandy beaches, crystal clear water, and luxurious resorts for the ultimate relaxation.</p>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="price-highlight">From $999</span>
                            <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#loginModal">
                                <i class="fas fa-chevron-right me-1"></i> Explore
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4" data-aos="fade-up" data-aos-delay="200">
                <div class="destination-card">
                    <div class="overflow-hidden">
                        <img src="https://images.unsplash.com/photo-1612456225451-bb8d10d0131d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80" 
                            class="card-img-top destination-img" alt="Mountain Retreats">
                    </div>
                    <div class="card-body">
                        <h5 class="destination-title">Mountain Retreats</h5>
                        <p class="card-text">Scenic mountain views, hiking trails, and cozy cabins for an unforgettable adventure.</p>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="price-highlight">From $799</span>
                            <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#loginModal">
                                <i class="fas fa-chevron-right me-1"></i> Explore
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4" data-aos="fade-up" data-aos-delay="300">
                <div class="destination-card">
                    <div class="overflow-hidden">
                        <img src="https://images.unsplash.com/photo-1480714378408-67cf0d13bc1d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80" 
                            class="card-img-top destination-img" alt="City Escapes">
                    </div>
                    <div class="card-body">
                        <h5 class="destination-title">City Escapes</h5>
                        <p class="card-text">Vibrant city life, cultural experiences, and urban adventures for the curious traveler.</p>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="price-highlight">From $699</span>
                            <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#loginModal">
                                <i class="fas fa-chevron-right me-1"></i> Explore
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Testimonials Section -->
<section class="testimonials-section" id="testimonials">
    <div class="container">
        <div class="text-center mb-5">
            <h2 class="section-title section-center-title" data-aos="fade-up">What Our Travelers Say</h2>
            <p class="lead text-muted" data-aos="fade-up" data-aos-delay="100">
                Real stories from people who have experienced the TourEase difference
            </p>
        </div>

        <div class="row g-4">
            <div class="col-md-4" data-aos="fade-up" data-aos-delay="100">
                <div class="testimonial-card">
                    <div class="star-rating">
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                    </div>
                    <p class="card-text">"The customization options were amazing! I was able to create a perfect vacation package that fit my budget and preferences perfectly."</p>
                    <div class="d-flex mt-4 align-items-center">
                        <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center" style="width: 50px; height: 50px;">
                            <span class="fw-bold">JD</span>
                        </div>
                        <div class="ms-3">
                            <h6 class="mb-0">John Doe</h6>
                            <small class="text-muted">Adventure Traveler</small>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4" data-aos="fade-up" data-aos-delay="200">
                <div class="testimonial-card">
                    <div class="star-rating">
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                    </div>
                    <p class="card-text">"The customer service was exceptional. They helped me plan my entire trip and were available whenever I needed assistance throughout my journey."</p>
                    <div class="d-flex mt-4 align-items-center">
                        <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center" style="width: 50px; height: 50px;">
                            <span class="fw-bold">SM</span>
                        </div>
                        <div class="ms-3">
                            <h6 class="mb-0">Sarah Mitchell</h6>
                            <small class="text-muted">Family Traveler</small>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4" data-aos="fade-up" data-aos-delay="300">
                <div class="testimonial-card">
                    <div class="star-rating">
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star-half-alt"></i>
                    </div>
                    <p class="card-text">"The prices were very competitive and the booking process was smooth. I'll definitely use TourEase for my next vacation plans."</p>
                    <div class="d-flex mt-4 align-items-center">
                        <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center" style="width: 50px; height: 50px;">
                            <span class="fw-bold">MT</span>
                        </div>
                        <div class="ms-3">
                            <h6 class="mb-0">Michael Torres</h6>
                            <small class="text-muted">Business Traveler</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Call to Action -->
<section class="py-5 text-center" style="background-color: #f0f4f7;">
    <div class="container">
        <div data-aos="fade-up">
            <h2 class="display-5 fw-bold mb-4">Ready to start your adventure?</h2>
            <p class="lead mb-4">Join thousands of happy travelers who have discovered the world with TourEase.</p>
            <button class="btn btn-primary btn-lg px-5" data-bs-toggle="modal" data-bs-target="#registerModal">
                <i class="fas fa-paper-plane me-2"></i> Get Started Today
            </button>
        </div>
    </div>
</section>

<!-- Footer -->
<footer class="footer">
    <div class="container">
        <div class="row">
            <div class="col-lg-4 col-md-6 mb-4 mb-md-0">
                <h5 class="footer-heading">TourEase</h5>
                <p class="mb-4">Your gateway to extraordinary destinations and unforgettable experiences. Let us help you discover the world's hidden gems.</p>
                <div class="d-flex mb-4">
                    <a href="#" class="social-icon"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="social-icon"><i class="fab fa-twitter"></i></a>
                    <a href="#" class="social-icon"><i class="fab fa-instagram"></i></a>
                    <a href="#" class="social-icon"><i class="fab fa-linkedin-in"></i></a>
                </div>
            </div>
            <div class="col-lg-2 col-md-6 mb-4 mb-md-0">
                <h5 class="footer-heading">Destinations</h5>
                <ul class="list-unstyled">
                    <li><a href="#" class="footer-link"><i class="fas fa-angle-right me-2"></i>Beach Resorts</a></li>
                    <li><a href="#" class="footer-link"><i class="fas fa-angle-right me-2"></i>Mountain Retreats</a></li>
                    <li><a href="#" class="footer-link"><i class="fas fa-angle-right me-2"></i>City Escapes</a></li>
                    <li><a href="#" class="footer-link"><i class="fas fa-angle-right me-2"></i>Adventure Tours</a></li>
                    <li><a href="#" class="footer-link"><i class="fas fa-angle-right me-2"></i>Cultural Experiences</a></li>
                </ul>
            </div>
            <div class="col-lg-2 col-md-6 mb-4 mb-md-0">
                <h5 class="footer-heading">Company</h5>
                <ul class="list-unstyled">
                    <li><a href="#" class="footer-link"><i class="fas fa-angle-right me-2"></i>About Us</a></li>
                    <li><a href="#" class="footer-link"><i class="fas fa-angle-right me-2"></i>Our Team</a></li>
                    <li><a href="#" class="footer-link"><i class="fas fa-angle-right me-2"></i>Careers</a></li>
                    <li><a href="#" class="footer-link"><i class="fas fa-angle-right me-2"></i>Privacy Policy</a></li>
                    <li><a href="#" class="footer-link"><i class="fas fa-angle-right me-2"></i>Terms of Service</a></li>
                </ul>
            </div>
            <div class="col-lg-4 col-md-6">
                <h5 class="footer-heading">Contact Us</h5>
                <ul class="list-unstyled">
                    <li class="mb-2"><i class="fas fa-map-marker-alt me-2"></i> 123 Travel Street, Adventure City, AC 10000</li>
                    <li class="mb-2"><i class="fas fa-envelope me-2"></i> info@tourease.com</li>
                    <li class="mb-2"><i class="fas fa-phone me-2"></i> +1 (234) 567-8900</li>
                    <li class="mb-2"><i class="fas fa-clock me-2"></i> Monday - Friday: 9:00 AM - 5:00 PM</li>
                </ul>
            </div>
        </div>
        <hr style="background-color: rgba(255,255,255,0.1); margin: 2rem 0;">
        <div class="text-center">
            <p class="mb-0">&copy; 2025 TourEase. All rights reserved.</p>
        </div>
    </div>
</footer>

<!-- Login Modal -->
<div class="modal fade auth-modal" id="loginModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-sign-in-alt me-2"></i>
                    Login to TourEase
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div id="loginErrorAlert" class="alert alert-danger d-none" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    <span id="loginErrorMessage"></span>
                </div>
                <form id="loginForm">
                    <div class="mb-3">
                        <label for="loginUsername" class="form-label">Username</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-user"></i></span>
                            <input type="text" class="form-control" id="loginUsername" name="username" placeholder="Enter your username" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="loginPassword" class="form-label">Password</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-lock"></i></span>
                            <input type="password" class="form-control" id="loginPassword" name="password" placeholder="Enter your password" required>
                        </div>
                    </div>
                    <div class="mb-4">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="rememberMe">
                            <label class="form-check-label" for="rememberMe">Remember me</label>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-sign-in-alt me-2"></i>
                        Login
                    </button>
                </form>
            </div>
            <div class="modal-footer">
                <p class="text-center">Don't have an account? 
                    <span class="switch-form" data-bs-toggle="modal" data-bs-target="#registerModal" data-bs-dismiss="modal">Register now</span>
                </p>
            </div>
        </div>
    </div>
</div>

<!-- Register Modal -->
<div class="modal fade auth-modal" id="registerModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-user-plus me-2"></i>
                    Create an Account
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div id="registerErrorAlert" class="alert alert-danger d-none" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    <span id="registerErrorMessage"></span>
                </div>
                <form id="registerForm">
                    <div class="mb-3">
                        <label for="fullName" class="form-label">Full Name</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-user"></i></span>
                            <input type="text" class="form-control" id="fullName" name="fullName" placeholder="Enter your full name" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="email" class="form-label">Email</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                            <input type="email" class="form-control" id="email" name="email" placeholder="Enter your email" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="registerUsername" class="form-label">Username</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-user"></i></span>
                            <input type="text" class="form-control" id="registerUsername" name="username" placeholder="Choose a username" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="registerPassword" class="form-label">Password</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-lock"></i></span>
                            <input type="password" class="form-control" id="registerPassword" name="password" placeholder="Create a password" required>
                        </div>
                    </div>
                    <div class="mb-4">
                        <label for="confirmPassword" class="form-label">Confirm Password</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-lock"></i></span>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Confirm your password" required>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-user-plus me-2"></i>
                        Register
                    </button>
                </form>
            </div>
            <div class="modal-footer">
                <p class="text-center">Already have an account? 
                    <span class="switch-form" data-bs-toggle="modal" data-bs-target="#loginModal" data-bs-dismiss="modal">Login here</span>
                </p>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- AOS Animation Library -->
<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script>
    // Initialize AOS animation
    AOS.init({
        duration: 1000,
        easing: 'ease-in-out',
        once: true
    });

    // Handle the login form submission
    $('#loginForm').on('submit', function(e) {
        e.preventDefault();
        
        const username = $('#loginUsername').val();
        const password = $('#loginPassword').val();
        
        // Show spinner in button
        const loginBtn = $(this).find('button[type="submit"]');
        const originalBtnText = loginBtn.html();
        loginBtn.html('<span class="spinner-border spinner-border-sm me-2"></span> Logging in...');
        loginBtn.prop('disabled', true);
        
        $.ajax({
            url: 'login',
            method: 'POST',
            headers: {
                'X-Requested-With': 'XMLHttpRequest'
            },
            data: {
                username: username,
                password: password
            },
            success: function(response) {
                // Reset button state
                loginBtn.html(originalBtnText);
                loginBtn.prop('disabled', false);
                
                try {
                    // Try to parse response as JSON if it's a string
                    if (typeof response === 'string') {
                        response = JSON.parse(response);
                    }
                    
                    if (response.success) {
                        // Login successful
                        if (response.isAdmin) {
                            window.location.href = 'admin/dashboard.jsp';
                        } else {
                            window.location.href = 'dashboard.jsp';
                        }
                    } else {
                        // Login failed
                        $('#loginErrorMessage').text(response.message || 'Invalid username or password');
                        $('#loginErrorAlert').removeClass('d-none').addClass('alert-danger');
                    }
                } catch (e) {
                    console.error('Error parsing response:', e);
                    // Fallback for non-JSON responses
                    $('#loginErrorMessage').text('Login failed. Please try again.');
                    $('#loginErrorAlert').removeClass('d-none').addClass('alert-danger');
                }
            },
            error: function(xhr, status, error) {
                console.error('Login error:', error);
                $('#loginErrorMessage').text('Login failed. Please try again.');
                $('#loginErrorAlert').removeClass('d-none').addClass('alert-danger');
                loginBtn.html(originalBtnText);
                loginBtn.prop('disabled', false);
            }
        });
    });

    // Handle the register form submission
    $('#registerForm').on('submit', function(e) {
        e.preventDefault();
        
        const fullName = $('#fullName').val();
        const email = $('#email').val();
        const username = $('#registerUsername').val();
        const password = $('#registerPassword').val();
        const confirmPassword = $('#confirmPassword').val();
        
        // Validate that passwords match
        if (password !== confirmPassword) {
            $('#registerErrorMessage').text('Passwords do not match');
            $('#registerErrorAlert').removeClass('d-none');
            return;
        }
        
        // Show spinner in button
        const registerBtn = $(this).find('button[type="submit"]');
        const originalBtnText = registerBtn.html();
        registerBtn.html('<span class="spinner-border spinner-border-sm me-2"></span> Registering...');
        registerBtn.prop('disabled', true);
        
        $.ajax({
            url: 'register',
            method: 'POST',
            headers: {
                'X-Requested-With': 'XMLHttpRequest'
            },
            data: {
                fullName: fullName,
                email: email,
                username: username,
                password: password,
                confirmPassword: confirmPassword
            },
            success: function(response) {
                try {
                    // Try to parse response as JSON
                    if (typeof response === 'string') {
                        response = JSON.parse(response);
                    }
                    
                    if (response.success) {
                        // Registration successful - close register modal and open login modal with success message
                        $('#registerModal').modal('hide');
                        
                        // Show success alert in login modal
                        $('#loginErrorAlert').removeClass('alert-danger').addClass('alert-success');
                        $('#loginErrorMessage').text('Registration successful! Please login with your credentials.');
                        $('#loginErrorAlert').removeClass('d-none');
                        
                        // Open login modal
                        $('#loginModal').modal('show');
                    } else {
                        // Show error from response
                        $('#registerErrorMessage').text(response.message || 'Registration failed. Please try again.');
                        $('#registerErrorAlert').removeClass('d-none');
                    }
                } catch (e) {
                    // For backward compatibility, check if response contains success indicators
                    if (response.includes('login?registered=true')) {
                        // Registration successful - close register modal and open login modal with success message
                        $('#registerModal').modal('hide');
                        
                        // Show success alert in login modal
                        $('#loginErrorAlert').removeClass('alert-danger').addClass('alert-success');
                        $('#loginErrorMessage').text('Registration successful! Please login with your credentials.');
                        $('#loginErrorAlert').removeClass('d-none');
                        
                        // Open login modal
                        $('#loginModal').modal('show');
                    } else {
                        // Show error from response
                        const errorMsg = $(response).find('.alert-danger').text().trim();
                        $('#registerErrorMessage').text(errorMsg || 'Registration failed. Please try again.');
                        $('#registerErrorAlert').removeClass('d-none');
                    }
                }
                
                registerBtn.html(originalBtnText);
                registerBtn.prop('disabled', false);
            },
            error: function(xhr) {
                $('#registerErrorMessage').text('Registration failed. Please try again.');
                $('#registerErrorAlert').removeClass('d-none');
                registerBtn.html(originalBtnText);
                registerBtn.prop('disabled', false);
            }
        });
    });
    
    // Hide alert messages when modals are hidden
    $('#loginModal, #registerModal').on('hidden.bs.modal', function() {
        $('#loginErrorAlert, #registerErrorAlert').addClass('d-none');
        $('#loginForm, #registerForm')[0].reset();
    });
</script>
</body>
</html>