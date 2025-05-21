package tourism.util;

import tourism.model.Inquiry;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class InquiryFileHandler {
    private final String INQUIRY_FILE_PATH = "C:/temp/txt-project/inquiries.txt";

    // Get all inquiries from the TXT file
    public List<Inquiry> getAllInquiries() {
        List<Inquiry> inquiries = new ArrayList<>();

        try {
            File file = new File(INQUIRY_FILE_PATH);

            if (!file.exists()) {
                // Create an empty file if it doesn't exist
                Files.createDirectories(Paths.get("C:/temp"));
                try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
                    writer.write(""); // Create empty file
                }
                return inquiries;
            }

            List<String> lines = Files.readAllLines(file.toPath());
            //Tempory variables
            Inquiry currentInquiry = null;
            boolean inRecord = false;

            //For each loop
            for (String line : lines) {
                line = line.trim();
                
                if (line.isEmpty()) {
                    continue;
                }
                
                if (line.equals("--RECORD START--")) {

                    //Object Creaetion
                    currentInquiry = new Inquiry();
                    inRecord = true;
                    continue;
                } else if (line.equals("--RECORD END--")) {
                    if (currentInquiry != null) {
                        inquiries.add(currentInquiry);
                    }
                    inRecord = false;
                    continue;
                }
                
                if (inRecord && currentInquiry != null && line.contains(": ")) {

                    //Array
                    String[] parts = line.split(": ", 2);
                    String field = parts[0];

                    //Ternary Operator
                    String value = parts.length > 1 ? parts[1] : "";
                    
                    switch (field) {
                        case "id":
                            currentInquiry.setId(value);
                            break;
                        case "username":
                            currentInquiry.setUsername(value);
                            break;
                        case "userFullName":
                            currentInquiry.setUserFullName(value);
                            break;
                        case "packageId":
                            currentInquiry.setPackageId(value);
                            break;
                        case "packageName":
                            currentInquiry.setPackageName(value);
                            break;
                        case "subject":
                            currentInquiry.setSubject(value);
                            break;
                        case "message":
                            currentInquiry.setMessage(value);
                            break;
                        case "type":
                            currentInquiry.setType(value);
                            break;
                        case "contactMethod":
                            currentInquiry.setContactMethod(value);
                            break;
                        case "responseMessage":
                            currentInquiry.setResponseMessage(value);
                            break;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return inquiries;
    }

    // Get inquiries by username
    public List<Inquiry> getInquiriesByUsername(String username) {
        List<Inquiry> allInquiries = getAllInquiries();
        List<Inquiry> userInquiries = new ArrayList<>();
        
        for (Inquiry inquiry : allInquiries) {
            if (inquiry.getUsername() != null && inquiry.getUsername().equals(username)) {
                userInquiries.add(inquiry);
            }
        }
        
        return userInquiries;
    }

    // Save a new inquiry (Create)
    public synchronized boolean saveInquiry(Inquiry inquiry) {
        try {
            List<Inquiry> inquiries = getAllInquiries();
            
            // Check if inquiry has an ID, if not, generate one
            if (inquiry.getId() == null || inquiry.getId().trim().isEmpty()) {
                inquiry.setId(generateUniqueId());
            }
            
            inquiries.add(inquiry);
            return writeAllInquiries(inquiries);
        } catch (Exception e) {
            System.err.println("ERROR - Failed to save inquiry to file - " + e.getMessage() );
            return false;
        }
    }

    // Get a specific inquiry by ID
    public Inquiry getInquiryById(String inquiryId) {
        List<Inquiry> inquiries = getAllInquiries();
        
        for (Inquiry inquiry : inquiries) {
            if (inquiry.getId() != null && inquiry.getId().equals(inquiryId)) {
                return inquiry;
            }
        }
        
        return null;
    }

    // Delete an inquiry by ID
    public boolean deleteInquiry(String inquiryId) {
        List<Inquiry> inquiries = getAllInquiries();
        boolean removed = false;
        
        for (int i = 0; i < inquiries.size(); i++) {
            if (inquiries.get(i).getId() != null && inquiries.get(i).getId().equals(inquiryId)) {
                inquiries.remove(i);
                removed = true;
                break;
            }
        }
        
        if (removed) {
            return writeAllInquiries(inquiries);
        }
        
        return false;
    }

    // Add response to an inquiry
    public boolean addResponse(String inquiryId, String responseMessage) {
        List<Inquiry> inquiries = getAllInquiries();
        
        for (Inquiry inquiry : inquiries) {
            if (inquiry.getId() != null && inquiry.getId().equals(inquiryId)) {
                inquiry.setResponseMessage(responseMessage);
                return writeAllInquiries(inquiries);
            }
        }
        
        return false;
    }

    // Update an existing inquiry
    public boolean updateInquiry(Inquiry inquiry) {
        if (inquiry == null || inquiry.getId() == null) {
            System.out.println("Error: Cannot update null inquiry or inquiry without ID");
            return false;
        }

        try {
            System.out.println("=== DEBUG: updateInquiry ===");
            System.out.println("Trying to update inquiry with ID: " + inquiry.getId());
            
            List<Inquiry> allInquiries = getAllInquiries();
            boolean found = false;
            
            System.out.println("Total inquiries found: " + allInquiries.size());
            
            for (int i = 0; i < allInquiries.size(); i++) {
                Inquiry current = allInquiries.get(i);
                if (current.getId() != null && current.getId().equals(inquiry.getId())) {
                    System.out.println("Found matching inquiry at index: " + i);
                    
                    // Preserve fields that shouldn't be updated
                    String originalPackageId = current.getPackageId();
                    String originalPackageName = current.getPackageName();
                    String originalUsername = current.getUsername();
                    String originalUserFullName = current.getUserFullName();
                    String originalResponse = current.getResponseMessage();
                    
                    // Check if packageId is null or empty in the update object
                    if (inquiry.getPackageId() == null || inquiry.getPackageId().trim().isEmpty()) {
                        inquiry.setPackageId(originalPackageId);
                        System.out.println("Using original packageId: " + originalPackageId);
                    }
                    
                    inquiry.setPackageName(originalPackageName);
                    inquiry.setUsername(originalUsername);
                    inquiry.setUserFullName(originalUserFullName);
                    inquiry.setResponseMessage(originalResponse);
                    
                    // Update in the list
                    allInquiries.set(i, inquiry);
                    found = true;
                    System.out.println("Updated inquiry in list");
                    break;
                }
            }
            
            if (!found) {
                System.out.println("Error: Inquiry with ID " + inquiry.getId() + " not found for update");
                return false;
            }
            
            // Write all inquiries to file
            System.out.println("Writing updated inquiries to file...");
            boolean writeResult = writeAllInquiries(allInquiries);
            System.out.println("Write result: " + writeResult);
            
            return writeResult;
        } catch (Exception e) {
            System.out.println("Error updating inquiry: " + e.getMessage());
            return false;
        }
    }

    // Write all inquiries to the TXT file
    private boolean writeAllInquiries(List<Inquiry> inquiries) {
        try {
            File file = new File(INQUIRY_FILE_PATH);
            Files.createDirectories(file.getParentFile().toPath());

            try (BufferedWriter writer = new BufferedWriter(new FileWriter(INQUIRY_FILE_PATH))) {
                for (Inquiry inquiry : inquiries) {
                    writer.write("--RECORD START--");
                    writer.newLine();
                    
                    writer.write("id: " + (inquiry.getId() != null ? inquiry.getId() : ""));
                    writer.newLine();
                    
                    writer.write("username: " + (inquiry.getUsername() != null ? inquiry.getUsername() : ""));
                    writer.newLine();
                    
                    writer.write("userFullName: " + (inquiry.getUserFullName() != null ? inquiry.getUserFullName() : ""));
                    writer.newLine();
                    
                    writer.write("packageId: " + (inquiry.getPackageId() != null ? inquiry.getPackageId() : ""));
                    writer.newLine();
                    
                    writer.write("packageName: " + (inquiry.getPackageName() != null ? inquiry.getPackageName() : ""));
                    writer.newLine();
                    
                    writer.write("subject: " + (inquiry.getSubject() != null ? inquiry.getSubject() : ""));
                    writer.newLine();
                    
                    // For multi-line message, keep it as a single line with explicit replacements
                    String messageContent = inquiry.getMessage() != null ? inquiry.getMessage().replace("\n", "\\n").replace("\r", "") : "";
                    writer.write("message: " + messageContent);
                    writer.newLine();
                    
                    writer.write("type: " + (inquiry.getType() != null ? inquiry.getType() : ""));
                    writer.newLine();
                    
                    writer.write("contactMethod: " + (inquiry.getContactMethod() != null ? inquiry.getContactMethod() : ""));
                    writer.newLine();
                    
                    // Response message, which may also be multi-line
                    String responseContent = inquiry.getResponseMessage() != null ? inquiry.getResponseMessage().replace("\n", "\\n").replace("\r", "") : "";
                    writer.write("responseMessage: " + responseContent);
                    writer.newLine();
                    
                    writer.write("--RECORD END--");
                    writer.newLine();
                    writer.newLine(); // Extra line for readability
                }
                return true;
            }
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Generate a unique ID for new inquiries
    private String generateUniqueId() {
        return "INQ" + UUID.randomUUID().toString().substring(0, 6).toUpperCase();
    }
}
