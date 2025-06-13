document.addEventListener("DOMContentLoaded", function () {
    const complaintForm = document.getElementById("complaintForm");
    const deleteBtn = complaintForm.querySelector("button[type='submit'][onclick*='confirmDelete']")
        || document.querySelector("button[type='submit'][onclick='return confirmDelete()']");

    function confirmDelete(event) {
        event.preventDefault();

        const complaintId = document.getElementById("complaintId").value.trim();
        if (complaintId.length === 0) {
            Swal.fire({
                icon: "error",
                title: "Please select a complaint first to delete.",
                showConfirmButton: true
            });
            return false;
        }

        Swal.fire({
            title: "Are you sure?",
            text: "You are about to delete this complaint.",
            icon: "warning",
            showCancelButton: true,
            confirmButtonText: "Yes, delete it!",
            cancelButtonText: "Cancel"
        }).then((result) => {
            if (result.isConfirmed) {
                document.getElementById('formAction').value = 'delete';
                complaintForm.submit();
            }
        });

        return false;
    }

    const deleteButton = document.getElementById("deleteBtn");
    if (deleteButton) {
        deleteButton.addEventListener("click", confirmDelete);
    }

    complaintForm.addEventListener("submit", function (event) {
        const title = document.getElementById("complaintTitle").value.trim();
        const description = document.getElementById("complaintDescription").value.trim();
        const action = document.getElementById("formAction").value;
        const complaintId = document.getElementById("complaintId").value.trim();

        if (action === "save" || action === "update") {
            if (title.length === 0 || description.length === 0) {
                Swal.fire({
                    icon: "warning",
                    title: "Please fill out all required fields.",
                    showConfirmButton: true
                });
                event.preventDefault();
                return false;
            }

            if (title.length < 5) {
                Swal.fire({
                    icon: "info",
                    title: "Title must be at least 5 characters.",
                    showConfirmButton: true
                });
                event.preventDefault();
                return false;
            }

            if (description.length < 10) {
                Swal.fire({
                    icon: "info",
                    title: "Description must be at least 10 characters.",
                    showConfirmButton: true
                });
                event.preventDefault();
                return false;
            }
        }

        if ((action === "update" || action === "delete") && complaintId.length === 0) {
            Swal.fire({
                icon: "error",
                title: "Please select a complaint first to " + action + ".",
                showConfirmButton: true
            });
            event.preventDefault();
            return false;
        }
    });
});

document.getElementById('clearBtn').addEventListener('click', function () {
    document.getElementById('complaintTitle').value = '';
    document.getElementById('complaintDescription').value = '';
    document.getElementById('complaintId').value = '';
    document.getElementById('formAction').value = 'save';
});


// Function to handle the complaint selection

function setAction(actionType) {
    document.getElementById('formAction').value = actionType;
}

function populateComplaintForm(id, title, description) {
    document.getElementById("complaintId").value = id;
    document.getElementById("complaintTitle").value = title;
    document.getElementById("complaintDescription").value = description;
    document.getElementById("formAction").value = "update";
}