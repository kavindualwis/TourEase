# 🌴 TourEase: Smart Tourism Package Platform

A **web-based Tourism Package Customization Platform** that allows users to browse, customize, and manage tourism packages dynamically. Built as a university project, this application serves both travelers and administrators with a comprehensive tourism management solution.

## 📋 Overview

TourEase streamlines the process of discovering, customizing, and booking travel packages. The system is built using **Java, JSP, Servlets** for the backend and **HTML, CSS, JavaScript** for the frontend, providing a responsive and intuitive experience.

## ✨ Features

### 🧳 For Travelers

- 🌍 **Browse Tourism Packages**: Explore a diverse range of destinations and experiences
- 🔍 **Search & Filter:** Find and filter tourism packages based on cost and preferences
- 🛠️ **Package Customization**: Tailor travel packages to match personal preferences and budget
- 📊 **User Dashboard**: Manage bookings, track inquiries, and update profile details
- 💬 **Inquiry System**: Submit questions about packages and receive timely responses
- 💳 **Secure Booking Process**: Straightforward reservation and payment workflow
- 📱 **Responsive Design**: Enjoy a seamless experience across all devices

### 👨‍💼 For Administrators

- 🏷️ **Package Management**: Add, edit, and remove tourism packages
- 👥 **User Management**: View and manage user accounts and permissions
- 📝 **Booking Overview**: Track and process booking requests
- ✉️ **Inquiry Handling**: Respond to user inquiries efficiently
- 📈 **Analytics Dashboard**: Monitor platform performance and sales metrics
- 🔒 **Secure Access:** Admin authentication to manage package data

## 🛠️ Technologies

- **Backend**: Java, JSP, Servlets
- **Frontend**: HTML5, CSS3, JavaScript
- **UI Framework**: Bootstrap 5
- **JavaScript Libraries**: jQuery, AOS Animation Library
- **Data Storage**: MySQL & File-based storage system
- **Algorithms Used**: Binary Search Tree (BST) & Quick Sort
- **Others**: Custom CSS animations, Form validations

## 🎯 Project Structure

```
TourEase/
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
└── README.md                          # Project documentation
```

## 🚀 Installation

1. **Clone the repository:**

   ```sh
   git clone https://github.com/kavindualwis/TourEase.git
   cd TourEase
   ```

2. **Set up your development environment**:

   - Install Java Development Kit (JDK) 11 or higher
   - Install Apache Tomcat 9.x
   - Configure your IDE for web development (Eclipse or IntelliJ IDEA recommended)

3. **Setup MySQL Database:**

   - Create a database named `tourism_db`
   - Import the provided SQL file in `database/` folder
   - Update `database.properties` with your database credentials

4. **Build and Deploy:**
   - Build the project using your IDE's build tools
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

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---
<p align="center">✨ Developed by Kavindu Alwis ✨</p>


