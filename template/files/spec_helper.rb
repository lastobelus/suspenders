require 'spork'

Spork.prefork do

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'

  require File.expand_path("../../config/environment", __FILE__)

  require 'active_record/connection_adapters/sqlite3_adapter'
  require 'rspec/mocks'
  require 'rspec/core/expecting/with_rspec'
  require 'rspec/core/formatters/documentation_formatter'
  require 'rspec/core/formatters/base_text_formatter'
  require 'rspec/core/mocking/with_rspec'
  require 'rspec/core/expecting/with_rspec'
  require 'rspec/expectations'
  require 'rspec/matchers'
  require 'rspec/core/expecting/with_rspec'
  require 'active_support/secure_random'
  require 'mail'
  require 'action_mailer'
  require 'action_mailer/tmail_compat'
  require 'action_mailer/collector'
  require 'erb'
  require 'factory_girl'

  require 'rspec/core/formatters/base_text_formatter'
  require 'rspec/core/formatters/progress_formatter'
  require 'mime/types'
  require 'treetop'
  require 'rspec/core/expecting/with_rspec'
  require 'mail/fields/common/common_address'
  
  require 'rspec/rails'
  # require 'remarkable/active_record'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :mocha

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true
  end
  
  # module Kernel
  #   def require_with_trace(*args)
  #     start = Time.now.to_f
  #     @indent ||= 0
  #     @indent += 2
  #     require_without_trace(*args)
  #     @indent -= 2
  #     Kernel::puts "#{' '*@indent}#{((Time.now.to_f - start)*1000).to_i} #{args[0]}"
  #   end
  #   alias_method_chain :require, :trace
  # end
end