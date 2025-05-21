package tourism.util;

import tourism.model.Booking;

import java.io.*;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;

public class BookingFileHandler {
    private final String BOOKING_FILE_PATH = "C:/temp/txt-project/bookings.txt";

    // Save a new booking to the TXT file
    public synchronized boolean saveBooking(Booking booking) {
        try {
            // System.out.println("DEBUG - BookingFileHandler.saveBooking() called with status: " + booking.getStatus());
            List<Booking> bookings = getAllBookings();
            
            // Check if booking already exists with same orderId
            for (Booking existingBooking : bookings) {
                if (existingBooking.getOrderId().equals(booking.getOrderId())) {
                    return false; // Order ID already exists
                }
            }
            
            // CRITICAL FIX: Always force new bookings to have "Pending" status
            // This ensures that even if other code tries to set a different status, it will be overridden here
            booking.setStatus("Pending");
            System.out.println("DEBUG - Final booking status before saving: " + booking.getStatus());
            
            // Add booking with the enforced status
            bookings.add(booking);
            boolean result = writeAllBookings(bookings);
            
            // Verify the booking was saved with the correct status by reading it back
            if (result) {
                Booking savedBooking = getBookingByOrderId(booking.getOrderId());
                if (savedBooking != null) {
                    System.out.println("DEBUG - Verified saved booking status: " + savedBooking.getStatus());
                }
            }
            
            return result;
        } catch (Exception e) {
            System.err.println("ERROR - Failed to save booking to file - " + e.getMessage() );
            return false;
        }
    }

    // Get all bookings from TXT file
    public List<Booking> getAllBookings() {
        List<Booking> bookings = new ArrayList<>();
        
        try {
            File file = new File(BOOKING_FILE_PATH);
            
            if (!file.exists()) {
                return bookings; // Return empty list if file doesn't exist
            }
            
            List<String> lines = Files.readAllLines(file.toPath());
            Booking currentBooking = null;
            boolean inRecord = false;
            
            for (String line : lines) {
                line = line.trim();
                
                if (line.isEmpty()) {
                    continue;
                }
                
                if (line.equals("--RECORD START--")) {
                    currentBooking = new Booking();
                    inRecord = true;
                    continue;
                } else if (line.equals("--RECORD END--")) {
                    if (currentBooking != null) {
                        bookings.add(currentBooking);
                    }
                    inRecord = false;
                    continue;
                }
                
                if (inRecord && currentBooking != null && line.contains(": ")) {
                    String[] parts = line.split(": ", 2);
                    String field = parts[0];
                    String value = parts.length > 1 ? parts[1] : "";
                    
                    switch (field) {
                        case "orderId":
                            currentBooking.setOrderId(value);
                            break;
                        case "username":
                            currentBooking.setUsername(value);
                            break;
                        case "packageId":
                            currentBooking.setPackageId(value);
                            break;
                        case "packageName":
                            currentBooking.setPackageName(value);
                            break;
                        case "amount":
                            currentBooking.setAmount(value);
                            break;
                        case "bookingDate":
                            currentBooking.setBookingDate(value);
                            break;
                        case "status":
                            currentBooking.setStatus(value);
                            break;
                        case "duration":
                            currentBooking.setDuration(value);
                            break;
                        case "destination":
                            currentBooking.setDestination(value);
                            break;
                        case "departureDate":
                            currentBooking.setDepartureDate(value);
                            break;
                        case "bookingType":
                            currentBooking.setBookingType(value);
                            break;
                        case "participants":
                            currentBooking.setParticipants(value);
                            break;
                        case "packageImage":
                            currentBooking.setPackageImage(value);
                            break;
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("ERROR - Failed to read bookings from file - " + e.getMessage() );
        }
        
        return bookings;
    }
    
    // Get all bookings for a specific user
    public List<Booking> getBookingsByUsername(String username) {
        List<Booking> userBookings = new ArrayList<>();
        List<Booking> allBookings = getAllBookings();
        
        for (Booking booking : allBookings) {
            if (booking.getUsername().equals(username)) {
                userBookings.add(booking);
            }
        }
        
        return userBookings;
    }
    
    // Get a booking by orderId
    public Booking getBookingByOrderId(String orderId) {
        List<Booking> bookings = getAllBookings();
        
        for (Booking booking : bookings) {
            if (booking.getOrderId().equals(orderId)) {
                return booking;
            }
        }
        
        return null;
    }
    
    // Update an existing booking
    public boolean updateBooking(Booking updatedBooking) {
        List<Booking> bookings = getAllBookings();
        
        for (int i = 0; i < bookings.size(); i++) {
            if (bookings.get(i).getOrderId().equals(updatedBooking.getOrderId())) {
                bookings.set(i, updatedBooking);
                return writeAllBookings(bookings);
            }
        }
        
        return false; // Booking not found
    }
    
    // Update booking status
    public boolean updateBookingStatus(String orderId, String newStatus) {
        Booking booking = getBookingByOrderId(orderId);
        if (booking != null) {
            booking.setStatus(newStatus);
            return updateBooking(booking);
        }
        return false;
    }
    
    // Delete a booking
    public boolean deleteBooking(String orderId) {
        List<Booking> bookings = getAllBookings();
        
        for (int i = 0; i < bookings.size(); i++) {
            if (bookings.get(i).getOrderId().equals(orderId)) {
                bookings.remove(i);
                return writeAllBookings(bookings);
            }
        }
        
        return false; // Booking not found
    }
    
    // Write all bookings to TXT file
    private boolean writeAllBookings(List<Booking> bookings) {
        try {
            // Ensure the directory exists
            File file = new File(BOOKING_FILE_PATH);
            file.getParentFile().mkdirs();
            
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(BOOKING_FILE_PATH))) {
                for (Booking booking : bookings) {
                    writer.write("--RECORD START--");
                    writer.newLine();
                    
                    writer.write("orderId: " + (booking.getOrderId() != null ? booking.getOrderId() : ""));
                    writer.newLine();
                    
                    writer.write("username: " + (booking.getUsername() != null ? booking.getUsername() : ""));
                    writer.newLine();
                    
                    writer.write("packageId: " + (booking.getPackageId() != null ? booking.getPackageId() : ""));
                    writer.newLine();
                    
                    writer.write("packageName: " + (booking.getPackageName() != null ? booking.getPackageName() : ""));
                    writer.newLine();
                    
                    writer.write("amount: " + (booking.getAmount() != null ? booking.getAmount() : ""));
                    writer.newLine();
                    
                    writer.write("bookingDate: " + (booking.getBookingDate() != null ? booking.getBookingDate() : ""));
                    writer.newLine();
                    
                    writer.write("status: " + (booking.getStatus() != null ? booking.getStatus() : ""));
                    writer.newLine();
                    
                    writer.write("duration: " + (booking.getDuration() != null ? booking.getDuration() : ""));
                    writer.newLine();
                    
                    writer.write("destination: " + (booking.getDestination() != null ? booking.getDestination() : ""));
                    writer.newLine();
                    
                    writer.write("departureDate: " + (booking.getDepartureDate() != null ? booking.getDepartureDate() : ""));
                    writer.newLine();
                    
                    writer.write("bookingType: " + (booking.getBookingType() != null ? booking.getBookingType() : ""));
                    writer.newLine();
                    
                    writer.write("participants: " + (booking.getParticipants() != null ? booking.getParticipants() : ""));
                    writer.newLine();
                    
                    writer.write("packageImage: " + (booking.getPackageImage() != null ? booking.getPackageImage() : ""));
                    writer.newLine();
                    
                    writer.write("--RECORD END--");
                    writer.newLine();
                    writer.newLine(); // Extra line for readability
                }
                
                // Debug check after writing
                System.out.println("DEBUG - Wrote " + bookings.size() + " bookings to file");
                
                return true;
            }
        } catch (IOException e) {
            System.err.println("ERROR - Failed to write bookings to file - " + e.getMessage() );
            return false;
        }
    }
}
