<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="tourism.model.User" %>
<%@ page import="tourism.model.Package" %>
<%@ page import="tourism.util.PackageFileHandler" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
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
    
    // Get package ID from request parameter
    String packageId = request.getParameter("id");
    if (packageId == null || packageId.trim().isEmpty()) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
    
    // Get package details using the instance method
    Package pkg = packageHandler.getPackageById(packageId);
    if (pkg == null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
    
    // Process package images
    List<String> packageImages = new ArrayList<>();
    if (pkg.getPackageImages() != null && !pkg.getPackageImages().isEmpty()) {
        for (String imgString : pkg.getPackageImages()) {
            if (imgString.contains(",")) {
                String[] images = imgString.split(",");
                for (String img : images) {
                    packageImages.add(img.trim());
                }
            } else {
                packageImages.add(imgString.trim());
            }
        }
    }
    
    // If no images available, use placeholder
    if (packageImages.isEmpty()) {
        packageImages.add("https://via.placeholder.com/800x500?text=No+Image");
    }
    
    // Get similar packages for recommendation using the instance method
    List<Package> allPackages = packageHandler.getAllPackages();
    List<Package> similarPackages = new ArrayList<>();
    String currentCategory = pkg.getCategory();
    
    // Filter by same category
    for (Package p : allPackages) {
        if (p.getCategory() != null && 
            p.getCategory().equals(currentCategory) && 
            !p.getPackageId().equals(packageId)) {
            similarPackages.add(p);
        }
    }
    
    // If we don't have enough packages in the same category, add from other categories
    if (similarPackages.size() < 2) {
        for (Package p : allPackages) {
            if (!p.getPackageId().equals(packageId) && 
                !similarPackages.contains(p)) {
                similarPackages.add(p);
                if (similarPackages.size() >= 2) break;
            }
        }
    }
    
    // Take only the first 2 packages
    if (similarPackages.size() > 2) {
        similarPackages = similarPackages.subList(0, 2);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pkg.getPackageName() %> - Tourism Package Details</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- AOS Animation library -->
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="css/packageDetails.css">
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
    </nav>

    <!-- Main Content -->
    <div class="container my-5">
        <a href="dashboard.jsp" class="back-link d-inline-block mb-4" data-aos="fade-right">
            <i class="fas fa-arrow-left me-2"></i> Back to All Packages
        </a>
        
        <!-- Package header - made more compact -->
        <div class="package-header py-4" data-aos="fade-up">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="package-title"><%= pkg.getPackageName() %></h1>
                    <div class="package-location">
                        <i class="fas fa-map-marker-alt me-2"></i> <%= pkg.getDestination() %>
                    </div>
                    <% if ("hot".equals(pkg.getStatus())) { %>
                    <span class="badge-status badge-hot">HOT DEAL</span>
                    <% } else if (pkg.getStatus() != null && !pkg.getStatus().isEmpty()) { %>
                    <span class="badge-status"><%= pkg.getStatus().toUpperCase() %></span>
                    <% } %>
                </div>
                <div class="col-md-4 text-md-end">
                    <div class="d-inline-block">
                        <span class="badge-category"><i class="fas fa-tag me-1"></i> <%= pkg.getCategory() %></span>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Rearranged layout - Booking information column first on desktop (right side) -->
        <div class="row">
            <!-- Pricing column (will appear on the right on desktop) -->
            <div class="col-lg-4 order-lg-2 mb-4" data-aos="fade-left">
                <div class="package-price-card">
                    <div class="price-content">
                        <div class="price-title">Package cost</div>
                        <div class="price-value">$<%= String.format("%.2f", pkg.getPrice()) %></div>
                        
                        <!-- Standard package booking -->
                        <div class="mb-3">
                            <div class="price-detail">
                                <span><i class="fas fa-tag me-2 text-warning"></i>Base Price:</span>
                                <span class="price-detail-value">$<%= String.format("%.2f", pkg.getPrice()) %></span>
                            </div>
                            <div class="price-detail">
                                <span><i class="fas fa-calendar-alt me-2 text-warning"></i>Duration:</span>
                                <span class="price-detail-value"><%= pkg.getDuration() %> days</span>
                            </div>
                            <div class="price-detail">
                                <span><i class="fas fa-plane-departure me-2 text-warning"></i>Departure:</span>
                                <span class="price-detail-value"><%= pkg.getDepartureDate() %></span>
                            </div>
                            <div class="price-detail fw-bold">
                                <span>Total:</span>
                                <span>$<%= String.format("%.2f", pkg.getPrice()) %></span>
                            </div>
                        </div>
                        <button type="button" id="bookNowBtn" class="booking-btn">
                            <i class="fas fa-shopping-cart me-2"></i>Book Now
                        </button>
                        
                        <div class="section-divider"></div>
                        
                        <!-- Customization section -->
                        <div class="customization-section">
                            <div class="custom-package-title">Customize Your Trip</div>
                            <p class="form-small-text mb-3">Create your own custom package with these options:</p>
                            
                            <div class="mb-3">
                                <label for="departureDate" class="form-label-custom">Departure Date:</label>
                                <input type="date" id="departureDate" class="form-control form-control-custom" 
                                       value="<%= pkg.getDepartureDate() %>" min="<%= java.time.LocalDate.now() %>">
                            </div>
                            
                            <div class="mb-3">
                                <label for="participants" class="form-label-custom">Number of Participants:</label>
                                <input type="number" id="participants" class="form-control form-control-custom" 
                                       value="1" min="1">
                            </div>
                            
                            <div class="mb-3">
                                <label for="duration" class="form-label-custom">Duration (nights):</label>
                                <input type="number" id="duration" class="form-control form-control-custom" 
                                       value="<%= pkg.getDuration() - 1 %>" min="1">
                            </div>
                            
                            <!-- Custom package pricing -->
                            <div class="price-summary-box">
                                <div class="summary-title">Your Custom Package</div>
                                <div class="price-detail">
                                    <span><i class="fas fa-users me-2 text-warning"></i>Participants (<span id="participantCount">1</span>):</span>
                                    <span id="participantCost">$<%= String.format("%.2f", 30.00) %></span>
                                </div>
                                <div class="price-detail">
                                    <span><i class="fas fa-moon me-2 text-warning"></i>Duration (<span id="nightCount"><%= pkg.getDuration() - 1 %></span> nights):</span>
                                    <span id="durationCost">$<%= String.format("%.2f", (pkg.getDuration() - 1) * 50.00) %></span>
                                </div>
                                <div class="price-detail fw-bold">
                                    <span>Total Custom Price:</span>
                                    <span id="totalPrice">
                                        $<%= String.format("%.2f", 
                                            30.00 + // Default 1 participant cost
                                            ((pkg.getDuration() - 1) * 50.00) // Default duration cost
                                            ) %>
                                    </span>
                                </div>
                            </div>
                            <button type="button" id="bookCustomBtn" class="booking-btn" style="background-color: var(--secondary-color); color: white;">
                                <i class="fas fa-magic me-2"></i>Book Custom Package
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Package details column (will appear on the left on desktop) -->
            <div class="col-lg-8 order-lg-1" data-aos="fade-right">
                <!-- Image gallery -->
                <div class="package-card">
                    <div id="packageImageCarousel" class="carousel slide package-image-carousel" data-bs-ride="carousel">
                        <div class="carousel-indicators">
                            <% for (int i = 0; i < packageImages.size(); i++) { %>
                                <button type="button" data-bs-target="#packageImageCarousel" data-bs-slide-to="<%= i %>" 
                                        <%= (i == 0) ? "class=\"active\" aria-current=\"true\"" : "" %> 
                                        aria-label="Slide <%= i+1 %>"></button>
                            <% } %>
                        </div>
                        <div class="carousel-inner">
                            <% for (int i = 0; i < packageImages.size(); i++) { %>
                                <div class="carousel-item <%= (i == 0) ? "active" : "" %>">
                                    <img src="<%= packageImages.get(i) %>" class="d-block w-100" alt="Package image <%= i+1 %>">
                                </div>
                            <% } %>
                        </div>
                        <% if (packageImages.size() > 1) { %>
                            <button class="carousel-control-prev" type="button" data-bs-target="#packageImageCarousel" data-bs-slide="prev">
                                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                <span class="visually-hidden">Previous</span>
                            </button>
                            <button class="carousel-control-next" type="button" data-bs-target="#packageImageCarousel" data-bs-slide="next">
                                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                <span class="visually-hidden">Next</span>
                            <% } %>
                        </div>
                    </div>

                    <!-- Package description -->
                    <div class="mt-4">
                        <h4>Description</h4>
                        <p><%= pkg.getDescription() %></p>
                    </div>
                    
                    <!-- Package details -->
                    <div class="row mt-4">
                        <div class="col-md-6 mb-3">
                            <div class="package-detail-label">Duration</div>
                            <div><i class="fas fa-calendar-alt me-2"></i> <%= pkg.getDuration() %> days</div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <div class="package-detail-label">Departure Date</div>
                            <div><i class="fas fa-plane-departure me-2"></i> <%= pkg.getDepartureDate() %></div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <div class="package-detail-label">Category</div>
                            <div><i class="fas fa-tag me-2"></i> <%= pkg.getCategory() %></div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <div class="package-detail-label">Max Participants</div>
                            <div><i class="fas fa-users me-2"></i> <%= pkg.getMaxParticipants() %> people</div>
                        </div>
                    </div>

                    <!-- Added Inquiry Button with inline styling -->
                    <div class="text-center mt-4">
                        <button type="button" 
                                data-bs-toggle="modal" 
                                data-bs-target="#inquiryModal"
                                style="
                                    background: #22A699;
                                    border: none;
                                    color: white;
                                    padding: 12px 30px;
                                    border-radius: 25px;
                                    font-size: 1.1rem;
                                    font-weight: 500;
                                    text-transform: uppercase;
                                    letter-spacing: 1px;
                                    box-shadow: 0 4px 15px rgba(33, 150, 243, 0.3);
                                    transition: all 0.3s ease;
                                    cursor: pointer;
                                    display: inline-flex;
                                    align-items: center;
                                    gap: 10px;
                                "
                                onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 6px 20px rgba(33, 150, 243, 0.4)'"
                                onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='0 4px 15px rgba(33, 150, 243, 0.3)'"
                        >
                            <i class="fas fa-question-circle" style="font-size: 1.2rem;"></i>
                            Have Questions? Make an Inquiry
                        </button>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Enhanced Similar Packages Section -->
        <div class="recommendation-content" data-aos="fade-up">
            <div class="recommendation-header">
                <h3 class="recommendation-title">You Might Also Like</h3>
                <div class="divider"></div>
                <p class="text-muted">Explore more amazing destinations that match your interests</p>
            </div>
            
            <div class="row">
                <% if (similarPackages.isEmpty()) { %>
                    <div class="col-12 text-center">
                        <div class="card p-4 border-0 shadow-sm">
                            <div class="card-body">
                                <i class="fas fa-search fa-3x text-primary mb-3"></i>
                                <h5>No similar packages found</h5>
                                <p>We're always adding new destinations. Check back soon!</p>
                            </div>
                        </div>
                    </div>
                <% } else {
                    for (Package similarPkg : similarPackages) {
                        // Get the first image of the similar package
                        String similarImage = "https://via.placeholder.com/800x500?text=No+Image";
                        if (similarPkg.getPackageImages() != null && !similarPkg.getPackageImages().isEmpty()) {
                            String img = similarPkg.getPackageImages().get(0);
                            if (img.contains(",")) {
                                similarImage = img.split(",")[0].trim();
                            } else {
                                similarImage = img.trim();
                            }
                        }
                %>
                    <div class="col-md-6 mb-4" data-aos="fade-up" data-aos-delay="<%= similarPackages.indexOf(similarPkg) * 100 %>">
                        <div class="similar-package-card h-100">
                            <div class="position-relative overflow-hidden">
                                <img src="<%= similarImage %>" alt="<%= similarPkg.getPackageName() %>" class="similar-package-image">
                                <div class="similar-package-price">$<%= String.format("%.2f", similarPkg.getPrice()) %></div>
                                <% if ("hot".equals(similarPkg.getStatus())) { %>
                                    <span class="badge badge-hot" style="position: absolute; left: 15px; top: 15px; font-size: 0.7rem; padding: 4px 8px;">HOT</span>
                                <% } %>
                            </div>
                            <div class="similar-package-content">
                                <h5 class="similar-package-title" title="<%= similarPkg.getPackageName() %>"><%= similarPkg.getPackageName() %></h5>
                                <p class="mb-2" style="font-size: 0.85rem;"><i class="fas fa-map-marker-alt me-1 text-primary"></i> <%= similarPkg.getDestination() %></p>
                                <div class="similar-package-meta">
                                    <span><i class="fas fa-calendar-alt me-1 text-primary"></i> <%= similarPkg.getDuration() %> days</span>
                                    <span><i class="fas fa-users me-1 text-primary"></i> Max <%= similarPkg.getMaxParticipants() %></span>
                                </div>
                                <p class="similar-package-description">
                                    <%= similarPkg.getDescription() != null ? similarPkg.getDescription().substring(0, Math.min(similarPkg.getDescription().length(), 80)) + "..." : "No description available" %>
                                </p>
                                <a href="packageDetails.jsp?id=<%= similarPkg.getPackageId() %>" class="btn-view-similar">
                                    <i class="fas fa-info-circle me-1"></i> View Details
                                </a>
                            </div>
                        </div>
                    </div>
                <% } } %>
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

    <!-- Inquiry Modal -->
    <div class="modal fade" id="inquiryModal" tabindex="-1" aria-labelledby="inquiryModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="inquiryModalLabel">Inquire About This Package</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <!-- Add alert for messages -->
                    <div id="inquiryFormAlert" class="alert" style="display: none;"></div>
                    
                    <!-- Change form id and remove action and method -->
                    <form id="inquiryForm">
                        <!-- Package details (readonly) -->
                        <div class="mb-3">
                            <div class="inquiry-package-info p-3 mb-3 rounded">
                                <h6 class="fw-bold"><%= pkg.getPackageName() %></h6>
                                <div class="small text-muted">
                                    <i class="fas fa-map-marker-alt me-1"></i> <%= pkg.getDestination() %> | 
                                    <i class="fas fa-calendar-alt me-1"></i> <%= pkg.getDuration() %> days
                                </div>
                                <div class="small fw-bold text-primary mt-1">$<%= String.format("%.2f", pkg.getPrice()) %></div>
                                <input type="hidden" name="packageId" value="<%= pkg.getPackageId() %>">
                                <input type="hidden" name="packageName" value="<%= pkg.getPackageName() %>">
                            </div>
                        </div>
                        
                        <!-- Inquiry Subject -->
                        <div class="mb-3">
                            <label for="inquirySubject" class="form-label">Subject</label>
                            <input type="text" class="form-control" id="inquirySubject" name="subject" placeholder="Brief description of your inquiry" required>
                        </div>
                        
                        <!-- Inquiry Type -->
                        <div class="mb-3">
                            <label for="inquiryType" class="form-label">Inquiry Type</label>
                            <select class="form-select" id="inquiryType" name="type" required>
                                <option value="" selected disabled>Please select an option</option>
                                <option value="pricing">Pricing & Payment</option>
                                <option value="itinerary">Itinerary Details</option>
                                <option value="accommodation">Accommodation</option>
                                <option value="transportation">Transportation</option>
                                <option value="availability">Availability</option>
                                <option value="other">Other</option>
                            </select>
                        </div>
                        
                        <!-- Inquiry Message -->
                        <div class="mb-3">
                            <label for="inquiryMessage" class="form-label">Your Message</label>
                            <textarea class="form-control" id="inquiryMessage" name="message" rows="4" placeholder="Please provide details about your inquiry..." required></textarea>
                        </div>
                        
                        <!-- Preferred Contact Method -->
                        <div class="mb-3">
                            <label class="form-label">Preferred Contact Method</label>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="contactMethod" id="contactEmail" value="email" checked>
                                <label class="form-check-label" for="contactEmail">Email</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="contactMethod" id="contactPhone" value="phone">
                                <label class="form-check-label" for="contactPhone">Phone</label>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <!-- Change to button type button instead of submit -->
                            <button type="button" id="submitInquiryBtn" class="btn btn-primary">Submit Inquiry</button>
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
            // Check for URL parameter
            const params = new URLSearchParams(window.location.search);
            const inquirySent = params.get('inquirySent');
            
            if (inquirySent === 'true') {
                alert('Your inquiry has been submitted successfully. Our team will get back to you soon.');
            } else if (inquirySent === 'false') {
                alert('There was an error submitting your inquiry. Please try again.');
            }
            
            // Add AJAX form submission handler for inquiry
            document.getElementById('submitInquiryBtn').addEventListener('click', function(e) {
                e.preventDefault();
                
                // Get form data
                const form = document.getElementById('inquiryForm');
                const formData = new FormData(form);
                
                // Basic form validation
                const subject = formData.get('subject');
                const message = formData.get('message');
                const type = formData.get('type');
                
                if (!subject || !message || !type) {
                    showInquiryMessage('Please fill in all required fields.', 'danger');
                    return;
                }
                
                // Show loading state
                const submitBtn = document.getElementById('submitInquiryBtn');
                const originalBtnText = submitBtn.innerHTML;
                submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Submitting...';
                submitBtn.disabled = true;
                
                // Create an XMLHttpRequest
                const xhr = new XMLHttpRequest();
                xhr.open('POST', '${pageContext.request.contextPath}/submitInquiry', true);
                xhr.onload = function() {
                    submitBtn.innerHTML = originalBtnText;
                    submitBtn.disabled = false;
                    
                    if (xhr.status === 200) {
                        // Success
                        showInquiryMessage('Your inquiry has been submitted successfully. Our team will get back to you soon.', 'success');
                        
                        // Reset form
                        form.reset();
                        
                        // Close modal after 2 seconds
                        setTimeout(function() {
                            $('#inquiryModal').modal('hide');
                            document.getElementById('inquiryFormAlert').style.display = 'none';
                        }, 2000);
                    } else {
                        // Error
                        showInquiryMessage('There was an error submitting your inquiry. Please try again.', 'danger');
                    }
                };
                
                xhr.onerror = function() {
                    submitBtn.innerHTML = originalBtnText;
                    submitBtn.disabled = false;
                    showInquiryMessage('Network error occurred. Please check your internet connection and try again.', 'danger');
                };
                
                // Convert FormData to URL encoded form data
                const urlEncodedData = new URLSearchParams(formData).toString();
                xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                xhr.send(urlEncodedData);
            });
            
            // Function to show messages in the inquiry form
            function showInquiryMessage(message, type) {
                const alertElement = document.getElementById('inquiryFormAlert');
                alertElement.className = 'alert alert-' + type;
                alertElement.innerHTML = message;
                alertElement.style.display = 'block';
                
                // Scroll to the top of the modal
                document.querySelector('.modal-body').scrollTop = 0;
            }
            
            // Dynamic price calculation for custom package
            const participantCost = 30.00;  // Cost per participant
            const nightlyCost = 50.00;      // Cost per night per person
            
            const participantsInput = document.getElementById('participants');
            const durationInput = document.getElementById('duration');
            const departureDateInput = document.getElementById('departureDate');
            
            const participantCountSpan = document.getElementById('participantCount');
            const nightCountSpan = document.getElementById('nightCount');
            const participantCostSpan = document.getElementById('participantCost');
            const durationCostSpan = document.getElementById('durationCost');
            const totalPriceSpan = document.getElementById('totalPrice');
            
            // Function to calculate and update the custom price
            function updateCustomPrice() {
                const participants = parseInt(participantsInput.value) || 1;
                const nights = parseInt(durationInput.value) || 1;
                
                // Calculate costs
                const participantsCost = participants * participantCost;
                const durationCost = participants * nights * nightlyCost;
                const total = participantsCost + durationCost;
                
                // Update the display
                participantCountSpan.textContent = participants;
                nightCountSpan.textContent = nights;
                participantCostSpan.textContent = '$' + participantsCost.toFixed(2);
                durationCostSpan.textContent = '$' + durationCost.toFixed(2);
                totalPriceSpan.textContent = '$' + total.toFixed(2);
            }
            
            // Add event listeners to inputs
            participantsInput.addEventListener('input', updateCustomPrice);
            durationInput.addEventListener('input', updateCustomPrice);
            departureDateInput.addEventListener('change', function() {
                // You could add more logic here for date-specific pricing
                updateCustomPrice();
            });
            
            // Initialize the standard booking button
            document.getElementById('bookNowBtn').addEventListener('click', function() {
                // Create a form to submit to payment page
                const form = document.createElement('form');
                form.method = 'POST';
                // Use absolute path instead of relative path
                form.action = '<%= request.getContextPath() %>/payment.jsp';
                
                // Add hidden fields with package information
                const fields = {
                    'packageId': '<%= pkg.getPackageId() %>',
                    'packageName': '<%= pkg.getPackageName() %>',
                    'packagePrice': '<%= String.format("%.2f", pkg.getPrice()) %>',
                    'packageDuration': '<%= pkg.getDuration() %>',
                    'packageDestination': '<%= pkg.getDestination() %>',
                    'packageDepartureDate': '<%= pkg.getDepartureDate() %>',
                    'bookingType': 'standard'
                };
                
                // Create and append hidden fields to form
                for (const [key, value] of Object.entries(fields)) {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = key;
                    input.value = value;
                    form.appendChild(input);
                }
                
                // Append form to body and submit
                document.body.appendChild(form);
                form.submit();
            });
            
            // Initialize the custom booking button
            document.getElementById('bookCustomBtn').addEventListener('click', function() {
                const participants = participantsInput.value;
                const nights = durationInput.value;
                const departureDate = departureDateInput.value;
                const total = totalPriceSpan.textContent.replace('$', '');
                
                // Create a form to submit to payment page
                const form = document.createElement('form');
                form.method = 'POST';
                // Use absolute path instead of relative path
                form.action = '<%= request.getContextPath() %>/payment.jsp';
                
                // Add hidden fields with package and custom information
                const fields = {
                    'packageId': '<%= pkg.getPackageId() %>',
                    'packageName': '<%= pkg.getPackageName() %>',
                    'packagePrice': total,
                    'packageDuration': nights,
                    'packageDestination': '<%= pkg.getDestination() %>',
                    'packageDepartureDate': departureDate,
                    'participants': participants,
                    'bookingType': 'custom'
                };
                
                // Create and append hidden fields to form
                for (const [key, value] of Object.entries(fields)) {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = key;
                    input.value = value;
                    form.appendChild(input);
                }
                
                // Append form to body and submit
                document.body.appendChild(form);
                form.submit();
            });
        });
    </script>
</body>
</html>
``` 
