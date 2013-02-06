$(document).ready(function() {
  $(document).on("click", "#pagination .pagination a", function() {
    $.getScript(this.href);
    return false;
  });

  $(document).on("change", "#pagination select", function() {
    $.getScript($(this).attr('local_url') + "&per_page=" + $(this).val());
  });
});
