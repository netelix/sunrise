# frozen_string_literal: true

require 'active_support/concern'
module Sunrise
  module Controllers
    module ModalForm
      extend ActiveSupport::Concern

      included do
        helper_method :modal_form_params

        include Modalable
        include MutationForm

        def ajax_modal_actions
          :all_actions
        end

        def modal_form_params
          form_params.tap do |object|
            object[:local] = false
            object[:remote] = true
            object[:html]['data-modal'] = true
          end
        end

        protected

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