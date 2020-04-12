DeferredImages =
  typeof DeferredImages != "undefined"
    ? DeferredImages
    : {
        initialize: function() {
          var imgDefer = document.getElementsByTagName("img");
          for (var i = 0; i < imgDefer.length; i++) {
            if (imgDefer[i].getAttribute("data-src")) {
              imgDefer[i].setAttribute(
                "src",
                imgDefer[i].getAttribute("data-src")
              );
            }
          }
        },

        tearDown: function() {}
      };

if (typeof Turbolinks != "undefined") {
  $(document).on("turbolinks:load", function() {
    DeferredImages.initialize();
  });
  $(document).on("turbolinks:before-cache", function() {
    DeferredImages.tearDown();
  });
} else {
  $(function() {
    DeferredImages.initialize();
  });
}
