var ready = function() {
	checkoutCart();
}

// Initialize the javascript
$(document).on("ready", ready);
//$(document).on("page:load", ready);


function checkoutCart(){
	$("#checkout-btn").on("click", function(){
		$("input[name='proceed_to_checkout']").val("1");
	//	$('.edit_cart').append($(input));
		$(".edit_cart").submit();
	});
}