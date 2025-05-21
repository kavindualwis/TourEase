package tourism.controller;

import tourism.model.Package;
import tourism.util.PackageFileHandler;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@WebServlet("/admin/packages/manage")
public class AdminPackageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PackageFileHandler packageHandler;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        packageHandler = new PackageFileHandler();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        
        String packageId = request.getParameter("id");
        
        if (packageId != null && !packageId.isEmpty()) {
            Package pkg = packageHandler.getPackageById(packageId);
            if (pkg != null) {
                response.getWriter().write(convertPackageToString(pkg));
            } else {
                sendErrorResponse(response, HttpServletResponse.SC_NOT_FOUND, "Package not found");
            }
        } else {
            List<Package> packages = packageHandler.getAllPackages();
            response.getWriter().write(convertPackageListToString(packages));
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        
        try {
            Package pkg = createPackageFromRequest(request);
            
            boolean success = packageHandler.savePackage(pkg);
            
            if (success) {
                sendSuccessResponse(response, "Package added successfully!", HttpServletResponse.SC_CREATED);
            } else {
                sendErrorResponse(response, HttpServletResponse.SC_CONFLICT, 
                                 "Package with ID " + pkg.getPackageId() + " already exists.");
            }
            
        } catch (Exception e) {
            sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Error adding package: " + e.getMessage());
            System.err.println("Error adding package: " + e.getMessage());
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        
        try {
            String formData = readRequestBody(request);
            System.out.println("PUT Request received with data: " + formData);
            
            Package updatedPackage = parsePackageFromFormData(formData);
            
            boolean success = packageHandler.updatePackage(updatedPackage);
            
            if (success) {
                sendSuccessResponse(response, "Package updated successfully!", HttpServletResponse.SC_OK);
            } else {
                sendErrorResponse(response, HttpServletResponse.SC_NOT_FOUND, 
                                 "Package not found or could not be updated.");
            }
            
        } catch (Exception e) {
            sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Error updating package: " + e.getMessage());
            System.err.println("Error updating package: " + e.getMessage());
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        
        try {
            String packageId = request.getParameter("id");
            
            System.out.println("DELETE Request received for package ID: " + packageId);
            
            if (packageId != null && !packageId.isEmpty()) {
                boolean success = packageHandler.deletePackage(packageId);
                
                if (success) {
                    sendSuccessResponse(response, "Package deleted successfully!", HttpServletResponse.SC_OK);
                } else {
                    sendErrorResponse(response, HttpServletResponse.SC_NOT_FOUND, 
                                     "Package not found or could not be deleted.");
                }
            } else {
                sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Package ID is required.");
            }
        } catch (Exception e) {
            sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Error deleting package: " + e.getMessage());
            System.err.println("Error deleting package: " + e.getMessage());
        }
    }
    
    // Helper method to convert a Package object to string format
    private String convertPackageToString(Package pkg) {
        StringBuilder result = new StringBuilder();
        
        result.append("Package ID: ").append(pkg.getPackageId()).append("\n");
        result.append("Name: ").append(pkg.getPackageName()).append("\n");
        result.append("Destination: ").append(pkg.getDestination()).append("\n");
        result.append("Category: ").append(pkg.getCategory()).append("\n");
        result.append("Duration: ").append(pkg.getDuration()).append("\n");
        result.append("Price: ").append(pkg.getPrice()).append("\n");
        result.append("Description: ").append(pkg.getDescription()).append("\n");
        result.append("Max Participants: ").append(pkg.getMaxParticipants()).append("\n");
        result.append("Departure Date: ").append(pkg.getDepartureDate()).append("\n");
        result.append("Status: ").append(pkg.getStatus()).append("\n");
        
        List<String> images = pkg.getPackageImages();
        result.append("Images: ");
        if (images != null && !images.isEmpty()) {
            result.append(String.join(", ", images));
        } else {
            result.append("None");
        }
        
        return result.toString();
    }
    
    // Helper method to convert a list of Package objects to string format
    private String convertPackageListToString(List<Package> packages) {
        StringBuilder result = new StringBuilder();
        
        result.append("Total Packages: ").append(packages.size()).append("\n\n");
        
        for (Package pkg : packages) {
            result.append(convertPackageToString(pkg)).append("\n\n");
        }
        
        return result.toString();
    }
    
    // New helper methods
    
    private void sendSuccessResponse(HttpServletResponse response, String message, int statusCode) throws IOException {
        response.setStatus(statusCode);
        response.getWriter().write(message);
    }
    
    private void sendErrorResponse(HttpServletResponse response, int statusCode, String message) throws IOException {
        response.setStatus(statusCode);
        response.getWriter().write(message);
    }
    
    private int parseIntParameter(String value, int defaultValue) {
        try {
            return (value != null && !value.trim().isEmpty()) ? Integer.parseInt(value.trim()) : defaultValue;
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
    
    private double parseDoubleParameter(String value, double defaultValue) {
        try {
            return (value != null && !value.trim().isEmpty()) ? Double.parseDouble(value.trim()) : defaultValue;
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
    
    private List<String> parseImageList(String imageString) {
        List<String> images = new ArrayList<>();
        if (imageString != null && !imageString.isEmpty()) {
            for (String url : imageString.split(",")) {
                if (url != null && !url.trim().isEmpty()) {
                    images.add(url.trim());
                }
            }
        }
        return images;
    }
    
    private Package createPackageFromRequest(HttpServletRequest request) {
        Package pkg = new Package();
        pkg.setPackageId(request.getParameter("packageId"));
        pkg.setPackageName(request.getParameter("packageName"));
        pkg.setDestination(request.getParameter("destination"));
        pkg.setCategory(request.getParameter("category"));
        pkg.setDuration(parseIntParameter(request.getParameter("duration"), 0));
        pkg.setPrice(parseDoubleParameter(request.getParameter("price"), 0.0));
        pkg.setDescription(request.getParameter("description"));
        pkg.setMaxParticipants(parseIntParameter(request.getParameter("maxParticipants"), 0));
        pkg.setDepartureDate(request.getParameter("departureDate"));
        pkg.setStatus(request.getParameter("status"));
        pkg.setPackageImages(parseImageList(request.getParameter("packageImage")));
        return pkg;
    }
    
    private String readRequestBody(HttpServletRequest request) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        return sb.toString();
    }
    
    private Package parsePackageFromFormData(String formData) throws IOException {
        Package pkg = new Package();
        List<String> images = new ArrayList<>();
        
        String[] params = formData.split("&");
        for (String param : params) {
            String[] pair = param.split("=");
            if (pair.length == 2) {
                String key = java.net.URLDecoder.decode(pair[0], "UTF-8");
                String value = java.net.URLDecoder.decode(pair[1], "UTF-8");
                
                switch (key) {
                    case "packageId": pkg.setPackageId(value); break;
                    case "packageName": pkg.setPackageName(value); break;
                    case "destination": pkg.setDestination(value); break;
                    case "category": pkg.setCategory(value); break;
                    case "duration": pkg.setDuration(parseIntParameter(value, 0)); break;
                    case "price": pkg.setPrice(parseDoubleParameter(value, 0.0)); break;
                    case "description": pkg.setDescription(value); break;
                    case "maxParticipants": pkg.setMaxParticipants(parseIntParameter(value, 0)); break;
                    case "departureDate": pkg.setDepartureDate(value); break;
                    case "status": pkg.setStatus(value); break;
                    case "packageImage": 
                        images = parseImageList(value);
                        break;
                }
            }
        }
        
        pkg.setPackageImages(images);
        return pkg;
    }
}
