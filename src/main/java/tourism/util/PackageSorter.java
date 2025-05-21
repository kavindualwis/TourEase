package tourism.util;

import tourism.model.Package;
import java.util.List;

public class PackageSorter {
    
    /**
     * Sorts packages by price using QuickSort algorithm
     * @param packages List of packages to sort
     * @param ascending true for ascending order, false for descending
     */
    public static void sortByPrice(List<Package> packages, boolean ascending) {
        if (packages == null || packages.size() <= 1) {
            return; // Already sorted or empty
        }
        quickSort(packages, 0, packages.size() - 1, ascending);
    }
    
    private static void quickSort(List<Package> packages, int low, int high, boolean ascending) {
        if (low < high) {
            int partitionIndex = partition(packages, low, high, ascending);
            quickSort(packages, low, partitionIndex - 1, ascending);
            quickSort(packages, partitionIndex + 1, high, ascending);
        }
    }
    
    private static int partition(List<Package> packages, int low, int high, boolean ascending) {
        // Using the high element as pivot
        double pivot = packages.get(high).getPrice();
        int i = low - 1; // Index of smaller element
        
        for (int j = low; j < high; j++) {
            // For ascending: swap if current <= pivot
            // For descending: swap if current >= pivot
            boolean shouldSwap;
            if (ascending) {
                shouldSwap = packages.get(j).getPrice() <= pivot;
            } else {
                shouldSwap = packages.get(j).getPrice() >= pivot;
            }
                
            if (shouldSwap) {
                i++;
                // Swap packages[i] and packages[j]
                Package temp = packages.get(i);
                packages.set(i, packages.get(j));
                packages.set(j, temp);
            }
        }
        
        // Swap packages[i+1] and packages[high] (or the pivot)
        Package temp = packages.get(i + 1);
        packages.set(i + 1, packages.get(high));
        packages.set(high, temp);
        
        return i + 1;
    }
}
