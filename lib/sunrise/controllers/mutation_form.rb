# frozen_string_literal: true

require 'active_support/concern'

module Sunrise
  module Controllers
    module MutationForm
      extend ActiveSupport::Concern

      included do
        helper_method :mutation_form
        helper_method :form_params
        helper_method :resource

        def edit
          mutation_form.initialize_form
        end

        def new
          mutation_form.initialize_form
        end

        def create
          outcome = process_mutation_form
          manage_mutation_form_outcome(outcome)
        end

        def update
          outcome = process_mutation_form
          manage_mutation_form_outcome(outcome)
        end

        protected

        def manage_mutation_form_outcome(outcome)
          if outcome.success?
            after_process_form_success
          else
            render after_mutation_process_failed_template
          end
        end

        def process_mutation_form
          mutation_form.process_form(update_params.merge(initialize_values))
        end

        def mutation_form
          @mutation_form ||= mutation_form_class.new(initialize_values)
        end

        def after_process_form_success
          render after_mutation_process_template
        end

        def mutation_form_class
          raise 'Override me'
        end

        def initialize_values
          raise 'Override me'
        end

        def resource
          raise 'Override me'
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
              id: mutation_form.class.to_s.underscore.gsub('/', '-').gsub('_', '-')
            }
          }
        end

        def post_method
          :put
        end

        def after_mutation_process_template
          case params[:action].to_sym
          when :update, :create
            :edit
          when :destroy
            'shared/alert_success'
          end
        end

        def after_mutation_process_failed_template
          case params[:action].to_sym
          when :create
            :new
          when :update
            :edit
          when :destroy
            'shared/alert_success'
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