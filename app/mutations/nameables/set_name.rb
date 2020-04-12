module Nameables
  class SetName < Mutations::Command
    required do
      string :lang
      duck :nameable
      string :name, empty: true
    end

    def execute
      if name.empty?
        existing_name&.destroy!
      else
        existing_name&.update(label: name) || existing_names.create!(label: name)
      end
    end

    def existing_name
      existing_names.first
    end

    def existing_names
      nameable.names.where(lang: lang)
    end
  end
end
