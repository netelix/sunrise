module MutationFormSaveHelpers
  extend ActiveSupport::Concern

  included do
    def save_names(nameable)
      I18n.available_locales.each do |locale|
        ::Nameables::SetName.run!(
          nameable: nameable, name: send("name_#{locale}"), lang: locale
        )
      end
    end

    def save_descriptions(descriptionable)
      I18n.available_locales.each do |locale|
        ::Descriptionables::SetDescription.run!(
          descriptionable: descriptionable,
          description: send("description_#{locale}"),
          lang: locale
        )
      end
    end

    def save_attributes_values(attributable, type, attribute_keys)
      attributes_keys_with_values =
        attribute_keys.map { |key| [key, send(key)] }.reject do |_, value|
          !value.present?
        end

      Attributables::SetAttributesWithValuesForType.run!(
        attributable: attributable,
        attribute_keys_with_values: attributes_keys_with_values,
        type: type
      )
    end

    def save_attribute_maps(attributable, type)
      Attributables::SetAttributesForType.run!(
        attributable: attributable,
        type: type,
        attribute_ids: send("#{type}_ids").reject(&:blank?)
      )
    end
  end
end
