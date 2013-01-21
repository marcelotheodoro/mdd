$(function() {
	
	// all .toggle links must have a rel attribute to identify what element will toggle
	$('a.toggle').on('click', function() {
		$($(this).attr('rel')).toggle();
	});

	// open modalbox
	$('.lightbox').fancybox({
		closeClick: false,
		autoSize: true
	});

	// notices fadeout
	$('a#system_notice_close, #system_notice').on('click', function() {
		$('#system_notice').remove();
	});

	// ajax forms cancel button closes modal window
	$('.mdwa_ajax a.cancel').on('click', function() {
		$.fancybox.close(true);
	});	

	// set focus on modalbox form
  $(document).bind("ajaxComplete", function() {
    setFocusOnForm();
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

// focus on the first text input field in the first field on the page
function setFocusOnForm() {
	$(':input:enabled:visible:first', "div.filtros").focus();
  $(':input:enabled:visible:first', "div.mdwa_new").focus();
  $(':input:enabled:visible:first', "div.mdwa_edit").focus();
}
