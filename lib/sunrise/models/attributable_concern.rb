module AttributableConcern
  extend ActiveSupport::Concern

  included do
    has_many :attr_maps, as: :attributable, dependent: :destroy
    has_many :attrs, -> { select('attributes.*, value') }, through: :attr_maps

    def method_missing(method, *args)
      if method.to_s.start_with?('attr_')
        attr_key = method.to_s.gsub('attr_', '')
        super unless Attr.key?(attr_key)

        attribute_value(attr_key)
      elsif method.to_s.start_with?('attrs_')
        attr_type = method.to_s.gsub('attrs_', '')
        super unless Attr.type?(attr_type)

        mapped_attributes_by_type(attr_type)
      else
        super
      end
    end

    def attr_maps_for_type(type)
      attr_maps.joins(:attr).includes(:attr).includes(attr: %i[names]).where(
        attributes: { type: type }
      )
    end

    def attr_map_for_attr(attr)
      attr_maps.find_by(attr: attr)
    end

    def attribute_value(key)
      mapped_attrs.find { |attr| attr.key == key.to_s }&.value
    end

    def attribute_value_by_id(id)
      mapped_attrs.find { |attr| attr.id == id }&.value
    end

    def mapped_attributes_by_type(type)
      mapped_attrs.select { |attr| attr.type == type.to_s }
    end

    def mapped_attrs
      @mapped_attrs ||= attrs.includes(:names).all
    end

    def set_attrs_for_type(attr_keys, type)
      attr_keys = [attr_keys] unless attr_keys.is_a?(Array)

      Attributables::SetAttributesForType.run!(
        attributable: self, type: type, attribute_keys: attr_keys
      )
    end
  end
end
