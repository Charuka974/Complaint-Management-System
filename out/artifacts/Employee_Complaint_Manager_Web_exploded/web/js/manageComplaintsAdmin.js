document.addEventListener("DOMContentLoaded", () => {
    const form = document.getElementById("complaintForm");
    const remarksInput = document.getElementById("complaintRemarks");
    const statusSelect = document.getElementById("complaintStatus");
    const formActionInput = document.getElementById("formAction");
    const complaintIdInput = document.getElementById("complaintId");

    const updateBtn = document.querySelector("button[onclick=\"setAction('update')\"]");
    const deleteBtn = document.querySelector("button[onclick=\"return confirmDelete()\"]");

    form.addEventListener("submit", function (e) {
        const action = formActionInput.value;

        if (action === "update") {
            const remarks = remarksInput.value.trim();
            const status = statusSelect.value;
            const complaintId = complaintIdInput.value;

            if (!complaintId) {
                e.preventDefault();
                Swal.fire({
                    icon: "warning",
                    title: "No complaint selected",
                    text: "Please select a complaint to update.",
                    showConfirmButton: true
                });
                return;
            }

            if (remarks === "") {
                e.preventDefault();
                Swal.fire({
                    icon: "warning",
                    title: "Remarks required",
                    text: "Please enter remarks before updating.",
                    showConfirmButton: true
                });
                return;
            }

            if (!["PENDING", "IN_PROGRESS", "RESOLVED"].includes(status)) {
                e.preventDefault();
                Swal.fire({
                    icon: "warning",
                    title: "Invalid status",
                    text: "Please select a valid complaint status.",
                    showConfirmButton: true
                });
            }
        }
    });

    deleteBtn?.addEventListener("click", function (e) {
        e.preventDefault();
        const complaintId = complaintIdInput.value;

        if (!complaintId) {
            Swal.fire({
                icon: "warning",
                title: "No complaint selected",
                text: "Please select a complaint to delete.",
                showConfirmButton: true
            });
            return;
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
                formActionInput.value = "delete";
                form.submit();
            }
        });
    });

    window.setAction = function (actionType) {
        formActionInput.value = actionType;
    };
});


// Function to set the action type for the form
function setAction(actionType) {
    document.getElementById('formAction').value = actionType;
}


// Function to confirm deletion
function confirmDelete() {
    Swal.fire({
        title: "Are you sure?",
        text: "You are about to delete this complaint.",
        icon: "warning",
        showCancelButton: true,
        confirmButtonText: "Yes, delete it!",
        cancelButtonText: "Cancel"
    }).then((result) => {
        if (result.isConfirmed) {
            // Set action and submit
            document.getElementById('formAction').value = 'delete';
            document.getElementById('complaintForm').submit();
        }
    });
    return false;
}

// Function to populate the complaint form with existing data
function populateComplaintForm(id, title, description, status, remarks) {
    document.getElementById("complaintId").value = id;
    document.getElementById("complaintTitle").value = title;
    document.getElementById("complaintDescription").value = description;
    document.getElementById("complaintRemarks").value = remarks;
    document.getElementById("complaintStatus").value = status;

    // Set the form action to 'update' to reflect intent
    document.getElementById("formAction").value = "update";
}