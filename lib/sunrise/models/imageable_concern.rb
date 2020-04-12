module ImageableConcern
  extend ActiveSupport::Concern

  included do
    has_many :images, as: :imageable, dependent: :destroy

    # prevent n+1 database calls :
    # https://jasoncharnes.com/eager-loading-querying-against-activestorage-attachments/
    has_many :picture_attachments, through: :images
    has_many :picture_blobs, through: :images

    scope :with_image,
          lambda {
            includes(:images).includes(:picture_attachments).includes(
              :picture_blobs
            )
          }

    def image
      images.first || images.new
    end

    def imageable_params
      { imageable_type: self.class.to_s, imageable_id: id }
    end
  end
end
