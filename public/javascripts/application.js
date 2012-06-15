// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function guest_login() {
  document.getElementById('user_username').value='guest';
  document.getElementById('user_password').value='guestpass';
  document.forms[0].submit()
}
