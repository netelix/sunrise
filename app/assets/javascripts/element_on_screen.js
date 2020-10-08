ElementOnScreen =
  typeof ElementOnScreen != "undefined"
    ? ElementOnScreen
    : {
        check: function($element) {
          if($element.length == 0) return;

          var win = $(window);

          var viewport = {
            top: win.scrollTop(),
            left: win.scrollLeft()
          };
          viewport.right = viewport.left + win.width();
          viewport.bottom = viewport.top + win.height();

          var bounds = $element.offset();
          bounds.right = bounds.left + $element.outerWidth();
          bounds.bottom = bounds.top + $element.outerHeight();

          return !(
            viewport.right < bounds.left ||
            viewport.left > bounds.right ||
            viewport.bottom < bounds.top ||
            viewport.top > bounds.bottom
          );
        }
      };
