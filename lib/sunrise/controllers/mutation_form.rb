# frozen_string_literal: true

require 'active_support/concern'

module Sunrise
  module Controllers
    module MutationForm
      extend ActiveSupport::Concern

      module ClassMethods
        def template_for_action(action, template)
          self.template_for_actions[action] = template
        end
      end

      included do
        mattr_accessor :template_for_actions, default: {}

        helper_method :mutation_form
        helper_method :form_params
        helper_method :resource

        def edit
          mutation_form.initialize_form
        end

        def new
          mutation_form.initialize_form
          render template_for_current_action
        end

        def create
          outcome = process_mutation_form
          manage_mutation_form_outcome(outcome)
        end

        def update
          outcome = process_mutation_form
          manage_mutation_form_outcome(outcome)
        end

        def destroy
          run_destroy_mutation
          after_process_form_success
        rescue Mutations::ValidationException => exception
          render 'shared/alert_danger', locals: { message: exception.message }
        end

        def template_for_current_action
          self.template_for_actions[params[:action].to_sym]
        end

        protected

        def manage_mutation_form_outcome(outcome)
          if outcome.success?
            after_process_form_success(outcome)
          else
            render after_mutation_process_failed_template
          end
        end

        def process_mutation_form
          process_that_mutation_form(
            mutation_form,
            update_params.merge(initialize_values)
          )
        end

        def mutation_form
          @mutation_form ||= mutation_form_class.new(initialize_values)
        end

        def after_process_form_success(outcome = nil)
          render after_mutation_process_template
        end

        def mutation_form_class
          raise 'Override me'
        end

        def initialize_values
          # override this method to set default values to the form
          {}
        end

        def resource
          raise "You must define the method 'resource' for this controller"
        end

        def form_params
          {
            model: mutation_form.form,
            scope: resource,
            remote: false,
            local: true,
            url: url_for(controller: params[:controller], action: form_action),
            method: post_method,
            html: {
              id:
                mutation_form.class.to_s.underscore.gsub('/', '-').gsub(
                  '_',
                  '-'
                )
            }
          }
        end

        def after_mutation_process_failed_template
          case params[:action].to_sym
          when :create
            template_for_current_action
          when :update
            :edit
          when :destroy
            'shared/alert_success'
          end
        end

        def after_mutation_process_template
          case params[:action].to_sym
          when :update, :create
            template_for_current_action
          when :destroy
            'shared/alert_success'
          end
        end

        def post_method
          case params[:action].to_sym
          when :new
            :post
          when :edit, :update
            :put
          end
        end

        def form_action
          case params[:action].to_sym
          when :edit, :update
            :update
          when :new, :create
            :create
          when :destroy
            :destroy
          end
        end

        def update_params
          return {} unless params[resource].present?

          params.require(resource).permit(mutation_form.permitted_params)
        end
      end
    end
  end
end