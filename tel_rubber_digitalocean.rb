@tel_recipe_path = ENV['TEL_RAILS_APPS_COMPOSER_RECIPE_PATH']
raise "You must define TEL_RAILS_APPS_COMPOSER_RECIPE_PATH in order to use this recipe" if @tel_recipe_path.blank?

FileUtils.cp("#{File.expand_path(@tel_recipe_path)}/tel_rubber_digitalocean/DEPLOY.md", ".")

append_to_file "config/rubber/rubber.yml", "\n\n# --- Digital Ocean ---\n\n"
append_to_file "config/rubber/rubber.yml", File.read("#{File.expand_path(@tel_recipe_path)}/tel_rubber_digitalocean/config/rubber/rubber.yml")

gsub_file "config/rubber/rubber.yml", /project-name/, "#{app_name.dasherize}"

__END__

name: tel_rubber_digitalocean
description: "Setup your app to be deployed to Digital Ocean via Rubber"
author: Twin Engine Labs

requires: [tel_rubber]
run_after: [tel_rubber]
category: hosting
