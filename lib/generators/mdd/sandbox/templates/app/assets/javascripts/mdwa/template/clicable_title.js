$(function() {
	$.each($('.titulo_clicavel'), function(index, value) {
		if($(this).val() == '')
		  $(this).val($(this).attr('title'));
	});
	$('.titulo_clicavel').live({
		blur: function() {
			if($(this).val() == '') $(this).val($(this).attr('title'));
		},
		click: function() {
			$(this).select();
			if($(this).val() == $(this).attr('title')) $(this).val('');
		}, 
		focus: function() {
			$(this).select();
			if($(this).val() == $(this).attr('title')) $(this).val('');
		}
	});
});