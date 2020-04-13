# frozen_string_literal: true

require 'sidekiq/testing'

RSpec.configure do |config|
  config.before(:each) { Sidekiq::Worker.clear_all }

  config.around(:each, :with_inline_sidekiq) do |example|
    Sidekiq::Testing.inline! { example.run }
  end
end
