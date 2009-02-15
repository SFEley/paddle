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
    var list = "#list_" + this.name;
    if ($(this).is(":checked")) {
      $(list).slideDown("normal");
    }
    else {
      $(list).slideUp("normal");
    }
  });
});