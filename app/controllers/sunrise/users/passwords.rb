# frozen_string_literal: true

# Controller to customize the Devise password flow

module Sunrise
  module Controllers
    class Passwords < Devise::PasswordsController
      include Sunrise::Controllers::Modalable

      def ajax_modal_actions
        %w[new create]
      end

      def store_location; end
    end
  end
end
