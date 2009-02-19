$(document).ready(function() {
  
  // Activate an auction and show the bid panel
  $(".auction").live("click", function(e) {
    var id = this.id.match(/\d+/);
    
    if ($(this).hasClass("active")) { // Toggle it off
      $(this).deactivate();
      $("#bids").slideUp("fast");
      $(this).removeClass("active");
    }
    else{
      $(this).activate();
      $("#bids").
        html("This should retrieve the bids for auction number " + id + ".").
        slideDown("fast");
    }
  });
  
  // Hide and show auction types when checked
  $("#types :checkbox").bind("change", function(e) {
    var list = "#list_" + this.name.toLowerCase();
    if ($(this).is(":checked")) {
      $(list).slideDown("normal");
    }
    else {
      $(list).slideUp("normal");
    }
  });
  
  // Replace an auction with its edit form
  $(".auction a.edit").live("click", function(e) {
    e.preventDefault();
    var auction = $(this).parent();
    $(auction).load(this.href + " form");
  });
  
  // AJAX-enable any new or edit forms
  $(".auction form").livequery(function() {
    var auction = $(this).parent();
    $(this).ajaxForm(function(responseText, statusText){
      var response = $("#auction", responseText);
      $(auction).html($(response).html());
      
      // Figure out the new item's listing type and move it if necessary
      var listingClass = $(response).attr("className").match(/list_\w+/)[0];
      if (!$(auction).hasClass(listingClass)) {
        $(auction).appendTo($("#" + listingClass));
      };
      
      // Now get rid of the display after a few seconds
      $(auction).children(".message").animate({opacity: 1.0}, 3000).fadeOut("slow", function() {$(this).remove();});
    });
  });
});