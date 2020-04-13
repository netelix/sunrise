# frozen_string_literal: true

# Helpers to log in and out

module Sunrise
  module SpecHelpers
    module DeviseFeature
      include Warden::Test::Helpers

      def sign_in(resource_or_scope, resource = nil)
        resource ||= resource_or_scope
        scope = Devise::Mapping.find_scope!(resource_or_scope)
        login_as(resource, scope: scope)
      end

      def sign_out(resource_or_scope)
        scope = Devise::Mapping.find_scope!(resource_or_scope)
        logout(scope)
      end
    end
  end
end