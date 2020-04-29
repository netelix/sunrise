# frozen_string_literal: true
require 'browser'

module Sunrise
  module Controllers
    # Those helpers are convenience methods added to ApplicationController.
    module Helpers
      extend ActiveSupport::Concern

      included do
        helper_method :browser

        def switch_locale(&action)
          locale = params[:locale] || I18n.default_locale
          I18n.with_locale(locale, &action)
        end

        def set_device_type
          request.variant = :phone if request_from_mobile?
        end

        def request_from_mobile?
          browser.device.mobile?
        end

        def store_location
          return unless request.get?
          if params[:controller].in?(%i[sessions passwords registrations])
            return
          end

          path = request.fullpath
          session[:previous_url] = path
        end

        def after_login_or_signup_path
          return admin_index_path if current_user.admin?
          session[:previous_url] || root_path
        end

        def check_domain
          return unless Rails.env.production?

          redirect_to "https://#{ENV['DOMAIN']}" unless request.ssl?
          unless request.host == ENV['DOMAIN']
            redirect_to "https://#{ENV['DOMAIN']}"
          end
        end

        def browser
          @browser ||=
            Browser.new(request.user_agent)
        end
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
