$(document).ready(function() {
  
  // Flexbox test!
  $("#jsontest").flexbox("/people.json");
  
  // Activate a person and show the payments panel
  $(".person").live("click", function(e) {
    var id = this.id.match(/\d+/);
    
    if ($(this).hasClass("active")) { // Toggle it off
      $(this).deactivate();
      $("#payments").slideUp("fast");
      $(this).removeClass("active");
    }
    else{
      $(this).activate();
      $("#payments").
        html("This should retrieve the payments for person number " + id + ".").
        slideDown("fast");
    }
  });
  
  // // Hide and show auction types when checked
  // $("#types :checkbox").bind("change", function(e) {
  //   var list = "#list_" + this.name.toLowerCase();
  //   if ($(this).is(":checked")) {
  //     $(list).slideDown("normal");
  //   }
  //   else {
  //     $(list).slideUp("normal");
  //   }
  // });
  // 
  // // Hide and show open and closed auctions when checked
  // $("#statuses :checkbox").bind("change", function(e) {
  //   var auctions = $(".auction." + $(this).attr("id"));
  //   if ($(this).is(":checked")) {
  //     $(auctions).show("normal");
  //   }
  //   else {
  //     $(auctions).hide("normal");
  //   };
  // });
  
  // Replace an person with his/her edit form
  $(".person a.edit").live("click", function(e) {
    e.preventDefault();
    var person = $(this).parent();
    $(person).load(this.href + " form");
  });
  
  // Make the delete links do their thing
  $(".person a.delete").live("click", function(e) {
    e.preventDefault();
    var person = $(this).parent();
    $.post($(this).attr('href'),"_method=delete",function() {
      $(auction).hide('slow', function() {
        $(this).remove();
      });
    });
  }).confirm();
  
  // Let the New Auction link edit on this page
  $("#new_person").live("click", function(e) {
    e.preventDefault();
    $("<div class='person inset'>").load(this.href + " form").prependTo($("#listing"));
  });

  // AJAX-enable any new or edit forms
  $(".person form").livequery(function() {
    var form = $(this);
    var person = $(form).parent();
    $(this).ajaxForm(function(responseText, statusText){
      if ($(responseText).contents().is('form')) {
        // Must've failed, so put the contents of the new form into the old one
        $(form).html($('form', responseText).html());
      }
      else {
        // Success!  Let's do our thing.
        var response = $(".person", responseText);
        $(person).html($(response).html());
      
        // Add a person ID if it didn't already have one
        if ($(person).attr('id') === undefined) {
          $(person).attr('id',$(response).attr('id'));
        };
      
        // Add the right filtering classes
        $(person).attr('className',$(response).attr('className'));
      
        // Now get rid of the display after a few seconds
        $(person).children(".message").animate({opacity: 1.0}, 3000).hide("slow", function() {$(this).remove();});
      };
    });
  });
});