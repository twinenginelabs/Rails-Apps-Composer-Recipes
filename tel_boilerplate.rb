@tel_recipe_path = ENV['TEL_RAILS_APPS_COMPOSER_RECIPE_PATH']
raise "You must define TEL_RAILS_APPS_COMPOSER_RECIPE_PATH in order to use this recipe" if @tel_recipe_path.blank?

FileUtils.cp_r(Dir.glob("#{File.expand_path(@tel_recipe_path)}/tel_boilerplate/*"), '.')

Dir.glob("**/*").reject { |file| File.directory?(file) }.each do |file|
  gsub_file file, /ProjectName/, "#{app_name.camelize}"
end

Dir.glob("**/*").reject { |file| File.directory?(file) }.each do |file|
  gsub_file file, /Project Name/, "#{app_name.titleize}"
end

Dir.glob("**/*").reject { |file| File.directory?(file) }.each do |file|
  gsub_file file, /PROJECT_NAME/, "#{app_name.upcase}"
end

Dir.glob("**/*").reject { |file| File.directory?(file) }.each do |file|
  gsub_file file, /project_name/, "#{app_name}"
end

gsub_file "Gemfile", /RUBY_VERSION/, "#{RUBY_VERSION}"
gsub_file "Gemfile", /sqlite3/, "pg"

gsub_file "config/environments/production.rb", "http://assets.example.com", "//s3.amazonaws.com/\#{ENV['FOG_DIRECTORY']}"
uncomment_lines 'config/environments/production.rb', /s3.amazonaws.com/
FileUtils.cp "config/environments/production.rb", "config/environments/staging.rb"

insert_into_file "config/application.rb", after: "class Application < Rails::Application\n" do
  <<-EOS
    def self.name
      "#{app_name.titleize}"
    end

    require "\#{config.root}/lib/possessive"

    config.paths["config/routes.rb"].concat Dir[Rails.root.join("config/routes/*.rb")]
    config.autoload_paths += %W(\#{config.root}/lib)

    config.time_zone = 'Central Time (US & Canada)'

    config.generators do |g|
      g.integration_tool false
      g.performance_tool false
      g.helper false
      g.test_framework :rspec,
        view_specs: false,
        routing_specs: false
    end

  EOS
end

insert_into_file "config/environments/production.rb", after: "Rails.application.configure do\n" do
  <<-EOS
  config.host = "#{app_name}.com"
  config.action_mailer.default_url_options = { :host => config.host }

  EOS
end

insert_into_file "config/environments/staging.rb", after: "Rails.application.configure do\n" do
  <<-EOS
  config.host = "#{app_name}.twinenginelabs.com"
  config.action_mailer.default_url_options = { :host => config.host }

  EOS
end

insert_into_file "config/environments/development.rb", after: "Rails.application.configure do\n" do
  <<-EOS
  config.host = "localhost:3000"
  config.action_mailer.default_url_options = { :host => config.host }
  config.action_mailer.delivery_method = :letter_opener

  EOS
end

insert_into_file "config/environments/test.rb", after: "Rails.application.configure do\n" do
  <<-EOS
  config.host = "localhost:3000"
  config.action_mailer.default_url_options = { :host => config.host }
  
  EOS
end

append_to_file 'config/database.yml' do
  <<-EOS

staging:
  <<: *default
  database: #{app_name}_staging

  EOS
end

append_to_file 'config/secrets.yml' do
  <<-EOS

staging:
  secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>

  EOS
end

create_file '.ruby-version', "#{RUBY_VERSION}\n" unless File.exist?('.ruby-version')
create_file '.ruby-gemset', "#{app_name}\n" unless File.exist?('.ruby-gemset')

__END__

name: tel_boilerplate
description: "A core boilerplate of code/configs that most apps will need/use"
author: Twin Engine Labs

category: other