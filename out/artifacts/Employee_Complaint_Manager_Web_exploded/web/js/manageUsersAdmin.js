document.addEventListener("DOMContentLoaded", () => {
    const searchForm = document.getElementById("searchUserForm");
    const deleteForm = document.getElementById("deleteUserForm");
    const deleteUserBtn = document.getElementById("deleteUserBtn");

    searchForm.addEventListener("submit", function (event) {
        const name = document.getElementById("userNameInput").value.trim();
        const email = document.getElementById("userEmailInput").value.trim();

        if (name === "" && email === "") {
            event.preventDefault(); // Stop form from submitting immediately

            Swal.fire({
                icon: "info",
                title: "No input provided",
                text: "Loading all users...",
                timer: 1200,
                showConfirmButton: false
            }).then(() => {
                searchForm.submit(); // Submit after alert is closed
            });
        }
    });

    deleteUserBtn.addEventListener("click", function () {
        const userId = document.getElementById("deleteUserId").value;
        if (!userId) {
            Swal.fire({
                icon: "warning",
                title: "Please select a user to delete.",
                showConfirmButton: true
            });
            return;
        }

        Swal.fire({
            title: "Are you sure?",
            text: "This action cannot be undone.",
            icon: "warning",
            showCancelButton: true,
            confirmButtonText: "Yes, delete!",
            cancelButtonText: "Cancel"
        }).then((result) => {
            if (result.isConfirmed) {
                deleteForm.submit();
            }
        });
    });
});


// Function to select a user and populate the form fields
function selectUser(id, name, email) {
    document.getElementById("userIdInput").value = id;
    document.getElementById("userNameInput").value = name;
    document.getElementById("userEmailInput").value = email;
    document.getElementById("deleteUserId").value = id;
}

/// Function to handle the delete button click
document.getElementById("deleteUserBtn").addEventListener("click", function () {
    const userId = document.getElementById("deleteUserId").value;
    if (!userId) {
        Swal.fire({
            icon: "warning",
            title: "Please select a user to delete.",
            showConfirmButton: true
        });
        return;
    }

    Swal.fire({
        title: "Are you sure?",
        text: "This action cannot be undone.",
        icon: "warning",
        showCancelButton: true,
        confirmButtonText: "Yes, delete!",
        cancelButtonText: "Cancel"
    }).then((result) => {
        if (result.isConfirmed) {
            document.getElementById("deleteUserForm").submit();
        }
    });
});
