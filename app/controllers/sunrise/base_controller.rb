module Sunrise
  class BaseController < ActionController::Base
    layout 'application'

    around_action :switch_locale
    before_action :set_device_type,
                  :store_location,
                  :check_domain,
                  :store_first_visit_date
    helper_method :show_install_app_popup?

    include Sunrise::Controllers::Helpers

    def store_first_visit_date
      session[:first_visit] = DateTime.now if session[:first_visit].blank?
    end

    def show_install_app_popup?
      return if install_app_popup_shown?

      if (session[:first_visit].to_time + 1.hours) < DateTime.now
        session[:install_app_popup_shown] = true
      end
    end

    def install_app_popup_shown?
      session[:install_app_popup_shown]
    end
  end
end
