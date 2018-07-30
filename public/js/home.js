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

function phoneListener()
{
    var field = document.getElementById("contact-phone");
    var data = field.value;
    var numbers_data = "";
    for(var i = 0; i < data.length; i++)
    {
        if(!isNaN(data[i]) && data[i] != " ")
        {
            numbers_data += data[i];
        }
    }
    var final_data = numbers_data;

    if(numbers_data.length >= 8)
    {
        final_data = `(${numbers_data.slice(0, 3)}) ${numbers_data.slice(3, 6)}-${numbers_data.slice(6,10)}`;
    }
    else if(numbers_data.length > 3)
    {
        final_data = `${numbers_data.slice(0, 3)}-${numbers_data.slice(3)}`;
    }
    field.value = final_data;
}

function loadHome()
{
    parseNotes();
}

function parseNotes()
{
    var field = document.getElementById("contact-notes");
    var content = field.innerHTML;
    content = content.replace(/\\n/g, String.fromCharCode(13, 10));
    field.innerHTML = content.replace(/(?<!\\)\\/g, "");
}

function clickContact(id)
{
    var form = document.getElementById("viewform");
    var hidden_input = document.createElement("input");
    hidden_input.type = "hidden";
    hidden_input.name = "view";
    hidden_input.value = `${id}`;
    form.appendChild(hidden_input);
    form.submit();
}