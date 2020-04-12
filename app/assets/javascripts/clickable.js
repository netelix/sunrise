Clickable =
  typeof Clickable != "undefined"
    ? Clickable
    : {
        initialize: function() {
          $(".clickable").click(function(event) {
            var location = $(this)
              .find("a.clickable-target")
              .eq(0)
              .attr("href");
            if (typeof Turbolinks != "undefined") Turbolinks.visit(location);
            else location.href = location;
          });
        },

        tearDown: function() {}
      };

if (typeof Turbolinks != "undefined") {
  document.addEventListener("turbolinks:load", function() {
    Clickable.initialize();
  });
  document.addEventListener("turbolinks:before-cache", function() {
    Clickable.tearDown();
  });
} else {
  $(function() {
    Clickable.initialize();
  });
}
