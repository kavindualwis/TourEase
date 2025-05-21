<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="tourism.model.User" %>
<%@ page import="tourism.model.Package" %>
<%@ page import="tourism.util.PackageFileHandler" %>
<%@ page import="tourism.util.PackageSorter" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login");
        return;
    }
    
    // Create an instance of PackageFileHandler
    PackageFileHandler packageHandler = new PackageFileHandler();
    
    // Get all packages from the handler instance
    List<Package> allPackages = packageHandler.getAllPackages();
    
    // Get sort parameter
    String sortParam = request.getParameter("sort");
    boolean isSorted = sortParam != null && !sortParam.isEmpty();
    
    // Create a copy of packages for sorting (to not modify the original list)
    List<Package> sortedPackages = new ArrayList<>(allPackages);
    
    // Sort packages if requested - Ensure proper boolean value for ascending
    if (isSorted) {
        boolean ascending = !"desc".equals(sortParam); // Default to ascending unless explicitly "desc"
        PackageSorter.sortByPrice(sortedPackages, ascending);
        
        // Debug output to console - optional
        System.out.println("Sorting packages: " + (ascending ? "Low to High" : "High to Low"));
    }
    
    // Group packages by category (for the non-sorted view)
    Map<String, List<Package>> packagesByCategory = new HashMap<>();
    for (Package pkg : allPackages) {
        String category = pkg.getCategory();
        if (!packagesByCategory.containsKey(category)) {
            packagesByCategory.put(category, new ArrayList<>());
        }
        packagesByCategory.get(category).add(pkg);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tourism Package Platform</title>
    <link rel="stylesheet" href="css/styles.css">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- AOS Animation library -->
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <!-- Dashboard specific CSS -->
    <link rel="stylesheet" href="css/dashboard.css">
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
                    <a class="nav-link active" href="#packages">
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

<!-- Hero Section -->
<section class="hero-section">
    <div class="container">
        <div class="hero-content" data-aos="fade-up">
            <h1 class="hero-title">Explore the World</h1>
            <p class="hero-subtitle">Discover amazing destinations and customize your perfect travel experience</p>
            <div class="hero-buttons">
                <a href="#packages" class="btn btn-warning btn-lg me-3">
                    <i class="fas fa-compass me-2"></i>Discover Packages
                </a>
                <a href="#tips" class="btn btn-outline-light btn-lg">
                    <i class="fas fa-info-circle me-2"></i>Travel Tips
                </a>
            </div>
        </div>
    </div>
</section>

<!-- Main Content -->
<div class="container mt-5" id="packages">
    <!-- Featured Destinations Section -->
    <div class="section-header" data-aos="fade-up">
        <div class="d-flex justify-content-between align-items-center w-100">
            <div>
                <h2 class="section-title">Explore Our Packages</h2>
                <p class="section-subtitle mb-0">Handpicked destinations for unforgettable experiences and adventures around the world</p>
            </div>
            
            <!-- Sort Dropdown - Fixed positioning -->
            <div class="dropdown">
                <button class="btn btn-outline-primary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false" id="sortDropdown">
                    <i class="fas fa-sort me-2"></i>Sort by Price
                </button>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="sortDropdown">
                    <li><a class="dropdown-item <%= sortParam == null || sortParam.isEmpty() ? "active" : "" %>" href="dashboard.jsp">
                        <i class="fas fa-th-large me-2"></i>Default (By Category)
                    </a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item <%= "asc".equals(sortParam) ? "active" : "" %>" href="dashboard.jsp?sort=asc">
                        <i class="fas fa-sort-amount-down-alt me-2"></i>Price: Low to High
                    </a></li>
                    <!-- Sort by Price: High to Low -->
                </ul>
            </div>
        </div>
    </div>

    <!-- All Travel Packages Section -->
    <% if (allPackages.isEmpty()) { %>
        <div class="alert alert-info mt-4" data-aos="fade-up">
            <h5><i class="fas fa-info-circle me-2"></i>No packages available at the moment.</h5>
            <p>Please check back later for exciting travel packages.</p>
        </div>
    <% } else { %>
        <% if (isSorted) { %>
            <!-- Display all packages in sorted order -->
            <div class="mt-5" data-aos="fade-up">
                <h4 class="category-title">All Packages <small class="text-muted">(Sorted by Price: <%= "asc".equals(sortParam) ? "Low to High" : "High to Low" %>)</small></h4>
                <div class="package-grid">
                    <% int itemDelay = 0;
                       for (Package pkg : sortedPackages) { 
                        // Get all images for the package
                        List<String> packageImages = new ArrayList<>();
                        
                        if (pkg.getPackageImages() != null && !pkg.getPackageImages().isEmpty()) {
                            String imgString = pkg.getPackageImages().get(0);
                            if (imgString.contains(",")) {
                                String[] images = imgString.split(",");
                                for (String img : images) {
                                    packageImages.add(img.trim());
                                }
                            } else {
                                packageImages.add(imgString.trim());
                            }
                        }
                        
                        // If no images available, use placeholder
                        if (packageImages.isEmpty()) {
                            packageImages.add("https://via.placeholder.com/400x250?text=No+Image");
                        }
                        
                        String packageId = String.valueOf(pkg.getPackageId());
                    %>
                        <div class="package-card" data-aos="fade-up" data-aos-delay="<%= itemDelay %>" 
                             onclick="window.location.href='packageDetails.jsp?id=<%= pkg.getPackageId() %>'">
                            <div class="package-image-container">
                                <div class="package-image-slider" id="slider-<%= packageId %>">
                                    <% for (int i = 0; i < packageImages.size(); i++) { %>
                                        <div class="package-image-slide">
                                            <img src="<%= packageImages.get(i) %>" class="package-image" alt="<%= pkg.getPackageName() %> image <%= i+1 %>">
                                        </div>
                                    <% } %>
                                </div>
                                
                                <% if (packageImages.size() > 1) { %>
                                <div class="slider-indicator">
                                    <% for (int i = 0; i < packageImages.size(); i++) { %>
                                        <div class="slider-dot <%= i == 0 ? "active" : "" %>" data-index="<%= i %>"></div>
                                    <% } %>
                                </div>
                                <% } %>
                                
                                <% if ("hot".equals(pkg.getStatus())) { %>
                                    <span class="badge badge-hot">HOT DEAL</span>
                                <% } %>
                            </div>
                            <div class="package-info">
                                <h5 class="package-title" title="<%= pkg.getPackageName() %>"><%= pkg.getPackageName() %></h5>
                                <div class="package-location" title="<%= pkg.getDestination() %>">
                                    <i class="fas fa-map-marker-alt me-1"></i><%= pkg.getDestination() %>
                                </div>
                                <div class="package-meta">
                                    <span><i class="fas fa-calendar me-1"></i><%= pkg.getDuration() %> days</span>
                                    <span><i class="fas fa-users me-1"></i>Max <%= pkg.getMaxParticipants() %></span>
                                </div>
                                <div class="d-flex justify-content-between align-items-center">
                                    <div class="package-price">$<%= String.format("%.2f", pkg.getPrice()) %></div>
                                    <a href="packageDetails.jsp?id=<%= pkg.getPackageId() %>" class="btn btn-primary btn-view" onclick="event.stopPropagation();">
                                        <i class="fas fa-eye me-1"></i> View
                                    </a>
                                </div>
                            </div>
                        </div>
                    <% itemDelay += 100; } %>
                </div>
            </div>
        <% } else { %>
            <!-- Original category-based display -->
            <% int categoryDelay = 0; 
               for (Map.Entry<String, List<Package>> entry : packagesByCategory.entrySet()) { %>
                <div class="mt-5" data-aos="fade-up" data-aos-delay="<%= categoryDelay %>">
                    <h4 class="category-title"><%= entry.getKey() %></h4>
                    <div class="package-grid">
                        <% int itemDelay = 0;
                           for (Package pkg : entry.getValue()) { 
                            // Get all images for the package
                            List<String> packageImages = new ArrayList<>();
                            
                            if (pkg.getPackageImages() != null && !pkg.getPackageImages().isEmpty()) {
                                String imgString = pkg.getPackageImages().get(0);
                                if (imgString.contains(",")) {
                                    String[] images = imgString.split(",");
                                    for (String img : images) {
                                        packageImages.add(img.trim());
                                    }
                                } else {
                                    packageImages.add(imgString.trim());
                                }
                            }
                            
                            // If no images available, use placeholder
                            if (packageImages.isEmpty()) {
                                packageImages.add("https://via.placeholder.com/400x250?text=No+Image");
                            }
                            
                            String packageId = String.valueOf(pkg.getPackageId());
                        %>
                            <div class="package-card" data-aos="fade-up" data-aos-delay="<%= itemDelay %>" 
                                 onclick="window.location.href='packageDetails.jsp?id=<%= pkg.getPackageId() %>'">
                                <div class="package-image-container">
                                    <div class="package-image-slider" id="slider-<%= packageId %>">
                                        <% for (int i = 0; i < packageImages.size(); i++) { %>
                                            <div class="package-image-slide">
                                                <img src="<%= packageImages.get(i) %>" class="package-image" alt="<%= pkg.getPackageName() %> image <%= i+1 %>">
                                            </div>
                                        <% } %>
                                    </div>
                                    
                                    <% if (packageImages.size() > 1) { %>
                                    <div class="slider-indicator">
                                        <% for (int i = 0; i < packageImages.size(); i++) { %>
                                            <div class="slider-dot <%= i == 0 ? "active" : "" %>" data-index="<%= i %>"></div>
                                        <% } %>
                                    </div>
                                    <% } %>
                                    
                                    <% if ("hot".equals(pkg.getStatus())) { %>
                                        <span class="badge badge-hot">HOT DEAL</span>
                                    <% } %>
                                </div>
                                <div class="package-info">
                                    <h5 class="package-title" title="<%= pkg.getPackageName() %>"><%= pkg.getPackageName() %></h5>
                                    <div class="package-location" title="<%= pkg.getDestination() %>">
                                        <i class="fas fa-map-marker-alt me-1"></i><%= pkg.getDestination() %>
                                    </div>
                                    <div class="package-meta">
                                        <span><i class="fas fa-calendar me-1"></i><%= pkg.getDuration() %> days</span>
                                        <span><i class="fas fa-users me-1"></i>Max <%= pkg.getMaxParticipants() %></span>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div class="package-price">$<%= String.format("%.2f", pkg.getPrice()) %></div>
                                        <a href="packageDetails.jsp?id=<%= pkg.getPackageId() %>" class="btn btn-primary btn-view" onclick="event.stopPropagation();">
                                            <i class="fas fa-eye me-1"></i> View
                                        </a>
                                    </div>
                                </div>
                            </div>
                        <% itemDelay += 100; } %>
                    </div>
                </div>
            <% categoryDelay += 200; } %>
        <% } %>
    <% } %>
    
    <!-- Travel Tips Section -->
    <div class="row mt-5 py-5" data-aos="fade-up" id="tips">
        <div class="col-12 text-center mb-4">
            <h2 class="section-title">Travel Tips & Inspiration</h2>
            <p class="section-subtitle">Make the most of your travel experience with these expert recommendations</p>
        </div>
        <div class="col-md-4 mb-4" data-aos="fade-up" data-aos-delay="100">
            <div class="card h-100 border-0 shadow-sm rounded-3">
                <div class="card-body p-4">
                    <div class="d-flex align-items-center mb-3">
                        <i class="fas fa-suitcase text-primary fa-2x me-3"></i>
                        <h5 class="mb-0">Pack Smart</h5>
                    </div>
                    <p class="card-text">Roll clothes instead of folding them to save space and reduce wrinkles. Pack versatile items that can be mixed and matched.</p>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-4" data-aos="fade-up" data-aos-delay="200">
            <div class="card h-100 border-0 shadow-sm rounded-3">
                <div class="card-body p-4">
                    <div class="d-flex align-items-center mb-3">
                        <i class="fas fa-globe-americas text-primary fa-2x me-3"></i>
                        <h5 class="mb-0">Learn Local Phrases</h5>
                    </div>
                    <p class="card-text">Knowing a few basic words in the local language can enhance your travel experience and help you connect with locals.</p>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-4" data-aos="fade-up" data-aos-delay="300">
            <div class="card h-100 border-0 shadow-sm rounded-3">
                <div class="card-body p-4">
                    <div class="d-flex align-items-center mb-3">
                        <i class="fas fa-camera text-primary fa-2x me-3"></i>
                        <h5 class="mb-0">Capture Memories</h5>
                    </div>
                    <p class="card-text">Take photos but also spend time experiencing the moment. Consider keeping a travel journal to record your adventures.</p>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Footer -->
<footer class="py-5">
    <div class="container">
        <div class="row">
            <div class="col-lg-4 col-md-6 mb-4 mb-md-0">
                <h5 class="text-uppercase mb-4" style="color: var(--secondary-color);">TourEase</h5>
                <p class="mb-4">Your gateway to extraordinary destinations and unforgettable experiences. Let us help you discover the world's hidden gems and create memories that last a lifetime.</p>
                <div class="d-flex">
                    <a href="#" class="btn btn-outline-light btn-floating me-2"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="btn btn-outline-light btn-floating me-2"><i class="fab fa-twitter"></i></a>
                    <a href="#" class="btn btn-outline-light btn-floating me-2"><i class="fab fa-instagram"></i></a>
                    <a href="#" class="btn btn-outline-light btn-floating"><i class="fab fa-pinterest"></i></a>
                </div>
            </div>
            <div class="col-lg-2 col-md-6 mb-4 mb-md-0">
                <h5 class="text-uppercase mb-4" style="color: var(--secondary-color);">Destinations</h5>
                <ul class="list-unstyled">
                    <li><a href="#" class="footer-link"><i class="fas fa-angle-right me-2"></i>Asia</a></li>
                    <li><a href="#" class="footer-link"><i class="fas fa-angle-right me-2"></i>Europe</a></li>
                    <li><a href="#" class="footer-link"><i class="fas fa-angle-right me-2"></i>Americas</a></li>
                    <li><a href="#" class="footer-link"><i class="fas fa-angle-right me-2"></i>Africa</a></li>
                    <li><a href="#" class="footer-link"><i class="fas fa-angle-right me-2"></i>Oceania</a></li>
                </ul>
            </div>
            <div class="col-lg-2 col-md-6 mb-4 mb-md-0">
                <h5 class="text-uppercase mb-4" style="color: var(--secondary-color);">Quick Links</h5>
                <ul class="list-unstyled">
                    <li><a href="#" class="footer-link"><i class="fas fa-angle-right me-2"></i>About Us</a></li>
                    <li><a href="#" class="footer-link"><i class="fas fa-angle-right me-2"></i>Contact</a></li>
                    <li><a href="#" class="footer-link"><i class="fas fa-angle-right me-2"></i>Privacy Policy</a></li>
                    <li><a href="#" class="footer-link"><i class="fas fa-angle-right me-2"></i>Terms of Service</a></li>
                    <li><a href="#" class="footer-link"><i class="fas fa-angle-right me-2"></i>FAQ</a></li>
                </ul>
            </div>
            <div class="col-lg-4 col-md-6 mb-4 mb-md-0">
                <h5 class="text-uppercase mb-4" style="color: var(--secondary-color);">Contact Us</h5>
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
        <hr class="my-4" style="background-color: rgba(255,255,255,0.2)">
        <div class="text-center">
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
    
    // Fixed image slider functionality
    document.addEventListener('DOMContentLoaded', function() {
        // Get all sliders
        const sliders = document.querySelectorAll('[id^="slider-"]');
        
        // Initialize each slider
        sliders.forEach(slider => {
            const slides = slider.querySelectorAll('.package-image-slide');
            if (slides.length <= 1) return; // Skip if only one image
            
            const dots = slider.parentElement.querySelectorAll('.slider-dot');
            const sliderId = slider.id;
            let currentIndex = 0;
            
            // Update slider position - Fixed function
            function updateSlider() {
                // Move the slider to show current image
                slider.style.transform = `translateX(-${currentIndex * 100}%)`;
                
                // Update active dot
                dots.forEach((dot, i) => {
                    if (i === currentIndex) {
                        dot.classList.add('active');
                    } else {
                        dot.classList.remove('active');
                    }
                });
            }
            
            // Auto-slide function
            function autoSlide() {
                currentIndex = (currentIndex + 1) % slides.length;
                updateSlider();
            }
            
            // Set interval for auto-sliding
            const intervalId = setInterval(autoSlide, 3000);
            
            // Store the interval ID with the slider
            slider.dataset.intervalId = intervalId;
            
            // Pause auto-sliding when mouse is over the slider
            slider.parentElement.addEventListener('mouseenter', () => {
                clearInterval(Number(slider.dataset.intervalId));
            });
            
            // Resume auto-sliding when mouse leaves the slider
            slider.parentElement.addEventListener('mouseleave', () => {
                const newIntervalId = setInterval(autoSlide, 3000);
                slider.dataset.intervalId = newIntervalId;
            });
            
            // Handle manual dot clicks
            dots.forEach((dot, index) => {
                dot.addEventListener('click', (event) => {
                    event.stopPropagation(); // Prevent card click
                    currentIndex = index;
                    updateSlider();
                });
            });
        });

        // Fix dropdown menu issues
        document.querySelectorAll('.dropdown-item').forEach(item => {
            item.addEventListener('click', function(e) {                // Prevent default only if handling this click programmatically
                if (this.classList.contains('custom-handler')) {
                    e.preventDefault();
                    window.location.href = this.getAttribute('href');
                }
                // For regular links, let the default behavior work
            });
        });
        
        // Ensure dropdown menu doesn't close immediately on click inside
        document.querySelector('.dropdown-menu').addEventListener('click', function(e) {
            e.stopPropagation();
        });
    });
</script>
</body>
</html>