$(document).ready(function() {
  $(".auction").bind("click", function(e) {
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
  
});