SearchAutocomplete =
  typeof SearchAutocomplete != "undefined"
    ? SearchAutocomplete
    : {
        initialize: function() {
          $(".search-autocomplete").each(function() {
            var $input = $(this);

            SearchAutocomplete.initializeAutocompleteField($input, {
              first_suggestion_on_submit: $input.data(
                "first-suggestion-on-submit"
              )
            });
          });
        },

        initializeAutocompleteField: function($input, options) {
          if ($input.data("autocomplete")) {
            return $input.data("autocomplete");
          }
          if (!options) options = {};

          if ($input[0]) {
            var $form = $input.parents("form");

            if (options["first_suggestion_on_submit"]) {
              SearchAutocomplete.selectFirstSuggestionOnSubmit($form, $input);
            }

            var types = [];
            if (options["types"]) {
              types = [options["types"]];
            }
            var autocomplete = new google.maps.places.Autocomplete($input[0], {
              types: types,
              componentRestrictions: {
                country: SearchAutocomplete.countries()
              }
            });

            autocomplete.addListener("place_changed", function() {
              SearchAutocomplete.onPlaceChanged($form, this);
            });

            $input.data("autocomplete", autocomplete);
            return autocomplete;
          }
        },

        selectFirstSuggestionOnSubmit: function($form, $input) {
          $form.on("submit", function() {
            $first_suggestion = $(".pac-container .pac-item-query:first");
            if ($first_suggestion.length) {
              $input.val($first_suggestion.text());
              $form.find(".loc_id").val("");
            }
          });
        },

        shouldSubmitOnSelectSuggestion: function($form) {
          return $form
            .find(".search-autocomplete")
            .data("submit-on-select-suggestion");
        },

        onPlaceChanged: function($form, autocomplete) {
          var place = autocomplete.getPlace();
          $form.find(".google_place_id").val(place.place_id);
          $form.find(".loc_id").val("");
          $form
            .find(".search-autocomplete")
            .trigger("change", ["search_autocomplete"]);

          if (SearchAutocomplete.shouldSubmitOnSelectSuggestion($form)) {
            $form.trigger("submit");
          }
        },

        isUncompleteAutocompleteEvent: function(event, data) {
          return (
            $(event.target).hasClass("search-autocomplete") &&
            data != "search_autocomplete"
          );
        },

        tearDown: function() {},

        countries: function() {
          return [
            "fr",
            "gp",
            "mq",
            "gf",
            "re",
            "pm",
            "yt",
            "nc",
            "pf",
            "mf",
            "tf"
          ];
        }
      };

if (typeof Turbolinks != "undefined") {
  $(document).on("turbolinks:load ajax_modal:load", function() {
    SearchAutocomplete.initialize();
  });
  $(document).on("turbolinks:before-cache", function() {
    SearchAutocomplete.tearDown();
  });
} else {
  $(function() {
    SearchAutocomplete.initialize();
  });
}
