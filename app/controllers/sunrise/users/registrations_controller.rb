# frozen_string_literal: true

# Controller to customize the Devise registration flow
module Sunrise
  module Controllers

  class RegistrationsController < Devise::RegistrationsController
    include Sunrise::Controllers::Modalable

    prepend_before_action :require_no_authentication, only: %i[new create cancel]
    prepend_before_action :authenticate_scope!, only: %i[edit update destroy]
    skip_before_action :verify_authenticity_token, only: :create

    helper_method :registering_as_an_agent?, :agency_resource

    def ajax_modal_actions
      %w[new create]
    end

    def create
      if registering_from_create_a_listing_form?
        response_for_listings_new
      else
        response_for_all_other_cases
      end
    end

    def destroy
      if resource.destroy
        Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
        yield resource if block_given?
        flash[:notice] = I18n.t('devise.registrations.destroyed')
        redirect_to '/'
      else
        redirect_to "/#{I18n.t('routes.my_account')}"
      end
    end

    protected

    def response_for_listings_new
      outcome = Users::CreateFromCreateAListingForm.run(user_params)

      response.headers['Content-Type'] = 'application/json'

      if outcome.success?
        self.resource = outcome.result

        sign_up(resource_name, resource)
        render json: { success: true }
      else
        if outcome.errors.symbolic.values.include?(:taken)
          flash[:notice] = t('.existing_account')
        end
        show_mutation_error_messages_in_flash(outcome, 'mutations.user.create.')
        render json: { success: false, errors: outcome.errors.message }
      end
    end

    def response_for_all_other_cases
      outcome = registering_as_an_agent? ? create_agent : create_user

      if outcome.success?
        self.resource = outcome.result

        flash[:ga_user_created] = 'from Register form'
        flash[:fb_CompleteRegistration] = true

        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)

        full_page_redirect_to after_sign_up_path
      else
        self.resource = User.new(sign_up_params)
        @agency_resource = Agency.new(agency_params) if registering_as_an_agent?

        clean_up_passwords resource

        show_mutation_error_messages_in_flash(outcome, 'mutations.user.create.')
        render :new
      end
    end

    def create_user
      Users::CreateFromUserRegistrationForm.run(user_params)
    end

    def create_agent
      Users::CreateFromAgentRegistrationForm.run(
        user_params.merge(agency_name: agency_params[:name])
      )
    end

    def sign_up_params
      params.require(:user).permit(
        :first_name,
        :email,
        :password,
        :password_confirmation,
        # fields coming from angular creation process
        :agent,
        :agency_name,
        :surname_1,
        :surname_2,
        :phone
      )
    end

    def user_params
      sign_up_params.to_h.merge(
        signup_origin: session[:current_origin],
        created_on_mobile: browser.device.mobile?,
        user_agent: request.headers['HTTP_USER_AGENT']
      )
    end

    def agency_params
      params.require(:agency).permit(:name)
    end

    def after_sign_up_path
      registering_as_an_agent? ? edit_agency_path : after_login_or_signup_path
    end

    def agency_resource
      return unless registering_as_an_agent?

      @agency_resource ||= Agency.new(agents: [resource])
    end

    def registering_as_an_agent?
      params[:agent]
    end

    def registering_from_create_a_listing_form?
      params[:from_create_a_listing_form]
    end
  end
  end
end
