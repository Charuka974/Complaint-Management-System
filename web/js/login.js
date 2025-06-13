function toggleCard() {
    document.getElementById('flipCard').classList.toggle('flipped');
}

function validateLoginForm() {
    const email = document.getElementById("login-email").value.trim();
    const password = document.getElementById("login-password").value.trim();

    if (!email || !password) {
        Swal.fire({
            icon: "warning",
            title: "All fields are required",
            showConfirmButton: true
        });
        return false;
    }

    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailPattern.test(email)) {
        Swal.fire({
            icon: "warning",
            title: "Invalid email format",
            showConfirmButton: true
        });
        return false;
    }

    if (password.length < 4) {
        Swal.fire({
            icon: "warning",
            title: "Password must be at least 4 characters",
            showConfirmButton: true
        });
        return false;
    }

    return true;
}

function validateSignupForm() {
    const fullName = document.getElementById("fullName").value.trim();
    const email = document.getElementById("email").value.trim();
    const password = document.getElementById("newPassword").value.trim();
    const role = document.getElementById("role").value;

    if (!fullName || !email || !password || !role) {
        Swal.fire({
            icon: "warning",
            title: "All fields are required",
            showConfirmButton: true
        });
        return false;
    }

    if (fullName.length < 3) {
        Swal.fire({
            icon: "warning",
            title: "Name must be at least 3 characters",
            showConfirmButton: true
        });
        return false;
    }

    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailPattern.test(email)) {
        Swal.fire({
            icon: "warning",
            title: "Invalid email format",
            showConfirmButton: true
        });
        return false;
    }

    if (password.length < 4) {
        Swal.fire({
            icon: "warning",
            title: "Password must be at least 4 characters",
            showConfirmButton: true
        });
        return false;
    }

    if (role !== "EMPLOYEE" && role !== "ADMIN") {
        Swal.fire({
            icon: "warning",
            title: "Invalid role selected",
            showConfirmButton: true
        });
        return false;
    }

    return true;
}
