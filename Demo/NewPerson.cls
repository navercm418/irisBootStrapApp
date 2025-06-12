Class Demo.NewPerson Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
    &html<
    <!DOCTYPE html>
    <html>
    <head>
        <title>New Person</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container mt-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>New Person</h2>
                <a href="Demo.BootstrapApp.cls" class="btn btn-secondary">Return to List</a>
            </div>
            <form method="POST" action="Demo.NewPerson.cls">
                <div class="mb-3">
                    <label class="form-label">Name</label>
                    <input type="text" class="form-control" name="Name" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" class="form-control" name="Email" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Date of Birth</label>
                    <input type="date" class="form-control" name="DateOfBirth" required>
                </div>
                <div class="mb-3">
                    <button type="submit" class="btn btn-primary">Create Person</button>
                    <a href="Demo.BootstrapApp.cls" class="btn btn-outline-secondary">Cancel</a>
                </div>
            </form>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
    </html>
    >
    Quit $$$OK
}

ClassMethod OnPreHTTP() As %Boolean
{
    If %request.Method = "POST" {
        Set person = ##class(Demo.person).%New()
        Set person.Name = %request.Get("Name")
        Set person.Email = %request.Get("Email")
        Set person.DateOfBirth = $ZDATEH(%request.Get("DateOfBirth"),3)
        Do person.%Save()
        
        &js<window.location.href='Demo.BootstrapApp.cls';>
    }
    Quit 1
}

}
