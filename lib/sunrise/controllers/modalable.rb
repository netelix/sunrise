# frozen_string_literal: true

# To be able to respond with a modal
module Sunrise
  module Controllers
    module Modalable
      extend ActiveSupport::Concern

      included do
        cattr_accessor :modal_layout

        before_action :add_response_in_modal_header

        self.modal_layout = 'ajax_modal'

        respond_to :html, :json, :flash

        def respond_with_modal(*args)
          self.force_to_respond_with_modal = true

          respond_with(args.extract_options!)
        end

        def respond_with(*args, &blk)
          return super(*args, &blk) unless respond_with_modal?
          add_response_in_modal_header
          options =
            args.extract_options!.merge(
              responder: AjaxModalResponder, layout: modal_layout
            )
          if options.key?(:location)
            head(:ok, options)
          else
            super(*args, options, &blk)
          end
        end

        def render(options = nil, extra_options = {}, &block)
          extra_options[:layout] = 'ajax_modal' if respond_with_modal?
          super(options, extra_options, &block)
        end

        def full_page_redirect_to(path, options = {})
          response.headers['X-Kasaz-Full-Page-Redirect'] = 'true'
          # we don't send redirection code so we
          # let ajax_modal.js manage the redirection
          redirect_to(path, options.merge(status: :ok))
        end

        def respond_with_modal?
          return false if request_made_from_non_modal_link?
          return true if ajax_modal_actions == :all_actions
          return true if force_to_respond_with_modal

          params[:action].in?(ajax_modal_actions)
        end

        def request_made_from_non_modal_link?
          return true unless request.xhr?
          return true if request.referer.blank?

          return false
        end

        def ajax_modal_actions
          []
        end

        def add_response_in_modal_header
          return unless respond_with_modal?

          response.headers['X-Kasaz-Response-In-Modal'] = 'true'
        end

        private

        attr_accessor :force_to_respond_with_modal
      end
    end
  end
end