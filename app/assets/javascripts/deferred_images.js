DeferredImages =
  typeof DeferredImages != "undefined"
    ? DeferredImages
    : {
      initialize: function() {
        setTimeout(function(){
          DeferredImages.loadImagesOnScreen();
        }, 500);
        $(window).scroll(function() {
          DeferredImages.loadImagesOnScreen();
        });
      },

      tearDown: function() {},

      loadImagesOnScreen: function(){
        $("[data-bg-src]").each(function() {
          if (ElementOnScreen.check($(this))) {
            DeferredImages.loadBgImage($(this));
          }
        });
        $("img[data-src]").each(function() {
          if (ElementOnScreen.check($(this))) {
            DeferredImages.loadImage($(this));
          }
        });
      },

      loadBgImage: function($element) {
        $element.css(
          "background-image",
          'url('+$element.data("bg-src")+')'
        );
        $element.removeAttr("data-bg-src");
        $element.find('.fa-spinner').remove();
      },

      loadImage: function($element) {
        $element.attr('src', $element.data("src"));
        $element.removeAttr("data-src");
      }
    };

if (typeof Turbolinks != "undefined") {
  $(document).on("turbolinks:load ajax_modal:load", function() {
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
