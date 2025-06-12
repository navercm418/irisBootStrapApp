Class Demo.EditPerson Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
    Set id = %request.Get("id")
    Set person = ##class(Demo.person).%OpenId(id)
    
    If person = "" {
        &html<
        <!DOCTYPE html>
        <html>
        <head>
            <title>Error - Person Not Found</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        </head>
        <body>
            <div class="container mt-5">
                <div class="alert alert-danger" role="alert">
                    <h4 class="alert-heading">Error!</h4>
                    <p>This person record does not exist or has been deleted.</p>
                </div>
                <a href="Demo.BootstrapApp.cls" class="btn btn-primary">Return to List</a>
            </div>
        </body>
        </html>
        >
        Quit $$$OK
    }
    
    &html<
    <!DOCTYPE html>
    <html>
    <head>
        <title>Edit Person</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container mt-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Edit Person</h2>
                <div>
                    <button class="btn btn-danger me-2" onclick="confirmDelete()">Delete Person</button>
                    <a href="Demo.BootstrapApp.cls" class="btn btn-secondary">Return to List</a>
                </div>
            </div>
            <form method="POST" action="Demo.EditPerson.cls">
                <input type="hidden" name="id" value="#(id)#">
                <div class="mb-3">
                    <label class="form-label">Name</label>
                    <input type="text" class="form-control" name="Name" value="#(person.Name)#" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" class="form-control" name="Email" value="#(person.Email)#" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Date of Birth</label>
                    <input type="date" class="form-control" name="DateOfBirth" value="#($ZDATE(person.DateOfBirth,3))#" required>
                </div>
                <div class="mb-3">
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                    <a href="Demo.BootstrapApp.cls" class="btn btn-outline-secondary">Cancel</a>
                </div>
            </form>
        </div>

        <!-- Delete confirmation modal -->
        <div class="modal fade" id="deleteModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Confirm Delete</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        Are you sure you want to delete this person record?
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <form method="POST" action="Demo.EditPerson.cls">
                            <input type="hidden" name="id" value="#(id)#">
                            <input type="hidden" name="action" value="delete">
                            <button type="submit" class="btn btn-danger">Delete</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
        function confirmDelete() {
            var modal = new bootstrap.Modal(document.getElementById('deleteModal'));
            modal.show();
        }
        </script>
    </body>
    </html>
    >
    Quit $$$OK
}

ClassMethod OnPreHTTP() As %Boolean
{
    If %request.Method = "POST" {
        Set id = %request.Get("id")
        Set action = %request.Get("action")
        
        If action = "delete" {
            Set person = ##class(Demo.person).%OpenId(id)
            If person '= "" {
                Do ##class(Demo.person).%DeleteId(id)
                &js<window.location.href='Demo.BootstrapApp.cls';>
            } Else {
                &js<
                    alert('This person record does not exist or has been deleted');
                    window.location.href='Demo.BootstrapApp.cls';
                >
            }
        } Else {
            Set person = ##class(Demo.person).%OpenId(id)
            If person '= "" {
                Set person.Name = %request.Get("Name")
                Set person.Email = %request.Get("Email")
                Set person.DateOfBirth = $ZDATEH(%request.Get("DateOfBirth"),3)
                Do person.%Save()
                &js<window.location.href='Demo.BootstrapApp.cls';>
            } Else {
                &js<
                    alert('This person record does not exist or has been deleted');
                    window.location.href='Demo.BootstrapApp.cls';
                >
            }
        }
    }
    Quit 1
}

}
