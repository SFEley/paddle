$(document).ready(function() {
  
  // Activate a person and show the payments panel
  $(".person").live("click", function(e) {
    var id = this.id.match(/\d+/);
    var payment_url = "/people/" + id + "/payments"
    var person_name = $(this).children('.person_name').html();
    
    var payment_rows = function() {
      $("#payments_table tr.ephemeral").remove();
      $.getJSON(payment_url + ".json", function(response, status) {
        $.each(response.payments, function(index,value) { 
          $('<tr>').addClass('ephemeral').
          append($("<td>" + value.type + "</td>")).
          append($("<td>$" + parseFloat(value.amount).toFixed(2) + "</td>")).
          append($("<td><a class='delete_payment' href='" + payment_url + "/" + value.id + "'>(X)</span></td>")).
          insertAfter($("#payment_header"));
        });
        $("#payments_total").text('$' + parseFloat(response.person.total_payments).toFixed(2));
        $("#purchases_total").text('$' + parseFloat(response.person.total_purchases).toFixed(2));
        $("#balance").text('$' + parseFloat(response.person.balance).toFixed(2));
        $("#bid_amount").val(parseFloat(response.person.balance).toFixed(2));
      });
    };
    
    $("#paymenttip").slideUp('fast');
    
    if ($(this).hasClass("active")) { // Toggle it off
      $(this).deactivate();
      $("#payments").slideUp("fast");
      $(this).removeClass("active");
    }
    else{ // Toggle it on
      $(this).activate();
      $("#payments").
        children("#person_name").
          html(person_name).
        end().
        slideDown("fast");
      
      // Set the form URL
      $("#payment_form").attr("action", payment_url);
     
      // Fill in the table
      payment_rows();
      
    
      $("#payment_form").ajaxForm({ 
        dataType: "json",
        clearForm: true,
        // data: {
        //    "bid[buyer_id]": $("#buyer_hidden").val()
        // },
        success: function(response,success,set){
          payment_rows();
        }
      });
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