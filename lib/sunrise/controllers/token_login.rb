module Sunrise
  module Controllers
    module TokenLogin
      extend ActiveSupport::Concern

      included do
        def check_login_token
          if params[:token].present?
            decoded_token = JWT.decode params[:token], Rails.application.config.token_secret, true, {algorithm:'HS256'}
            if decoded_token.first.has_key?('user_id') && decoded_token.first.has_key?('login') && decoded_token.first['login'] = true
              sign_in(:user, User.find(decoded_token.first['user_id']))
              redirect_to url_for( request.params.merge({token: nil}) )
            end
          end
        end
      end
    end
  end
end