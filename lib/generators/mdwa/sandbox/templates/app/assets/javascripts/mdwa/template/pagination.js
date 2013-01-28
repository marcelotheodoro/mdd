$(function() {
  $(document).on("click",".pagination a", function() {
    $.getScript(this.href);
    return false;
  });
});
