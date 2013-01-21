$(function() {
  $(".pagination a").on("click", function() {
    $.getScript(this.href);
    return false;
  });
});
