# frozen_string_literal: true

# Log in and log out
module Sunrise
  module Controllers
    class Sessions < Devise::SessionsController
      include Sunrise::Controllers::Helpers
      include Sunrise::Controllers::Modalable

      prepend_before_action :show_message_if_already_logged_in,
                            only: %i[new create]


      def ajax_modal_actions
        %w[new create]
      end

      def new
        self.resource =
          if params[:existing_account].present?
            User.new(email: params[:existing_account])
          else
            resource_class.new(sign_in_params)
          end
        clean_up_passwords(resource)
        yield resource if block_given?
      end

      def create
        self.resource = warden.authenticate!(auth_options)
        set_flash_message!(:notice, :signed_in)
        sign_in(resource_name, resource)
        yield resource if block_given?
        full_page_redirect_to after_login_or_signup_path
      end

      def show_message_if_already_logged_in
        return if current_user.blank?

        render :already_logged_in
      end

      def store_location; end
    end
  end
end
