$(function() {

	$('body').append("<div id='ajax-loader'></div>");
	$('#ajax-loader').css( { 
		'background': 'url(mdwa/ajax-loader.gif) no-repeat scroll 0 0 transparent',
    	'display': 'none',
    	'height': '42px',
    	'left': '50%',
    	'position': 'fixed',
    	'text-align': 'center',
    	'top': '50%',
    	'width': '42px',
    	'z-index': '10001'
    });

	$(document).bind("ajaxSend", function() {
		$('#ajax-loader').show();
	}).bind("ajaxComplete", function() {
		$('#ajax-loader').hide();
	});
});