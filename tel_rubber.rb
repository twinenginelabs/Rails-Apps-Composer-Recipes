@tel_recipe_path = ENV['TEL_RAILS_APPS_COMPOSER_RECIPE_PATH']
raise "You must define TEL_RAILS_APPS_COMPOSER_RECIPE_PATH in order to use this recipe" if @tel_recipe_path.blank?

FileUtils.cp_r(Dir.glob("#{File.expand_path(@tel_recipe_path)}/tel_rubber/*"), '.')

add_gem 'rubber'

gsub_file "config/deploy.rb", /project_name/, "#{app_name}"
gsub_file "config/rubber/rubber.yml", /project_name/, "#{app_name}"
gsub_file "config/rubber/common/rubber.profile", /project_name/, "#{app_name}"
gsub_file "config/rubber/role/nginx/unicorn_nginx.conf", /project_name/, "#{app_name}"

__END__

name: tel_rubber
description: "Setup your app to be deployed via Rubber"
author: Twin Engine Labs

category: deploying
