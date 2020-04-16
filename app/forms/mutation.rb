class Mutation
  include ActiveModel::Model

  def initialize(fields = {})
    @fields = fields
    @fields.each do |k, v|
      instance_variable_set("@#{k}", nil)
      self.class.send(:attr_accessor, k)
    end
  end

  def initialize_checkbox_collection(attributable, type)
    send("#{type}_ids=", attributable.send("attrs_#{type}").map(&:id))
  end

  def initialize_descriptions(descriptionable)
    I18n.available_locales.map do |locale|
      send(
        "description_#{locale}=",
        descriptionable&.localized_description(locale)
      )
    end
  end

  def initialize_names(nameable)
    I18n.available_locales.map do |locale|
      send("name_#{locale}=", nameable&.names.find_by_lang(locale)&.label)
    end
  end

  def initialize_attribute_values(attributable, values)
    values = [values] unless values.is_a?(Array)
    values.each do |attribute|
      send("#{attribute}=", attributable.attribute_value(attribute))
    end
  end

  def export
    hash = {}
    @fields.each { |k, v| hash[k] = self.send(k) }
    hash
  end

  def set_required(required_fields)
    required_fields.each do |field, values|
      self.class.validates field, presence: true
    end
  end
end
