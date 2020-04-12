AjaxModal =
  typeof AjaxModal != "undefined"
    ? AjaxModal
    : {
        modalHolderSelector: "#modal-holder",
        modalSelector: ".modal.ajax_modal",

        initialize: function() {
          $(document)
            .find("body")
            .append(
              '<div id="modal-holder">' +
                '<div class="modal ajax_modal" id="ajax_modal">' +
                '<div class="modal-dialog">' +
                '<div class="modal-content">' +
                '<div class="modal-body">' +
                "</div>" +
                "</div>" +
                "</div>" +
                "</div>" +
                "</div>"
            );
          $(document).on("click", "a[data-modal]", AjaxModal.open);
          $(document).on("click", ".preload-modal", function() {
            AjaxModal.show();
          });
          $(document).on("ajax:send", "form[data-modal]", AjaxModal.setSpinner);
          $(document).on("ajax:success", function(event, data, _, response) {
            if (
              response.getResponseHeader("X-Kasaz-Response-In-Modal") == "true"
            ) {
              AjaxModal.formResponse(event, data, _, response);
              return false;
            }
          });
        },

        tearDown: function() {
          $(document).off(
            "ajax:send",
            "form[data-modal]",
            AjaxModal.setSpinner
          );
          $(document).off("click", "a[data-modal]", AjaxModal.open);
          $(document).off(
            "ajax:success",
            "form[data-modal]",
            AjaxModal.formResponse
          );
          $(document).off("click", ".preload-modal");
        },

        open: function() {
          var location;
          AjaxModal.show();
          AjaxModal.setSpinner();
          location = $(this).attr("href");
          return AjaxModal.loadContent(location);
        },

        show: function() {
          $(".modal")
            .not(".ajax_modal")
            .modal("hide");

          $(AjaxModal.modalHolderSelector)
            .find(AjaxModal.modalSelector)
            .modal();
          $(".modal-backdrop:not(:last)").remove();
          AjaxModal.setReloadOnSuccess();
        },

        hide: function() {
          $(AjaxModal.modalHolderSelector)
            .find(AjaxModal.modalSelector)
            .modal("hide");
        },

        body: function() {
          return $(AjaxModal.modalHolderSelector).find(".modal-body");
        },

        setSpinner: function() {
          AjaxModal.body()
            .css("display", "none")
            .after(
              "<div class='text-center p-5 align-middle w-100 spinner'>" +
                '<i class="fa fa-spinner fa-spin fa-5x"></i>' +
                "</div>"
            );
        },

        removeSpinner: function() {
          $(AjaxModal.modalHolderSelector)
            .find(".spinner")
            .remove();
          AjaxModal.body().css("display", "block");
        },

        loadContent: function(location) {
          $.get(location)
            .done(AjaxModal.replaceWithData)
            .always(function(_, __, response) {
              AjaxModal.manageRedirection(response);
            })
            .fail(function(data) {
              AjaxModal.removeSpinner();
              AjaxModal.body().html(data.responseText);
            });
          return false;
        },

        formResponse: function(event, data, _, response) {
          if (AjaxModal.manageRedirection(response)) {
            return false;
          }
          AjaxModal.replaceWithData(data);
        },

        manageRedirection: function(response) {
          if (typeof response != "object") return;

          redirectLocation = response.getResponseHeader("Location");
          /* see Modalable::full_page_redirect_to()  */
          if (
            response.getResponseHeader("X-Kasaz-Full-Page-Redirect") == "true"
          ) {
            return AjaxModal.fullPageRedirection(redirectLocation);
          }

          if (redirectLocation) {
            AjaxModal.loadContent(redirectLocation);
            return true;
          }
        },

        fullPageRedirection: function(redirectLocation) {
          if (typeof Turbolinks != "undefined") {
            Turbolinks.clearCache();
            Turbolinks.visit(redirectLocation, { action: "replace" });
          } else {
            document.location = redirectLocation;
          }
        },

        replaceWithData: function(data) {
          if (typeof data != "undefined" && data != "") {
            $(AjaxModal.modalHolderSelector).html(data);
            event = new Event("ajax_modal:load");
            document.dispatchEvent(event);
          }
          AjaxModal.show();
        },

        setReloadOnSuccess: function() {
          var $success_el = $("[data-ajax-modal-reload-on-success]").eq(0);

          if ($success_el.parents(".modal").length) {
            setTimeout(function() {
              AjaxModal.hide();
              Turbolinks.reload(window.location);
            }, $success_el.data("ajax-modal-reload-on-success"));
          }
        },

        setReloadOnClose: function() {
          $(AjaxModal.modalHolderSelector)
            .find(AjaxModal.modalSelector)
            .on("hidden.bs.modal", function() {
              Turbolinks.reload(window.location);
            });
        }
      };

if (typeof Turbolinks != "undefined") {
  $(document).on("turbolinks:load", function() {
    AjaxModal.initialize();
  });
  $(document).on("turbolinks:before-cache", function() {
    AjaxModal.tearDown();
  });
} else {
  $(function() {
    AjaxModal.initialize();
  });
}
