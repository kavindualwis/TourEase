package tourism.model;

import java.util.ArrayList;
import java.util.List;

public class Package {
    private String packageId;
    private String packageName;
    private String destination;
    private String category;
    private int duration;
    private double price;
    private String description;
    private int maxParticipants;
    private String departureDate;
    private List<String> packageImages;
    private String status;

    // Default constructor
    public Package() {
        this.packageImages = new ArrayList<>();
    }

    // Parameterized constructor
    public Package(String packageId, String packageName, String destination, String category,
                  int duration, double price, String description, int maxParticipants,
                  String departureDate, List<String> packageImages, String status) {
        this.packageId = packageId;
        this.packageName = packageName;
        this.destination = destination;
        this.category = category;
        this.duration = duration;
        this.price = price;
        this.description = description;
        this.maxParticipants = maxParticipants;
        this.departureDate = departureDate;
        this.packageImages = packageImages != null ? packageImages : new ArrayList<>();
        this.status = status;
    }

    // Getters and setters
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

    public String getDestination() {
        return destination;
    }

    public void setDestination(String destination) {
        this.destination = destination;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getMaxParticipants() {
        return maxParticipants;
    }

    public void setMaxParticipants(int maxParticipants) {
        this.maxParticipants = maxParticipants;
    }

    public String getDepartureDate() {
        return departureDate;
    }

    public void setDepartureDate(String departureDate) {
        this.departureDate = departureDate;
    }

    public List<String> getPackageImages() {
        return packageImages;
    }

    public void setPackageImages(List<String> packageImages) {
        this.packageImages = packageImages;
    }
    
    // Add a single image to the list
    public void addPackageImage(String imagePath) {
        if (this.packageImages == null) {
            this.packageImages = new ArrayList<>();
        }
        this.packageImages.add(imagePath);
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Package{" +
                "packageId='" + packageId + '\'' +
                ", packageName='" + packageName + '\'' +
                ", destination='" + destination + '\'' +
                ", category='" + category + '\'' +
                ", duration=" + duration +
                ", price=" + price +
                ", description='" + description + '\'' +
                ", maxParticipants=" + maxParticipants +
                ", departureDate='" + departureDate + '\'' +
                ", packageImages=" + packageImages +
                ", status='" + status + '\'' +
                '}';
    }
}
