module Forms
  class EditContents < Sunrise::Mutations::ProcessForm
    required do
      duck :contentable
      string :content_fr, empty: true
      string :content_en, empty: true
    end

    def validate
      validate_presence_of_current_locale_content
    end

    def execute
      save_contents(contentable)
    end

    def initialize_form
      form.initialize_contents(contentable)
    end

    def unpermitted_form_input_names
      %i[contentable]
    end
  end
end
