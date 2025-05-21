package tourism.util;

import tourism.model.Package;
import tourism.datastructures.PackageBST;

import java.io.*;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;

public class PackageFileHandler {

    // Add Your location
    private String PACKAGE_FILE_PATH = "___";
    
    // Get the file path
    public String getFilePath() {
        return PACKAGE_FILE_PATH;
    }

    // Save a new package to the TXT file (Create)
    public synchronized boolean savePackage(Package pkg) {
        try {
            List<Package> packages = getAllPackages();

            // Check if package exists
            for (Package existingPkg : packages) {
                if (existingPkg.getPackageId().equals(pkg.getPackageId())) {
                    return false;
                }
            }

            packages.add(pkg);

            // Use BST to sort 
            PackageBST bst = new PackageBST();
            bst.buildFromList(packages);
            List<Package> sortedPackages = bst.getAllPackages();

            return writeAllPackages(sortedPackages);
        } catch (Exception e) {
            System.err.println("Error saving package: " + e.getMessage());
            return false;
        }
    }

    // Get all packages from the TXT file (Read)
    public List<Package> getAllPackages() {
        List<Package> packages = new ArrayList<>();
        
        try {
            String filePath = getFilePath();
            File file = new File(filePath);
            
            if (!file.exists()) {
                return packages; 
            }
            
            List<String> lines = Files.readAllLines(file.toPath());
            Package currentPackage = null;
            List<String> currentImages = null;
            
            for (String line : lines) {
                line = line.trim();
                
                if (line.isEmpty()) {
                    continue;
                }
                
                if (line.startsWith("==PACKAGE==")) {
                    // Save previous package if it exists
                    if (currentPackage != null) {
                        packages.add(currentPackage);
                    }
                    
                    // Create new package
                    currentPackage = new Package();
                    currentImages = new ArrayList<>();
                    currentPackage.setPackageImages(currentImages);
                    continue;
                }
                
                if (currentPackage != null && line.contains(": ")) {
                    String[] parts = line.split(": ", 2);
                    String field = parts[0];
                    String value = parts.length > 1 ? parts[1] : "";
                    
                    switch (field) {
                        case "packageId":
                            currentPackage.setPackageId(value);
                            break;
                        case "packageName":
                            currentPackage.setPackageName(value);
                            break;
                        case "destination":
                            currentPackage.setDestination(value);
                            break;
                        case "category":
                            currentPackage.setCategory(value);
                            break;
                        case "duration":
                            try {
                                currentPackage.setDuration(Integer.parseInt(value));
                            } catch (NumberFormatException e) {
                                currentPackage.setDuration(0);
                            }
                            break;
                        case "price":
                            try {
                                currentPackage.setPrice(Double.parseDouble(value));
                            } catch (NumberFormatException e) {
                                currentPackage.setPrice(0.0);
                            }
                            break;
                        case "description":
                            currentPackage.setDescription(value);
                            break;
                        case "maxParticipants":
                            try {
                                currentPackage.setMaxParticipants(Integer.parseInt(value));
                            } catch (NumberFormatException e) {
                                currentPackage.setMaxParticipants(0);
                            }
                            break;
                        case "departureDate":
                            currentPackage.setDepartureDate(value);
                            break;
                        case "status":
                            currentPackage.setStatus(value);
                            break;
                        case "image":
                            if (value != null && !value.isEmpty()) {
                                currentImages.add(value);
                            }
                            break;
                    }
                }
            }
            
            // Add the last package if it exists
            if (currentPackage != null) {
                packages.add(currentPackage);
            }
        } catch (Exception e) {
            System.err.println("Error reading packages: " + e.getMessage());
        }
        
        return packages;
    }

    // Get a package by ID (Read)
    public Package getPackageById(String packageId) {
        List<Package> packages = getAllPackages();
        for (Package pkg : packages) {
            if (pkg.getPackageId().equals(packageId)) {
                return pkg;
            }
        }
        return null;
    }

    // Update an existing package (Update)
    public boolean updatePackage(Package updatedPackage) {
        List<Package> packages = getAllPackages();
        boolean found = false;
        
        for (int i = 0; i < packages.size(); i++) {
            if (packages.get(i).getPackageId().equals(updatedPackage.getPackageId())) {
                packages.set(i, updatedPackage);
                found = true;
                break;
            }
        }
        
        if (found) {
            // Use BST to sort by price before saving
            PackageBST bst = new PackageBST();
            bst.buildFromList(packages);
            List<Package> sortedPackages = bst.getAllPackages();

            return writeAllPackages(sortedPackages);
        }
        
        return false;
    }

    // Delete a package (Delete)
    public boolean deletePackage(String packageId) {
        List<Package> packages = getAllPackages();
        boolean removed = packages.removeIf(pkg -> pkg.getPackageId().equals(packageId));
        
        if (removed) {
            // Use BST to sort by price before saving
            PackageBST bst = new PackageBST();
            bst.buildFromList(packages);
            List<Package> sortedPackages = bst.getAllPackages();

            return writeAllPackages(sortedPackages);
        }
        
        return false;
    }

    // Write all packages to the TXT file
    private boolean writeAllPackages(List<Package> packages) {
        try {
            String filePath = getFilePath();
            File file = new File(filePath);
            File parent = file.getParentFile();
            if (parent != null && !parent.exists()) {
                parent.mkdirs();
            }
            
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
                for (Package pkg : packages) {
                    writer.write("==PACKAGE==");
                    writer.newLine();
                    
                    writer.write("packageId: " + (pkg.getPackageId() != null ? pkg.getPackageId() : ""));
                    writer.newLine();
                    
                    writer.write("packageName: " + (pkg.getPackageName() != null ? pkg.getPackageName() : ""));
                    writer.newLine();
                    
                    writer.write("destination: " + (pkg.getDestination() != null ? pkg.getDestination() : ""));
                    writer.newLine();
                    
                    writer.write("category: " + (pkg.getCategory() != null ? pkg.getCategory() : ""));
                    writer.newLine();
                    
                    writer.write("duration: " + pkg.getDuration());
                    writer.newLine();
                    
                    writer.write("price: " + pkg.getPrice());
                    writer.newLine();
                    
                    writer.write("description: " + (pkg.getDescription() != null ? pkg.getDescription() : ""));
                    writer.newLine();
                    
                    writer.write("maxParticipants: " + pkg.getMaxParticipants());
                    writer.newLine();
                    
                    writer.write("departureDate: " + (pkg.getDepartureDate() != null ? pkg.getDepartureDate() : ""));
                    writer.newLine();
                    
                    writer.write("status: " + (pkg.getStatus() != null ? pkg.getStatus() : ""));
                    writer.newLine();
                    
                    // Write images 
                    List<String> images = pkg.getPackageImages();
                    if (images != null) {
                        for (String image : images) {
                            writer.write("image: " + image);
                            writer.newLine();
                        }
                    }
                    
                    writer.newLine(); 
                }
                return true;
            }
        } catch (IOException e) {
            System.err.println("Error writing packages: " + e.getMessage());
            return false;
        }
    }
}