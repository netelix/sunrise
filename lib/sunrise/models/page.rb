module Sunrise
  module Models
    module Page
      extend ActiveSupport::Concern
      included do
        include Sunrise::Models::Nameable
        include Sunrise::Models::Contentable
      end
    end
  end
end
