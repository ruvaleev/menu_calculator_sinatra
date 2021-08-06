# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'
ENV['SINATRA_ENV'] = 'test'

require './config/environment'

module RSpecMixin
  include Rack::Test::Methods
  def app
    described_class
  end
end

RSpec.configure do |config|
  config.include RSpecMixin

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  # config.after(:each, type: :request) { Test::FakeHTTPClient.clear_class_variables }
end

require_all 'spec/support'
# require_all 'spec/shared'
