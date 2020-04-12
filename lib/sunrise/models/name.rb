module Sunrise
  module Models
    module Name
      extend ActiveSupport::Concern

      included do
        belongs_to :nameable, polymorphic: true

        scope :with_this_locale_first,
              lambda { |locale|
                reorder(
                  Arel.sql(
                    "
      CASE lang
      WHEN '#{locale}' THEN 1
      WHEN 'fr' THEN 2
      WHEN 'en' THEN 3
      ELSE 4
      END ASC"
                  )
                )
              }
      end
    end
  end
end
