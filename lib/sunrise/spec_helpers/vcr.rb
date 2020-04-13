# frozen_string_literal: true

module Helpers
  # VCR configuration and RSpec hook
  module VCRConfig
    VCR.configure do |config|
      config.cassette_library_dir = 'fixtures/vcr_cassettes'
      config.hook_into :webmock

      config.ignore_request do |request|
        URI(request.uri).hostname == '127.0.0.1'
      end
    end

    RSpec.configure do |config|
      config.around(:each, :with_vcr) do |example|
        # CI fires new requests for some reason, this fixes it
        options =
          if example.metadata[:record_new_vcr_episodes] ||
             ENV['RECORD_NEW_VCR_EPISODES']
            { record: :new_episodes }
          else
            {}
          end
        VCR.use_cassette(example.full_description, options) { example.run }
      end
    end
  end
end
