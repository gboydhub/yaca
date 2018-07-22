function newUser()
{
  var confirmField = document.getElementById("confirm_box");
  var loginBtn = document.getElementById("login_button");
  var newBtn = document.getElementById("new_button");

  if(confirmField.type == "hidden")
  {
    confirmField.type = "password";
    loginBtn.value = "Sign Up";
    newBtn.value = "Cancel";
    confirmField.required = true;
  }
  else
  {
    confirmField.type = "hidden";
    loginBtn.value = "Login";
    newBtn.value = "New User";
    confirmField.required = false;
  }

  document.getElementById("username").focus();
}