enableInput(name)
{
    var field = document.getElementById(`contact-${name}`);
    field.disabled = false;
    field.focus();
}