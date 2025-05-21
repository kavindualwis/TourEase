package tourism.servlet;

import tourism.model.Inquiry;
import tourism.model.User;
import tourism.util.InquiryFileHandler;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "InquiryServlet", urlPatterns = {"/submitInquiry", "/deleteInquiry", "/respondToInquiry"})
public class InquiryServlet extends HttpServlet {
    
    private InquiryFileHandler inquiryHandler;
    
    @Override
    public void init() throws ServletException {
        super.init();
        inquiryHandler = new InquiryFileHandler();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        
        // Set response content type
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        
        if ("/submitInquiry".equals(path)) {
            handleSubmitInquiry(request, response);
        } else if ("/deleteInquiry".equals(path)) {
            handleDeleteInquiry(request, response);
        } else if ("/respondToInquiry".equals(path)) {
            handleRespondToInquiry(request, response);
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("Unknown endpoint: " + path);
        }
    }

    private void handleSubmitInquiry(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("User not logged in");
            return;
        }

        try {
            Inquiry inquiry = new Inquiry();
            inquiry.setPackageId(request.getParameter("packageId"));
            inquiry.setPackageName(request.getParameter("packageName"));
            inquiry.setUsername(user.getUsername());
            inquiry.setUserFullName(user.getFullName());
            inquiry.setSubject(request.getParameter("subject"));
            inquiry.setMessage(request.getParameter("message"));
            inquiry.setType(request.getParameter("type"));
            inquiry.setContactMethod(request.getParameter("contactMethod"));

            boolean success = inquiryHandler.saveInquiry(inquiry);

            if (success) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("Inquiry submitted successfully");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("Failed to save inquiry");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("An error occurred: " + e.getMessage());
        }
    }
    
    private void handleDeleteInquiry(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        
        String inquiryId = request.getParameter("inquiryId");
        
        Inquiry inquiry = inquiryHandler.getInquiryById(inquiryId);
        
        if (inquiry == null) {
            response.sendRedirect("myInquiries.jsp?error=notfound");
            return;
        }
        
        if (user == null || (!(inquiry.getUsername().equals(user.getUsername())) && !Boolean.TRUE.equals(isAdmin))) {
            response.sendRedirect("myInquiries.jsp?error=unauthorized");
            return;
        }
        
        boolean success = inquiryHandler.deleteInquiry(inquiryId);
        
        if (Boolean.TRUE.equals(isAdmin)) {
            response.sendRedirect("admin/inquiries.jsp?deleted=" + success);
        } else {
            response.sendRedirect("myInquiries.jsp?deleted=" + success);
        }
    }
    
    private void handleRespondToInquiry(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        
        if (user == null || !Boolean.TRUE.equals(isAdmin)) {
            response.sendRedirect("login");
            return;
        }
        
        String inquiryId = request.getParameter("inquiryId");
        String responseMessage = request.getParameter("responseMessage");
        
        boolean success = inquiryHandler.addResponse(inquiryId, responseMessage);
        
        response.sendRedirect("admin/inquiries.jsp?responded=" + success);
    }
}
