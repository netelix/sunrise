module Sunrise
  module Models
    module User
      extend ActiveSupport::Concern

      included do
        # Include default devise modules. Others available are:
        # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
        devise :database_authenticatable,
               :registerable,
               :recoverable,
               :rememberable,
               :validatable

        scope :admins, -> { where(admin: true) }
      end
    end
  end
end
