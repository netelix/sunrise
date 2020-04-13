module Sunrise
  class BaseController < ActionController::Base
    layout 'application'

    around_action :switch_locale
    before_action :set_device_type,
                  :store_location,
                  :check_domain

    include Sunrise::Controllers::Helpers
  end
end
