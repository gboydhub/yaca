function enableInput(name)
{
    var field = document.getElementById(`contact-${name}`);
    var btn = document.getElementById(`edit-${name}`);
    btn.hidden = true;
    field.removeAttribute("disabled");
    field.removeAttribute("readonly");
    if(name != "notes")
    {
        field.addEventListener("keydown", function(e) {
            if(e.which == 13 || e.keyCode == 13)
            {
                disableInput(name);
                return false;
            }
            return true;
        });
    }
    field.focus();
}

function disableInput(name)
{
    var field = document.getElementById(`contact-${name}`);
    var btn = document.getElementById(`edit-${name}`);
    btn.hidden = false;
    field.setAttribute("readonly", "true");

    document.getElementById("editform").submit();
}

function parseNotes()
{
    var field = document.getElementById("contact-notes");
    var content = field.innerHTML;
    field.innerHTML = content.replace(/\\n/g, String.fromCharCode(13, 10));
}