## Data Import/Export Reference

This document outlines how the frontend can interact with the backend API for data import and export functionalities. All requests requiring authentication must include your JWT token in the `Authorization` header as `Bearer <your_jwt_token>`.

### Exporting Data

YouYou can export data by making GET requests to the following endpoints. The response will be a ZIP file, which your frontend should handle as a file download.

1.  **Export All Data (Admin Only):**
    *   **Endpoint:** `GET /api/Data/export`
    *   **Description:** Exports all system data. Requires an Admin role.
    *   **Example (JavaScript `fetch`):**
        ```javascript
        fetch('/api/Data/export', {
            method: 'GET',
            headers: {
                'Authorization': 'Bearer YOUR_JWT_TOKEN_HERE'
            }
        })
        .then(response => {
            if (response.ok) {
                return response.blob(); // Get the response as a Blob
            }
            throw new Error('Network response was not ok.');
        })
        .then(blob => {
            // Create a URL for the blob and trigger a download
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = 'LunaArcSync_AllData_Export.zip';
            document.body.appendChild(a);
            a.click();
            a.remove();
            window.URL.revokeObjectURL(url);
        })
        .catch(error => {
            console.error('Error exporting all data:', error);
            alert('Failed to export all data. Check console for details.');
        });
        ```

2.  **Export My Data (Authenticated User):**
    *   **Endpoint:** `GET /api/Data/export/my`
    *   **Description:** Exports data belonging to the currently authenticated user.
    *   **Example (JavaScript `fetch`):**
        ```javascript
        fetch('/api/Data/export/my', {
            method: 'GET',
            headers: {
                'Authorization': 'Bearer YOUR_JWT_TOKEN_HERE'
            }
        })
        .then(response => {
            if (response.ok) {
                return response.blob();
            }
            throw new Error('Network response was not ok.');
        })
        .then(blob => {
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = 'LunaArcSync_MyData_Export.zip'; // Filename will be dynamic from backend
            document.body.appendChild(a);
            a.click();
            a.remove();
            window.URL.revokeObjectURL(url);
        })
        .catch(error => {
            console.error('Error exporting my data:', error);
            alert('Failed to export your data. Check console for details.');
        });
        ```

3.  **Export Specific User Data (Admin Only):**
    *   **Endpoint:** `GET /api/Data/export/user/{targetUserId}`
    *   **Description:** Exports data for a specific user ID. Requires an Admin role.
    *   **Example (JavaScript `fetch`)::
        ```javascript
        const targetUserId = 'SOME_USER_ID'; // Replace with the actual user ID
        fetch(`/api/Data/export/user/${targetUserId}`, {
            method: 'GET',
            headers: {
                'Authorization': 'Bearer YOUR_JWT_TOKEN_HERE'
            }
        })
        .then(response => {
            if (response.ok) {
                return response.blob();
            }
            throw new Error('Network response was not ok.');
        })
        .then(blob => {
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = `LunaArcSync_UserData_${targetUserId}_Export.zip`; // Filename will be dynamic from backend
            document.body.appendChild(a);
            a.click();
            a.remove();
            window.URL.revokeObjectURL(url);
        })
        .catch(error => {
            console.error(`Error exporting data for user ${targetUserId}:`, error);
            alert(`Failed to export data for user ${targetUserId}. Check console for details.`);
        });
        ```

### Importing Data

To import data, you'll need to send a `POST` request with a `multipart/form-data` body containing the file.

1.  **Import All Data (Admin Only):**
    *   **Endpoint:** `POST /api/Data/import`
    *   **Description:** Imports data from a ZIP file, affecting all system data. Requires an Admin role.
    *   **Example (JavaScript `fetch` with `FormData`):**
        ```javascript
        const fileInput = document.querySelector('#fileInput'); // Assuming you have an <input type="file" id="fileInput">
        const file = fileInput.files[0];

        if (!file) {
            alert('Please select a file to import.');
            return;
        }

        const formData = new FormData();
        formData.append('file', file); // 'file' must match the parameter name in the backend (ImportFileDto.File)

        fetch('/api/Data/import', {
            method: 'POST',
            headers: {
                'Authorization': 'Bearer YOUR_JWT_TOKEN_HERE'
                // 'Content-Type': 'multipart/form-data' is automatically set by FormData
            },
            body: formData
        })
        .then(response => {
            if (response.ok) {
                return response.json(); // Or response.text() if backend returns plain text
            }
            throw new Error('Network response was not ok.');
        })
        .then(data => {
            console.log('Import all data successful:', data);
            alert('All data imported successfully!');
        })
        .catch(error => {
            console.error('Error importing all data:', error);
            alert('Failed to import all data. Check console for details.');
        });
        ```

2.  **Import My Data (Authenticated User):**
    *   **Endpoint:** `POST /api/Data/import/my`
    *   **Description:** Imports data from a ZIP file, affecting only the current user's data.
    *   **Example (JavaScript `fetch` with `FormData`):**
        ```javascript
        const fileInput = document.querySelector('#fileInput'); // Assuming you have an <input type="file" id="fileInput">
        const file = fileInput.files[0];

        if (!file) {
            alert('Please select a file to import.');
            return;
        }

        const formData = new FormData();
        formData.append('file', file); // 'file' must match the parameter name in the backend (ImportFileDto.File)

        fetch('/api/Data/import/my', {
            method: 'POST',
            headers: {
                'Authorization': 'Bearer YOUR_JWT_TOKEN_HERE'
            },
            body: formData
        })
        .then(response => {
            if (response.ok) {
                return response.json(); // Or response.text()
            }
            throw new Error('Network response was not ok.');
        })
        .then(data => {
            console.log('Import my data successful:', data);
            alert('Your data imported successfully!');
        })
        .catch(error => {
            console.error('Error importing my data:', error);
            alert('Failed to import your data. Check console for details.');
        });
        ```

Remember to replace `YOUR_JWT_TOKEN_HERE` with the actual JWT token obtained after successful user login.