module Contentables
  class SetContent < Mutations::Command
    required do
      string :locale
      duck :contentable
      string :data, empty: true
    end

    def execute
      if data.empty?
        existing_content&.destroy!
      else
        existing_content&.update(data: data) || existing_contents.create!(data: data)
      end
      contentable.touch
    end

    def existing_content
      existing_contents.first
    end

    def existing_contents
      contentable.contents.where(locale: locale)
    end
  end
end
