# frozen_string_literal: true

module Helpers
  # rspec-retry configuration, only for CI
  module RspecRetryConfig
    if ENV['RETRY']
      RSpec.configure do |config|
        # show retry status in spec process
        config.verbose_retry =
          true
        # show exception that triggers a retry if verbose_retry is set to true
        config.display_try_failure_messages = true

        # run retry only on features
        config.around :each, :js do |ex|
          ex.run_with_retry retry: 3
        end

        # callback to be run between retries
        config.retry_callback =
          proc do |ex|
            if ex.metadata[:js]
              # run some additional clean up task - can be filtered by metadata
              Capybara.reset!
            end
          end
      end
    end
  end
end
