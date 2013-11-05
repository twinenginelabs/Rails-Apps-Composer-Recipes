# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'controllers/test_helpers'
require 'features/test_helpers'
require 'models/test_helpers'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

Capybara.javascript_driver = :poltergeist

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  # All
  # ---

  config.before(:suite) do

  end

  # Controllers
  # -----------

  config.include Controller::TestHelpers, type: :controller
  config.include Devise::TestHelpers, type: :controller

  # By default authenticate a user through Devise. If being logged out is necessary
  # for one of your tests, use Devise's sign_out
  config.before(:each, type: :controller) do
    create_test_user
    sign_in test_user
  end

  # Features
  # --------

  config.include Feature::TestHelpers, type: :feature

  # Make a user
  config.before(:each, type: :feature) do
    create_test_admin
    create_test_user
  end

  # Detect missing translations
  config.after(:each, type: :feature) do
    missing_translations = page.body.scan(/translation missing: #{I18n.locale}\.(.*?)[\s<\"&]/)
    if missing_translations.any?
      puts "Found missing translations: #{missing_translations.inspect}"
      puts "In spec: #{example.location}"
    end
  end

  # Models
  # ------

  config.include Model::TestHelpers, type: :model

end

# Global Helpers

def create_test_admin
  @admin = User.where(email: "admin@twinenginelabs.com").first_or_create
  @admin.password = "password"
  @admin.roles << Role.find_or_create_by_name('Admin')
  @admin.save(validate: false) if @admin.new_record?
  @admin
end

def test_admin
  User.where(email: "admin@twinenginelabs.com").first || create_test_admin
end

def create_test_user
  @user = User.where(email: "user@twinenginelabs.com").first_or_create
  @user.password = "password"
  @user.roles << Role.find_or_create_by_name('User')
  @user.save(validate: false) if @user.new_record?
  @user
end

def test_user
  User.where(email: "user@twinenginelabs.com").first || create_test_user
end