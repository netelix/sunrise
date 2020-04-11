# frozen_string_literal: true

module Sunrise
  module Controllers
    # Those helpers are convenience methods added to ApplicationController.
    module Helpers
      extend ActiveSupport::Concern

      module ClassMethods
      end


      # Return true if it's a sunrise_controller. false to all controllers unless
      # the controllers defined inside sunrise. Useful if you want to apply a before
      # filter to all controllers, except the ones in sunrise:
      #
      #   before_action :my_filter, unless: :sunrise_controller?
      def sunrise_controller?
        is_a?(::SunriseController)
      end
    end
  end
end