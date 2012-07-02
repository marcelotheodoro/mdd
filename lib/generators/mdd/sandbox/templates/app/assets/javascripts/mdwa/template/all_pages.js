$(function() {
	
	// all .toggle links must have a rel attribute to identify what element will toggle
	$('a.toggle').live('click', function() {
		$($(this).attr('rel')).toggle();
	});

	// open modalbox
	$('.lightbox').fancybox({
		closeClick: false,
		autoSize: true
	});

	// notices fadeout
	$('a#system_notice_close, #system_notice').live('click', function() {
		$('#system_notice').remove();
	});

	// ajax forms cancel button closes modal window
	$('.mdwa_ajax a.cancel').live('click', function() {
		$.fancybox.close(true);
	});	
	
});

function checkOrUncheckAll( to_be_checked ){
  var to_be_checked = to_be_checked || false;
  $( ".cid" ).attr( "checked", to_be_checked );
}

function defineAction( form, action, confirmation ) {
  var response = true;
  if( confirmation ) {
    response = confirm("Are you sure?");
  }
  if( response ) {
    $( "#" + form ).attr( "action", action);
    $( "#" + form ).submit();
  }
}

function defineOrder( form, action, id ) {
  $( "#" + form ).attr( "action", action);
  $( "#cb" + id ).attr( "checked", true);
  $( "#" + form ).submit();
}

function deleteSystemNotice() {
	$('#system_notice').fadeOut('slow', function() {
		$('#system_notice').remove();
	});
}
