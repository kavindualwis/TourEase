# TourEase: Smart Tourism Package Platform

## 📋 Overview

TourEase is a comprehensive tourism management platform designed to streamline the process of discovering, customizing, and booking travel packages. Built as a university project, this application serves both travelers looking for their next adventure and administrators managing tourism offerings.

## ✨ Features

### For Travelers

- **Browse Tourism Packages**: Explore a diverse range of destinations and experiences
- **Package Customization**: Tailor travel packages to match personal preferences and budget
- **User Dashboard**: Manage bookings, track inquiries, and update profile details
- **Inquiry System**: Submit questions about packages and receive timely responses
- **Secure Booking Process**: Straightforward reservation and payment workflow
- **Responsive Design**: Enjoy a seamless experience across all devices

### For Administrators

- **Package Management**: Add, edit, and remove tourism packages
- **User Management**: View and manage user accounts and permissions
- **Booking Overview**: Track and process booking requests
- **Inquiry Handling**: Respond to user inquiries efficiently
- **Analytics Dashboard**: Monitor platform performance and sales metrics

## 🛠️ Technologies

- **Backend**: Java
- **Frontend**: JSP (JavaServer Pages), HTML5, CSS3
- **UI Framework**: Bootstrap 5
- **JavaScript Libraries**: jQuery, AOS Animation Library
- **Data Storage**: File-based storage system
- **Others**: Custom CSS animations, Form validations

## 🚀 Installation

1. **Clone the repository**:

   ```
   git clone https://github.com/kavindualwis/TourEase.git
   ```

2. **Set up your development environment**:

   - Install Java Development Kit (JDK) 11 or higher
   - Install Apache Tomcat 9.x
   - Configure your IDE for web development (Eclipse or IntelliJ IDEA recommended)

3. **Build the project**:

   - Import the project into your IDE
   - Update dependencies if required
   - Build the project using your IDE's build tools

4. **Deploy the application**:
   - Deploy to Tomcat server
   - Access via http://localhost:8080/tourease

## 💻 Usage

### For Travelers:

1. Register an account or log in
2. Browse available packages on the homepage
3. View package details by clicking on a package card
4. Submit inquiries for more information
5. Customize and book packages through the booking form
6. Track bookings and inquiries from your dashboard

### For Administrators:

1. Access the admin portal via /admin route
2. Log in with admin credentials
3. Use the dashboard to manage packages, users, and bookings
4. Respond to inquiries through the inquiry management panel
5. Add new packages using the package creation form

## 📁 Project Structure

```
tourease/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       └── tourease/
│   │   │           ├── controllers/   # Servlet controllers
│   │   │           ├── models/        # Java beans and business logic
│   │   │           ├── utils/         # Utility classes
│   │   │           └── dao/           # Data Access Objects
│   │   └── webapp/
│   │       ├── WEB-INF/               # Web application configuration
│   │       │   └── web.xml            # Deployment descriptor
│   │       ├── admin/                 # Admin portal pages
│   │       ├── user/                  # User account pages
│   │       ├── css/                   # Stylesheets
│   │       ├── js/                    # JavaScript files
│   │       ├── images/                # Image resources
│   │       └── *.jsp                  # JSP pages
│   └── test/
│       └── java/
│           └── com/
│               └── tourease/          # Test cases
├── data/                              # File storage for application data
├── pom.xml                            # Maven configuration
└── README.md                          # Project documentation
```

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

<p align="center">Developed with ❤️ as part of OOP Course Project</p>
