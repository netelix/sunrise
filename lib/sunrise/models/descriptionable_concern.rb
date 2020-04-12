module DescriptionableConcern
  extend ActiveSupport::Concern

  included do
    has_one :desc, -> { where(lang: I18n.locale) }, as: :descriptionable
    has_many :descs, as: :descriptionable, dependent: :destroy

    def description
      desc&.text
    end

    def localized_description(locale)
      descs.find_by_lang(locale)&.text
    end
  end
end
