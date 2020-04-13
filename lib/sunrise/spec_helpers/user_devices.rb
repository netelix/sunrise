# frozen_string_literal: true

Capybara.register_driver :chrome_desktop do |app|
  capabilities = {
    chromeOptions: { args: %w[headless disable-gpu no-sandbox], w3c: false }
  }
  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome, desired_capabilities: capabilities
  )
end
Capybara.register_driver :chrome_android_phone do |app|
  capabilities = {
    chromeOptions: {
      args: %w[headless disable-gpu no-sandbox user-agent=phoneHeadlessChrome],
      w3c: false
    }
  }
  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome, desired_capabilities: capabilities
  )
end
CHROME_DESKTOP = { name: :chrome_desktop, width: 1_280, height: 1_000 }.freeze
CHROME_ANDROID_PHONE = {
  name: :chrome_android_phone, width: 375, height: 812
}.freeze

IN_IFRAME = {
  name: :chrome_android_phone, width: 375, height: 812, in_iframe: true
}.freeze

NO_LAYOUT = {
  name: :chrome_android_phone, width: 375, height: 812, no_layout: true
}.freeze

USER_DEVICES = [CHROME_DESKTOP, CHROME_ANDROID_PHONE].freeze
