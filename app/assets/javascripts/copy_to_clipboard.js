CopyToClipboard =
  typeof CopyToClipboard != "undefined"
    ? CopyToClipboard
    : {
        initialize: function() {
          $(".copy-to-clipboard").click(function(e) {
            text = $(this).data('text');
            var dummy = document.createElement("textarea");
            document.body.appendChild(dummy);
            dummy.value = text;
            dummy.select();
            document.execCommand("copy");
            document.body.removeChild(dummy);

            $(this).find($(this).data('copied-label-target')).text($(this).data('copied-label'))
            e.stopPropagation();
          });
        },

        tearDown: function() {}
      };

if (typeof Turbolinks != "undefined") {
  document.addEventListener("turbolinks:load", function() {
    CopyToClipboard.initialize();
  });
  document.addEventListener("turbolinks:before-cache", function() {
    CopyToClipboard.tearDown();
  });
} else {
  $(function() {
    CopyToClipboard.initialize();
  });
}
