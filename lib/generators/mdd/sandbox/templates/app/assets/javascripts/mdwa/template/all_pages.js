$(function() {
	
	// todo link toggle tem um atributo rel que identifica o elemento que vai ser feito display
	$('a.toggle').live('click', function() {
		$($(this).attr('rel')).toggle();
	});

	// tudo com a classe lightbox, abre o modalbox
	$('.lightbox').fancybox({
		closeClick: false,
		autoSize: true
	});

	$('a#system_notice_close, #system_notice').live('click', function() {
		$('#system_notice').fadeOut();
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

