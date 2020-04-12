module Sunrise
  module Models
    module Nameable
      extend ActiveSupport::Concern

      included do
        has_many :names,
                 -> { with_this_locale_first(I18n.locale) },
                 as: :nameable, dependent: :destroy

        scope :search_by_name,
              lambda { |query|
                where(
                  'id IN (?)',
                  Name.imageable_ids_for_label(self.model.name, query)
                )
              }

        def name(locale = nil)
          (locale.nil? ? names : names.with_this_locale_first(locale)).first
            &.label || default_name
        end

        def default_name
          'missing name'
        end
      end
    end
  end
end
