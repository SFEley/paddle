// Common JavaScript code across your application goes here.

// 'deactivate': remove the 'active' class from every element, and hide all collapsed elements
jQuery.fn.deactivate = function() {
  $(this).removeClass("active").children(".collapse").hide("fast");
};

// 'activate': toggle the 'active' class on the first element, and show all collapsed elements
jQuery.fn.activate = function() {
  var me = $(this).eq(0);
  $(".active").not(me).deactivate();
  $(me).addClass("active").children(".collapse").show("fast");
};

