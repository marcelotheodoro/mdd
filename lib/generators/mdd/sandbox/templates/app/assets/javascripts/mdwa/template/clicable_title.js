$(function() {
	$.each($('.clicable_title'), function(index, value) {
		if($(this).val() == '')
		  $(this).val($(this).attr('title'));
	});
	$('.clicable_title').live({
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