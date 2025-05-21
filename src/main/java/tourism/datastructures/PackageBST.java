package tourism.datastructures;

import tourism.model.Package;
import java.util.ArrayList;
import java.util.List;

public class PackageBST {
    private Node root;

    private class Node {
        Package data;
        Node left;
        Node right;

        public Node(Package data) {
            this.data = data;
            this.left = null;
            this.right = null;
        }
    }

    public PackageBST() {
        this.root = null;
    }

    // Insert a package into the BST by price
    public void insert(Package pkg) {
        root = insertRec(root, pkg);
    }

    private Node insertRec(Node root, Package pkg) {
        if (root == null) {
            return new Node(pkg);
        }

        if (pkg.getPrice() < root.data.getPrice()) {
            root.left = insertRec(root.left, pkg);
        } else if (pkg.getPrice() > root.data.getPrice()) {
            root.right = insertRec(root.right, pkg);
        } else {
            // If price is equal, update the package (or you could allow duplicates by ID)
            root.data = pkg;
        }

        return root;
    }

    // Search for a package by price (returns the first match)
    public Package search(double price) {
        return searchRec(root, price);
    }

    private Package searchRec(Node root, double price) {
        if (root == null) {
            return null;
        }

        if (price == root.data.getPrice()) {
            return root.data;
        }

        if (price < root.data.getPrice()) {
            return searchRec(root.left, price);
        } else {
            return searchRec(root.right, price);
        }
    }

    // Delete a package by price (removes the first match)
    public void delete(double price) {
        root = deleteRec(root, price);
    }

    private Node deleteRec(Node root, double price) {
        if (root == null) {
            return null;
        }

        if (price < root.data.getPrice()) {
            root.left = deleteRec(root.left, price);
        } else if (price > root.data.getPrice()) {
            root.right = deleteRec(root.right, price);
        } else {
            // Node with only one child or no child
            if (root.left == null) {
                return root.right;
            } else if (root.right == null) {
                return root.left;
            }

            // Node with two children: Get the inorder successor
            root.data = minValue(root.right);

            // Delete the inorder successor
            root.right = deleteRec(root.right, root.data.getPrice());
        }

        return root;
    }

    private Package minValue(Node root) {
        Package minValue = root.data;
        while (root.left != null) {
            minValue = root.left.data;
            root = root.left;
        }
        return minValue;
    }

    // In-order traversal to get all packages sorted by price
    public List<Package> getAllPackages() {
        List<Package> packages = new ArrayList<>();
        inorderTraversal(root, packages);
        return packages;
    }

    private void inorderTraversal(Node root, List<Package> packages) {
        if (root != null) {
            inorderTraversal(root.left, packages);
            packages.add(root.data);
            inorderTraversal(root.right, packages);
        }
    }

    // Build BST from a list of packages
    public void buildFromList(List<Package> packages) {
        root = null;
        if (packages == null) return;
        for (Package pkg : packages) {
            insert(pkg);
        }
    }
}
