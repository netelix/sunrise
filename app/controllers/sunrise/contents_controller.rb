module Sunrise
  class ContentsController < BaseController
    include Sunrise::Controllers::ModalForm

    def mutation_form_class
      Forms::EditContents
    end

    def initialize_values
      { contentable: contentable }
    end

    def resource
      :contentable
    end

    private

    def check_authorization
      render 'shared/access_denied' if cannot? :edit, contentable
    end

    def contentable
      @contentable ||=
        Content.new(
          contentable_type: params[:contentable_type],
          contentable_id: params[:contentable_id]
        )
          .contentable
    end
  end
end
