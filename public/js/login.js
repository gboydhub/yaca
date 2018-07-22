function newUser()
{
  var confirmField = document.getElementById("confirm_box");
  var loginBtn = document.getElementById("login_button");
  var newBtn = document.getElementById("new_button");

  if(confirmField.style.height.length < 1)
  {
    confirmField.style.height = "0em";
  }
  
  if(confirmField.style.height == "0em")
  {
    confirmField.style.height = "2em";
    confirmField.style.visibility = "visible";
    loginBtn.value = "Sign Up";
    newBtn.value = "Cancel";
    confirmField.required = true;
  }
  else
  {
    confirmField.style.height = "0em";
    confirmField.style.visibility = "hidden";
    confirmField.value = "";
    loginBtn.value = "Login";
    newBtn.value = "New User";
    confirmField.required = false;
  }

  document.getElementById("username").focus();
}