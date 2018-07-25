function enableInput(name)
{
    var field = document.getElementById(`contact-${name}`);
    var btn = document.getElementById(`edit-${name}`);
    btn.hidden = true;
    field.removeAttribute("disabled");
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
    field.setAttribute("disabled", "true");
}