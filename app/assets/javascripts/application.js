// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require accounting.min


var CheckoutSave = {
	path: null
};

var ready = function() {
	$('.checkout_back_link').click(function(event) {
		if (CheckoutSave.path) {
	    var checkoutSave = {};
	    checkoutSave.given_name = $('input[name="order[given_name]"]').val();
	    checkoutSave.family_name = $('input[name="order[family_name]"]').val();
	    checkoutSave.street_address = $('input[name="order[invoice_address_attributes][street_address]"]').val();
	    checkoutSave.address_locality = $('input[name="order[invoice_address_attributes][address_locality]"]').val();
	    checkoutSave.postal_code = $('input[name="order[invoice_address_attributes][postal_code]"]').val();
	    checkoutSave.email = $('input[name="order[email]"]').val();
	    checkoutSave.telephone = $('input[name="order[telephone]"]').val();
	    checkoutSave.school = $('input[name="school"]').val();
			checkoutSave.recipient = $('input[name="order[recipient]"]').val();
			checkoutSave.notes = $('textarea[name="order[notes]"]').val();

			$.ajax({
		    type: 'POST',
		    url: CheckoutSave.path,
				async: false,
		    data: JSON.stringify(checkoutSave),
		    contentType: "application/json",
		    dataType: 'json'
			});
		}
  });
}

// Initialize the javascript
$(document).on("ready", ready);
