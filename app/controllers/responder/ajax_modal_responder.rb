# frozen_string_literal: true

module Sunrise::Controllers
  # this class allows controller to respond with a modal layout
  class AjaxModalResponder < ActionController::Responder
    cattr_accessor :modal_layout
    self.modal_layout = 'ajax_modal'

    def render(*args)
      options = args.extract_options!
      options[:layout] = modal_layout if request.xhr?
      controller.render(*args, options)
    end

    def default_render(*args)
      render(*args)
    end
  end
end
