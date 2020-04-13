# frozen_string_literal: true

RSpec.configure do |config|
  config.after(:each, type: :feature) do |scenario|
    if scenario.exception.present?
      timestamp = Time.zone.now.strftime('%Y-%m-%d-%H:%M:%S').to_s.parameterize
      screenshot_name =
        "screenshot-#{scenario.full_description.parameterize}-#{timestamp}.png"
      screenshot_path = "#{Rails.root.join('tmp/capybara')}/#{screenshot_name}"
      Capybara.page.save_screenshot(screenshot_path)
      puts ''
      puts "Failure screenshot: #{screenshot_path}"
      puts ''
    end
  end
end
