package tourism.util;

import tourism.model.User;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

public class FileHandler {

    // Add Your location
    private final String USER_FILE_PATH = "___";

    // Adds a new user to the TXT file if the username doesn't already exist
    public synchronized boolean saveUser(User user) {
        try {
            List<User> users = getAllUsersWithPasswords();

            if (userExists(user.getUsername())) {
                return false;
            }

            users.add(user);
            return writeAllUsers(users);
        } catch (Exception e) {
            System.err.println("ERROR - Failed to save user to file - " + e.getMessage() );
            return false;
        }
    }

    // Checks if a user with the given username already exists
    public boolean userExists(String username) {
        List<User> users = getAllUsersWithPasswords();
        return users.stream().anyMatch(user -> user.getUsername().equals(username));
    }

    // Verifies user credentials and returns the user object if valid
    public User validateUser(String username, String password) {
        List<User> users = getAllUsersWithPasswords();

        for (User user : users) {
            if (user.getUsername().equals(username) &&
                user.getPassword() != null &&
                user.getPassword().equals(password)) {
                return user;
            }
        }
        return null;
    }

    // Retrieves all users from the TXT file without their passwords
    public List<User> getAllUsers() {
        List<User> users = getAllUsersWithPasswords();

        // Remove passwords for security
        for (User user : users) {
            user.setPassword(null);
        }

        return users;
    }

    // Retrieves all users with their passwords for internal authentication use only
    private List<User> getAllUsersWithPasswords() {
        List<User> users = new ArrayList<>();

        try {
            File file = new File(USER_FILE_PATH);

            if (!file.exists()) {
                return users;
            }

            List<String> lines = Files.readAllLines(file.toPath());
            User currentUser = null;
            boolean inRecord = false;

            for (String line : lines) {
                line = line.trim();

                if (line.equals("--RECORD START--")) {
                    currentUser = new User();
                    inRecord = true;
                    continue;
                } else if (line.equals("--RECORD END--")) {
                    if (currentUser != null) {
                        users.add(currentUser);
                    }
                    inRecord = false;
                    continue;
                }

                if (inRecord && currentUser != null && line.contains(": ")) {
                    String[] parts = line.split(": ", 2);
                    String field = parts[0];
                    String value = parts.length > 1 ? parts[1] : "";

                    switch (field) {
                        case "username":
                            currentUser.setUsername(value);
                            break;
                        case "password":
                            currentUser.setPassword(value);
                            break;
                        case "fullName":
                            currentUser.setFullName(value);
                            break;
                        case "email":
                            currentUser.setEmail(value);
                            break;
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("ERROR - Failed to read users from file - " + e.getMessage() );
        }

        return users;
    }

    // Finds and returns a user by their username
    public User getUserByUsername(String username) {
        List<User> users = getAllUsers();

        for (User user : users) {
            if (user.getUsername().equals(username)) {
                return user;
            }
        }

        return null;
    }

    // Removes a user from the TXT file
    public boolean deleteUser(String username) {
        List<User> users = getAllUsersWithPasswords();
        boolean found = users.removeIf(user -> user.getUsername().equals(username));

        if (found) {
            return writeAllUsers(users);
        }

        return false;
    }

    // Updates an existing user's information
    public boolean updateUser(User updatedUser) {
        List<User> users = getAllUsersWithPasswords();
        for (int i = 0; i < users.size(); i++) {
            if (users.get(i).getUsername().equals(updatedUser.getUsername())) {
                if (updatedUser.getPassword() == null && users.get(i).getPassword() != null) {
                    updatedUser.setPassword(users.get(i).getPassword());
                }
                users.set(i, updatedUser);
                return writeAllUsers(users);
            }
        }
        return false;
    }

    // Writes the complete list of users to the TXT file
    private boolean writeAllUsers(List<User> users) {
        try {
            File file = new File(USER_FILE_PATH);
            file.getParentFile().mkdirs();

            try (BufferedWriter writer = new BufferedWriter(new FileWriter(USER_FILE_PATH))) {
                for (User user : users) {
                    writer.write("--RECORD START--");
                    writer.newLine();

                    writer.write("username: " + (user.getUsername() != null ? user.getUsername() : ""));
                    writer.newLine();

                    writer.write("password: " + (user.getPassword() != null ? user.getPassword() : ""));
                    writer.newLine();

                    writer.write("fullName: " + (user.getFullName() != null ? user.getFullName() : ""));
                    writer.newLine();

                    writer.write("email: " + (user.getEmail() != null ? user.getEmail() : ""));
                    writer.newLine();

                    writer.write("--RECORD END--");
                    writer.newLine();
                    writer.newLine(); // Extra line for readability
                }
                return true;
            }
        } catch (IOException e) {
            System.err.println("ERROR - Failed to write users to file - " + e.getMessage() );
            return false;
        }
    }
}
