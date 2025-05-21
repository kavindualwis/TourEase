package tourism.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Booking {
    private String orderId;
    private String username;
    private String packageId;
    private String packageName;
    private String amount;
    private String duration;
    private String destination;
    private String departureDate;
    private String bookingType;
    private String participants;
    private String packageImage;
    private String status;
    private String bookingDate;
    
    // Make sure the default constructor always sets "Pending" status
    public Booking() {
        // Set default values for new bookings
        this.status = "Pending";
        
        // Set booking date to current date and time
        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        this.bookingDate = now.format(formatter);
        
        // System.out.println("DEBUG - Booking constructor called, default status set to: " + this.status);
    }
    
    // Getters and Setters
    public String getOrderId() {
        return orderId;
    }
    
    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getPackageId() {
        return packageId;
    }
    
    public void setPackageId(String packageId) {
        this.packageId = packageId;
    }
    
    public String getPackageName() {
        return packageName;
    }
    
    public void setPackageName(String packageName) {
        this.packageName = packageName;
    }
    
    public String getAmount() {
        return amount;
    }
    
    public void setAmount(String amount) {
        this.amount = amount;
    }
    
    public String getDuration() {
        return duration;
    }
    
    public void setDuration(String duration) {
        this.duration = duration;
    }
    
    public String getDestination() {
        return destination;
    }
    
    public void setDestination(String destination) {
        this.destination = destination;
    }
    
    public String getDepartureDate() {
        return departureDate;
    }
    
    public void setDepartureDate(String departureDate) {
        this.departureDate = departureDate;
    }
    
    public String getBookingType() {
        return bookingType;
    }
    
    public void setBookingType(String bookingType) {
        this.bookingType = bookingType;
    }
    
    public String getParticipants() {
        return participants;
    }
    
    public void setParticipants(String participants) {
        this.participants = participants;
    }
    
    public String getPackageImage() {
        return packageImage;
    }
    
    public void setPackageImage(String packageImage) {
        this.packageImage = packageImage;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        // ADDITIONAL PROTECTION: If it's a new booking (with null orderId or no bookingDate), force "Pending" status
        if ((this.orderId == null || this.bookingDate == null) && !"Pending".equals(status)) {
            System.out.println("DEBUG - Preventing status override to: " + status + ", keeping it as 'Pending'");
            this.status = "Pending";
        } else {
            System.out.println("DEBUG - Setting booking status to: " + status + " for order ID: " + this.orderId);
            this.status = status;
        }
    }
    
    public String getBookingDate() {
        return bookingDate;
    }
    
    public void setBookingDate(String bookingDate) {
        this.bookingDate = bookingDate;
    }
}
