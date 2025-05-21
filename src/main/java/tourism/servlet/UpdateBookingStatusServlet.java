package tourism.servlet;

import tourism.model.User;
import tourism.util.BookingFileHandler;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "UpdateBookingStatusServlet", urlPatterns = {"/api/updateBookingStatus"})
public class UpdateBookingStatusServlet extends HttpServlet {
    
    private BookingFileHandler bookingHandler;
    
    @Override
    public void init() throws ServletException {
        super.init();
        bookingHandler = new BookingFileHandler();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        
        // Check if user is logged in and is admin
        if (user == null || isAdmin == null || !isAdmin) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("Unauthorized access");
            return;
        }
        
        String orderId = request.getParameter("orderId");
        String newStatus = request.getParameter("status");
        
        // For debugging
        System.out.println("Received request to update booking status: " + orderId + " to " + newStatus);
        
        // Validate input parameters
        if (orderId == null || orderId.trim().isEmpty() || 
            newStatus == null || newStatus.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Missing required parameters");
            return;
        }
        
        // Validate status value
        if (!newStatus.equals("Completed") && 
            !newStatus.equals("Pending") && 
            !newStatus.equals("Cancelled") && 
            !newStatus.equals("Refunded")) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Invalid status value");
            return;
        }
        
        // Update booking status using instance method
        boolean success = bookingHandler.updateBookingStatus(orderId, newStatus);
        
        if (success) {
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("Status updated successfully");
            System.out.println("Booking status updated successfully for order: " + orderId);
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Failed to update status");
            System.out.println("Failed to update booking status for order: " + orderId);
        }
    }
}
