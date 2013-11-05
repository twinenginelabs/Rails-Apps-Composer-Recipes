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
  gsub_file file, /project_name/, "#{app_name}"
end

gsub_file "config/environments/staging.rb", /#{app_name}(.*).com/, "#{app_name.dasherize}#{$1}.com"
gsub_file "config/environments/production.rb", /#{app_name}(.*).com/, "#{app_name.dasherize}#{$1}.com"

create_file '.ruby-version', "#{RUBY_VERSION}\n" unless File.exist?('.ruby-version')
create_file '.ruby-gemset', "#{app_name}\n" unless File.exist?('.ruby-gemset')

__END__

name: tel_boilerplate
description: "A core boilerplate of code/configs that most apps will need/use"
author: Twin Engine Labs

category: other
