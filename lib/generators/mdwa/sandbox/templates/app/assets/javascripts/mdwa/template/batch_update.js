$(document).ready(function() {
  $(document).on('click', 'a.batch_update', function(event) {

    event.preventDefault();

    // seleciona os inputs checados
    var input_container = $(this).attr('input_container');
    if($(this).attr('input_container') == null) input_container = '' 
    var ids = new Array();
    $(input_container + ' input[type="checkbox"].cid:checked').each(function() {
      ids.push($(this).val());
    });
    if( ids.length == 0 ) {
      alert('Select at least one element.');
      return false;
    }

    if( !$(this).attr('confirm_batch_update') && !confirm( $(this).attr('confirm_batch_update') ) ) return false;

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