package tourism.servlet;

import tourism.model.Inquiry;
import tourism.util.InquiryFileHandler;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/editInquiry")
public class EditInquiryServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get parameters from the form
        String inquiryId = request.getParameter("inquiryId");
        String packageId = request.getParameter("packageId");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");
        String type = request.getParameter("type");
        String contactMethod = request.getParameter("contactMethod");
        
        // Create InquiryFileHandler instance
        InquiryFileHandler inquiryHandler = new InquiryFileHandler();
        
        // Get the inquiry to edit
        Inquiry inquiry = inquiryHandler.getInquiryById(inquiryId);
        
        // Update the inquiry if found
        boolean success = false;
        if (inquiry != null) {
            // Update the inquiry properties
            inquiry.setSubject(subject);
            inquiry.setMessage(message);
            inquiry.setType(type);
            inquiry.setContactMethod(contactMethod);
            
            // Save the updated inquiry
            success = inquiryHandler.updateInquiry(inquiry);
        }
        
        // Redirect back to the inquiries page with success/error parameter
        if (success) {
            response.sendRedirect("myInquiries.jsp?edited=true");
        } else {
            response.sendRedirect("myInquiries.jsp?edited=false");
        }
    }
}
