# frozen_string_literal: true

module Sunrise
  class Engine < ::Rails::Engine
    config.sunrise = Sunrise

    # Force routes to be loaded if we are doing any eager load.
    config.before_eager_load do |app|
      app.reload_routes!
    end

    initializer "sunrise.url_helpers" do
      Sunrise.include_helpers(Sunrise::Controllers)
    end
  end
end