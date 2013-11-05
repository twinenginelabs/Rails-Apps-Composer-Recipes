require File.expand_path('../../../config/environment', __FILE__)

namespace :db do
  desc "Load the fake data from db/fake.rb"
  task :fake => :environment do
    fake_file = File.join(Rails.root, 'db', 'fake.rb')
    load(fake_file) if File.exist?(fake_file)
  end
end