module MutationValidateHelpers
  extend ActiveSupport::Concern

  included do
    def validate_object_has_no_dependecies(object, method)
      if object.send(method).size.positive?
        class_name = object.class.to_s.to_sym.downcase
        add_error(
          class_name,
          :custom,
          I18n.t(
            'mutations.errors.a_x_with_y_cant_be_delete',
            x: I18n.t("models.#{class_name}"), y: I18n.t("models.#{method}")
          )
        )
      end
    end
  end
end
