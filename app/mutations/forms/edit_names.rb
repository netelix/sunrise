module Forms
  class EditNames < Sunrise::Mutations::ProcessForm
    required do
      duck :nameable
      string :name_fr, empty: true
      string :name_en, empty: true
    end

    def validate
      validate_presence_of_current_locale_name
    end

    def execute
      save_names(nameable)
    end

    def initialize_form
      form.initialize_names(nameable)
    end

    def unpermitted_form_input_names
      %i[nameable]
    end
  end
end
