// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

//= require jquery
//= require jquery-ui

function guest_login() {
  document.getElementById('user_username').value='guest';
  document.getElementById('user_password').value='guestpass';
  document.forms[0].submit()
}

$(document).ready(function(){

        // first example
        $("#tv").treeview({ animated:100, collapsed:false});

        // first example
        $("#browser").treeview();


});
