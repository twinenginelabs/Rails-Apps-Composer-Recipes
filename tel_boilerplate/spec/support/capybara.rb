require 'capybara/rspec'
require 'capybara/poltergeist'

Capybara.configure do |config|
  config.javascript_driver = :poltergeist
  config.default_host = "http://localhost"
end