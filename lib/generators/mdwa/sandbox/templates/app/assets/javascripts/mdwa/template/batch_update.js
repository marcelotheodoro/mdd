$(document).ready(function() {
  $(document).on('click', 'a.batch_update', function(event) {

    event.preventDefault();

    if( !confirm('Are you sure?') ) return false;

    // seleciona os inputs checados
    var input_container = $(this).attr('input_container');
    if($(this).attr('input_container') == null) input_container = '' 
    if( $(input_container + ' input[type="checkbox"].cid:checked').length == 0 ) return false;

    var ids = new Array();
    $(input_container + ' input[type="checkbox"].cid:checked').each(function() {
      ids.push($(this).val());
    });

    var url = $(this).attr('href');
    var attribute = $(this).attr('attribute');
    var value = $(this).attr('value');

    $.ajax({
      url: url,
      type: 'POST',
      dataType: 'script',
      data: {
        ids: ids,
        attribute: attribute,
        value: value
      }
    });

    return false;
  });
});