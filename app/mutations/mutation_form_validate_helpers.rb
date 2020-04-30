module MutationFormValidateHelpers
  extend ActiveSupport::Concern

  included do
    def validate_presence_of_current_locale_description
      field = "description_#{locales_with_current_first.first}"
      add_error(field, :empty) if field_empty?(field)
    end

    def validate_presence_of_current_locale_content
      field = "content_#{locales_with_current_first.first}"
      add_error(field, :empty) if field_empty?(field)
    end

    def validate_presence_of_current_locale_name
      field = "name_#{locales_with_current_first.first}"
      add_error(field, :empty) if field_empty?(field)
    end

    def field_empty?(field)
      send(field)&.strip_tags&.squish&.strip&.empty?
    end

    def validate_already_in_use(value, field, model, object = nil)
      request = model.where(field => value)
      request = request.where.not(id: object.id) if object.present?

      if request.size.positive?
        add_error(field, :custom, I18n.t('mutations.errors.already_in_use'))
      end
    end

    def validate_in_options(field)
      unless(send(field).to_s.in?(send("#{field}_select_options").to_h.values.map(&:to_s)))
        add_error(field, :custom, I18n.t('mutations.errors.not_in_options'))
      end
    end

    def validate_link(field)
      unless(send(field).match?(/^http[s]{0,1}\:\/\//))
        add_error(field, :custom, I18n.t('mutations.errors.link_must_begin_with_http'))
      end
    end
  end
end
