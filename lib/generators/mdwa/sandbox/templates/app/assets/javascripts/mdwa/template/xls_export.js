$(document).ready( function() {

  $(document).on('click', 'a.export.xls', function() {
    var form = '#' + $(this).attr('form');
    var url = $(form).attr('action') + '.xls?';
    $(form).find('input[type="text"], input[type="hidden"], input[type="email"], select').each(function(index) {
      if(index != 0) url += '&';
      url += $(this).attr('id') + '=' + $(this).val();
    });
    url += '&skip_pagination=1';
    window.location = url;
  });

});