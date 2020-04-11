module Sunrise
  module Admin
    class BaseController < Sunrise::BaseController
    protect_from_forgery with: :exception

    layout "admin"
    before_action :authenticate_admin

    def authenticate_admin
      if (!current_user.present?) || (!current_user.admin?)
        redirect_to root_path
      end
    end
  end
  end
end
