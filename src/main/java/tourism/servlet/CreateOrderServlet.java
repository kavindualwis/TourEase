package tourism.servlet;

import tourism.model.Booking;
import tourism.model.User;
import tourism.util.BookingFileHandler;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet(name = "CreateOrderServlet", urlPatterns = {"/createOrder"})
public class CreateOrderServlet extends HttpServlet {
    
    private BookingFileHandler bookingHandler;
    
    @Override
    public void init() throws ServletException {
        super.init();
        bookingHandler = new BookingFileHandler();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("CreateOrderServlet: doPost method called");
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check if user is logged in
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        
        // Get order details from form
        String orderId = request.getParameter("orderId");
        String packageId = request.getParameter("packageId");
        String packageName = request.getParameter("packageName");
        String amount = request.getParameter("amount");
        String duration = request.getParameter("duration");
        String destination = request.getParameter("destination");
        String departureDate = request.getParameter("departureDate");
        String bookingType = request.getParameter("bookingType");
        String participants = request.getParameter("participants");
        String packageImage = request.getParameter("packageImage");
        
        System.out.println("Received order: " + orderId + " for package: " + packageName);
        
        // Create new booking object
        Booking booking = new Booking();
        booking.setOrderId(orderId);
        booking.setUsername(user.getUsername());
        booking.setPackageId(packageId);
        booking.setPackageName(packageName);
        booking.setAmount(amount);
        booking.setDuration(duration);
        booking.setDestination(destination);
        booking.setDepartureDate(departureDate);
        booking.setBookingType(bookingType);
        booking.setParticipants(participants);
        booking.setPackageImage(packageImage);

        // Explicitly set status to "Pending" - this will override any default in the constructor
        booking.setStatus("Pending");

        System.out.println("DEBUG - Creating new booking with status: " + booking.getStatus());

        // Save booking to file using instance method
        boolean success = bookingHandler.saveBooking(booking);
        
        if (success) {
            // Set a success message in the session
            session.setAttribute("orderSuccess", true);
            session.setAttribute("orderId", orderId);
            
            // Redirect to My Trips page
            response.sendRedirect("myTrips.jsp");
        } else {
            // Set error message
            session.setAttribute("orderError", "Failed to process your booking. Please try again.");
            response.sendRedirect("dashboard.jsp");
        }
    }
}
