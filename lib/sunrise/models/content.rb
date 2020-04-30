module Sunrise
  module Models
    module Content
      extend ActiveSupport::Concern

      included do
        belongs_to :contentable, polymorphic: true
      end
    end
  end
end
