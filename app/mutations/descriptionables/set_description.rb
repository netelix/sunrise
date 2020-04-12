module Descriptionables
  class SetDescription < Mutations::Command
    required do
      string :lang
      duck :descriptionable
      string :description, empty: true
    end

    def execute
      if description.strip_tags.squish.strip.empty?
        existing_description&.destroy!
      else
        existing_description&.update(text: description) ||
          descriptionable.descs.create!(text: description, lang: lang)
      end
    end

    def existing_description
      descriptionable.descs.find_by_lang(lang)
    end
  end
end
