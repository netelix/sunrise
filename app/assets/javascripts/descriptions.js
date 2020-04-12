Descriptions =
  typeof Descriptions != "undefined"
    ? Descriptions
    : {
        geocoder: null,
        map: null,
        marker: null,

        initialize: function() {
          $(".description-text-fields textarea").each(function() {
            $textarea = $(this);
            summernote = $textarea.summernote({
              tabsize: 1,
              height: 200,
              maxHeight: null,
              toolbar: [
                ["font", ["bold", "underline", "clear"]],
                ["para", ["ul", "ol", "paragraph"]]
              ],
              cleaner: {
                action: "both", // both|button|paste 'button' only cleans via toolbar button, 'paste' only clean when pasting content, both does both options.
                newline: "<p><br></p>",
                notStyle: "position:absolute;top:0;left:0;right:0", // Position of Notification
                icon: '<i class="note-icon">[Your Button]</i>',
                keepHtml: true, // Remove all Html formats
                keepOnlyTags: [
                  "<p>",
                  "<br>",
                  "<ul>",
                  "<ol>",
                  "<li>",
                  "<b>",
                  "<strong>",
                  "<i>",
                  "<div>",
                  "<h2>",
                  "<h3>"
                ], // If keepHtml is true, remove all tags except these
                keepClasses: true, // Remove Classes
                badTags: [
                  "style",
                  "script",
                  "applet",
                  "embed",
                  "noframes",
                  "noscript",
                  "html"
                ], // Remove full tags with contents
                badAttributes: ["style", "start", "class", "id"], // Remove attributes from remaining tags
                limitChars: false, // 0/false|# 0/false disables option
                limitDisplay: "none", // text|html|both
                limitStop: false, // true/false
                replaceWithP: ["div", "h2", "h3", "h4", "h5", "h6"],
                replaceWithSpan: ["a"],
                showMessage: false
              },
              callbacks: {
                onInit: function() {
                  if ($textarea.hasClass("is-invalid")) {
                    $textarea
                      .parents(".form-group")
                      .find(".note-editor")
                      .addClass("is-invalid");
                  }
                },
                onChange: function() {
                  $(this)
                    .parents(".form-group")
                    .find(".note-editable *")
                    .css("font-size", "");
                }
              }
            });
          });
        }
      };

$(document).on("ajax_modal:load", function() {
  if ($(".description-text-fields").length) {
    Descriptions.initialize();
  }
});
