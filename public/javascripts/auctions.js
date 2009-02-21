
$(document).ready(function() {
  
  // Activate an auction and show the bid panel
  $(".auction").live("click", function(e) {
    var auction = $(this);
    var id = this.id.match(/\d+/);
    var bid_url = "/auctions/" + id + "/bids";
    var close_url = "/auctions/" + id + "/close";
    var title = $(this).children(".auction_title").text();

    var bid_row = function(bid) {
      return $('<tr>').addClass('ephemeral').
        append($("<td>" + bid.buyer.paddle_name + "</td>")).
        append($("<td>$" + parseFloat(bid.amount).toFixed(2) + "</td>")).
        append($("<td><a class='delete_bid' href='" + bid_url + "/" + bid.id + "'>(X)</span></td>"));
    }
    
    $("#bidtip").slideUp("fast");
    
    // Clear the leftovers
    $("#buyer").empty();
    $("#bids .ephemeral").remove();
    $("#close_button").unbind();
    
    if ($(this).hasClass("active")) { // Toggle it off
      $(this).deactivate();
      $("#bids").slideUp("fast");


      $(this).removeClass("active");
    }
    else{
      $(this).activate();
      $("#bids").
        children("#bid_title").
          text(title).
        end().
        slideDown("fast", function() {
          // Activate the person lookup box
          $("#buyer").flexbox("/people.json", {
            width: 150      
          });
        
        // Set the form URL
        $("#bid_form").attr("action", bid_url);
         
        // Fill in the table
        $.getJSON(bid_url + ".json", function(response,status) {
          $.each(response.bids, function(index,value){
            $(bid_row(value)).insertAfter("#bid_header");
          });
        });
        
        $("#bid_form").ajaxForm({ 
          dataType: "json",
          clearForm: true,
          // data: {
          //    "bid[buyer_id]": $("#buyer_hidden").val()
          // },
          success: function(response,success,set){
            $(bid_row(response)).insertBefore($("#bid_form").parent());
          }
        });
        
        // Activate the 'Close Auction' button
        $("#close_button").bind("click", function(e) {
          $.post(close_url, function(response, status) {
            $(auction).removeClass('status_open').addClass('status_closed');
          })
        })
        
      });
    };
  });
  
  // Pass the buyer id to something the ajaxForm can see
  $("#buyer_input").livequery("blur", function(e) {
    $("#bid_buyer_id").val($("#buyer_hidden").val());
  });
  
  // Make the bid delete links work
  $(".delete_bid").live("click", function(e) {
    var row = $(this).parent().parent();
    e.preventDefault();
    $.post($(this).attr('href'),"_method=delete",function() {
      $(row).hide('slow', function() {
        $(this).remove();
      });
    });
    
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
  
  // Hide and show open and closed auctions when checked
  $("#statuses :checkbox").bind("change", function(e) {
    var auctions = $(".auction." + $(this).attr("id"));
    if ($(this).is(":checked")) {
      $(auctions).show("normal");
    }
    else {
      $(auctions).hide("normal");
    };
  });
  
  // Replace an auction with its edit form
  $(".auction a.edit").live("click", function(e) {
    e.preventDefault();
    var auction = $(this).parent();
    $(auction).load(this.href + " form");
  });
  
  // Make the delete links do their thing
  $(".auction a.delete").live("click", function(e) {
    e.preventDefault();
    var auction = $(this).parent();
    $.post($(this).attr('href'),"_method=delete",function() {
      $(auction).hide('slow', function() {
        $(this).remove();
      });
    });
  }).confirm();
  
  // Let the New Auction link edit on this page
  $("#new_auction").live("click", function(e) {
    e.preventDefault();
    $("<div class='auction status_open inset'>").load(this.href + " form").prependTo($("#listing"));
  });

  // AJAX-enable any new or edit forms
  $(".auction form").livequery(function() {
    var auction = $(this).parent();
    
    // Enable the seller ID box
    $("#seller").flexbox("/people.json", {
      width: 150  
    });
    
    $(this).ajaxForm(function(responseText, statusText){
      var response = $(".auction", responseText);
      $(auction).html($(response).html());
      
      // Figure out the new item's listing type and move it if necessary
      var listingClass = $(response).attr("className").match(/list_\w+/)[0];
      if (!$(auction).hasClass(listingClass)) {
        $(auction).addClass(listingClass).appendTo($("#" + listingClass));
      };
      
      // Add an auction ID if it didn't already have one
      if ($(auction).attr('id') === undefined) {
        $(auction).attr('id',$(response).attr('id'));
      };
      
      // Now get rid of the display after a few seconds
      $(auction).children(".message").animate({opacity: 1.0}, 3000).hide("slow", function() {$(this).remove();});
    });
  });
  
  // Pass the seller id to something the ajaxForm can see
  $("#seller_input").livequery("blur", function(e) {
    $("#auction_seller_id").val($("#seller_hidden").val());
  });
  
  
});