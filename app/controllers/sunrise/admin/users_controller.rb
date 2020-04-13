module Sunrise
  module Admin
    class UsersController < BaseController
      include Sunrise::Controllers::TokenLogin
      include Sunrise::Controllers::ModalForm

      helper_method :users, :user, :live_sessions

      def new
        mutation_form.initialize_form
        render :edit
      end

      def destroy
        Users::Destroy.run!(user: user)
        after_process_form_success
      end

      def post_method
        case params[:action].to_sym
        when :new
          :post
        when :edit, :update
          :put
        end
      end

      def show; end

      def after_mutation_process_failed_template
        case params[:action].to_sym
        when :create
          :edit
        when :update
          :edit
        when :destroy
          'shared/alert_success'
        end
      end

      def ajax_modal_actions
        %w[update edit create new destroy]
      end

      def mutation_form_class
        ::Forms::EditUser
      end

      def initialize_values
        { user: user }
      end

      def index; end

      def suggest
        render json: User.by_text(params[:term]).limit(10).map do |user|
          [label: "#{user.fname} #{user.lname}", value: u.id]
        end
      end

      def users
        User.all.page params[:page]
      end

      def user
        User.find_by_id(params[:id])
      end

      def resource
        :user
      end
    end
  end
end
