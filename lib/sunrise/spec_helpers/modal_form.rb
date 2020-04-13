# frozen_string_literal: true

module Sunrise
  module SpecHelpers
    module ModalForm
      def open_modal_form(url_or_path, within: within = 'body')
        within within do
          if url_or_path.include?('/')
            find(:xpath, "//a[@href='#{url_or_path}']").click
          elsif ((clickable = all(url_or_path)).present?)
            clickable.first.click
          else
            click_on(url_or_path)
          end
        end
        within '.modal-dialog' do
          yield
        end
      end

      def submit_modal_form(url_or_path, within: within = 'body')
        open_modal_form(url_or_path, within: within) do
          yield
          page.find("[type='submit']").click
        end
        wait_for_ajax
      end
    end
  end
end
