module Sunrise
  module Models
    module Contentable
      extend ActiveSupport::Concern

      included do
        has_many :contents, as: :contentable, dependent: :destroy

        def content
          contents.where(locale: I18n.locale).first&.data
        end

        def html_content(options = {})
          content&.html_safe || options[:default]
        end

        def edit_content_path
          url_helpers.contents_edit_path(
              contentable_type: self.class.name, contentable_id: id
          )
        end

        def localized_content(locale)
          contents.find_by_locale(locale)&.data
        end
      end
    end
  end
end
