Class Demo.BootstrapApp Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
    &html<
    <!DOCTYPE html>
    <html>
    <head>
        <title>Person Management System</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            .card {
                transition: transform 0.2s;
                cursor: pointer;
            }
            .card:hover {
                transform: translateY(-5px);
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            }
            .card-icon {
                font-size: 3rem;
                color: #0d6efd;
            }
        </style>
    </head>
    <body class="bg-light">
        <div class="container mt-5">
            <h1 class="text-center mb-5">Person Management System</h1>
            <div class="row justify-content-center">
                <div class="col-md-4 mb-4">
                    <div class="card h-100" onclick="window.location.href='Demo.BootstrapApp.cls?action=list'">
                        <div class="card-body text-center p-5">
                            <div class="card-icon mb-3">
                                <i class="bi bi-people-fill"></i>
                            </div>
                            <h3 class="card-title">View People</h3>
                            <p class="card-text text-muted">Browse and manage the complete list of people</p>
                            <div class="mt-4">
                                <span class="badge bg-primary">#(##class(Demo.person).Count())# Records</span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="card h-100" onclick="window.location.href='Demo.NewPerson.cls'">
                        <div class="card-body text-center p-5">
                            <div class="card-icon mb-3">
                                <i class="bi bi-person-plus-fill"></i>
                            </div>
                            <h3 class="card-title">Add Person</h3>
                            <p class="card-text text-muted">Create a new person record</p>
                            <div class="mt-4">
                                <span class="badge bg-success">Quick Add</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
    </html>
    >

    If %request.Get("action") = "list" {
        Do ..ShowList()
    }

    Quit $$$OK
}

/// Display the list of people
ClassMethod ShowList() As %Status
{
    // Create some sample data if none exists
    If ('##class(Demo.person).Count()) {
        Do ##class(Demo.person).Populate(10)
    }
    
    // Get all persons
    Set tSQL = "SELECT ID, Name, Age, Email, DateOfBirth FROM Demo.person"
    Set tRS = ##class(%SQL.Statement).%ExecDirect(,tSQL)
    
    &html<
    <!DOCTYPE html>
    <html>
    <head>
        <title>People List</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container mt-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="text-center">People List</h2>
                <a href="Demo.NewPerson.cls" class="btn btn-primary">New Person</a>
            </div>
            <div class="row mb-4">
                <div class="col">
                    <input type="text" class="form-control" id="searchInput" placeholder="Search... (Use * for wildcards)">
                    <small class="text-muted">Example: "ro* p*" to find "Rogers, Paul" or "Robinson, Peter"</small>
                </div>
            </div>
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Age</th>
                        <th>Email</th>
                        <th>Date of Birth</th>
                    </tr>
                </thead>
                <tbody>
    >
    
    While tRS.%Next() {
        Write "<tr>"
        Write "<td><a href='Demo.EditPerson.cls?id="_tRS.ID_"' class='btn btn-link'>"_tRS.ID_"</a></td>"
        Write "<td>"_tRS.Name_"</td>"
        Write "<td>"_tRS.Age_"</td>"
        Write "<td>"_tRS.Email_"</td>"
        Write "<td>"_$ZDATE(tRS.DateOfBirth,3)_"</td>"
        Write "</tr>",!
    }
    
    &html<
                </tbody>
            </table>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
        document.getElementById('searchInput').addEventListener('keyup', function() {
            let input = this.value.toLowerCase();
            let terms = input.split(' ');
            let rows = document.querySelectorAll('table tbody tr');
            
            rows.forEach(row => {
                let text = row.textContent.toLowerCase();
                let match = true;
                
                terms.forEach(term => {
                    if (term.includes('*')) {
                        // Handle wildcard search
                        let pattern = term.replace(/\*/g, '.*');
                        let regex = new RegExp(pattern);
                        if (!regex.test(text)) {
                            match = false;
                        }
                    } else {
                        // Normal search
                        if (!text.includes(term)) {
                            match = false;
                        }
                    }
                });
                
                row.style.display = match ? '' : 'none';
            });
        });
        </script>
    </body>
    </html>
    >
    Quit $$$OK
}

}
