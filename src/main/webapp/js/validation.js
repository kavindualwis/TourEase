document.addEventListener('DOMContentLoaded', function() {
    // Login form validation
    const loginForm = document.getElementById('loginForm');
    if (loginForm) {
        loginForm.addEventListener('submit', function(event) {
            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;
            
            console.log('Login attempt: ' + username);

            if (!username || !password) {
                event.preventDefault();
                alert('Username and password are required.');
                return false;
            }

            return true;
        });
    }

    // Registration form validation
    const registerForm = document.getElementById('registerForm');
    if (registerForm) {
        registerForm.addEventListener('submit', function(event) {
            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const email = document.getElementById('email').value;
            const fullName = document.getElementById('fullName').value;

            if (!username || !password || !confirmPassword || !email || !fullName) {
                event.preventDefault();
                alert('All fields are required.');
                return false;
            }

            if (username.length < 4) {
                event.preventDefault();
                alert('Username must be at least 4 characters long.');
                return false;
            }

            if (password.length < 6) {
                event.preventDefault();
                alert('Password must be at least 6 characters long.');
                return false;
            }

            if (password !== confirmPassword) {
                event.preventDefault();
                alert('Passwords do not match.');
                return false;
            }

            // Basic email validation
            const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailPattern.test(email)) {
                event.preventDefault();
                alert('Please enter a valid email address.');
                return false;
            }

            return true;
        });
    }
});