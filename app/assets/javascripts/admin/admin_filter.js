AdminFilter =
  typeof AdminFilter != "undefined"
    ? AdminFilter
    : {
        initialize: function() {
          $(".dynamic-filter").keyup(function() {
            $target = $(this).data("target");
            $container = $($(this).data("result-container"));
            $container.addClass("blur");

            clearTimeout($(this).data("timer"));
            var search = this.value;
            if (search.length >= 3 || search.length == 0) {
              $(this).data(
                "timer",
                setTimeout(function() {
                  $.ajax({
                    type: "POST",
                    url: $target,
                    data: {
                      query: search
                    }
                  }).done(function(data) {
                    $container.html(data);
                    $container.removeClass("blur");

                    parameters = AdminFilter.getParameters();
                    parameters['query'] = search
                    path = window.location.pathname.split('?')[0]
                    window.history.pushState(
                      {},
                      "",
                      path + '?' + jQuery.param(parameters)
                    );
                  });
                }, 1000)
              );
            }
          });
        },

        getParameters: function() {
          var parameters = {},
            tmp = [];

          var items = location.search.substr(1).split("&");
          for (var index = 0; index < items.length; index++) {
            tmp = items[index].split("=");
            if(tmp[0] != '') { parameters[tmp[0]] = tmp[1] }

          }
          return parameters;
        }
      };

$(document).on("turbolinks:load", function() {
  if ($(".dynamic-filter").length) {
    AdminFilter.initialize();
  }
});
