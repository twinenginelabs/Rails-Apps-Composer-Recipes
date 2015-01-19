## Setup
    export TEL_RAILS_APPS_COMPOSER_RECIPE_PATH=/path/to/this/folder
    
    # rvm
    rvm install 2.2.0
    rvm gemset use <app_name> --create

    # rbenv
    rbenv install 2.2.0
    rbenv local 2.2.0

    # chruby
    ruby-install ruby 2.2.0
    chruby 2.2.0

    gem install rails -v 4.2.0
    gem install rails_apps_composer

## Examples

Standard boilerplate based app (hosted on Digital Ocean):

    rails_apps_composer new <app_name> -q -l $TEL_RAILS_APPS_COMPOSER_RECIPE_PATH -d $TEL_RAILS_APPS_COMPOSER_RECIPE_PATH/defaults.yml -r tel_boilerplate tel_rubber tel_rubber_digitalocean

Standard boilerplate based app (hosted on AWS):

    rails_apps_composer new <app_name> -q -l $TEL_RAILS_APPS_COMPOSER_RECIPE_PATH -d $TEL_RAILS_APPS_COMPOSER_RECIPE_PATH/defaults.yml -r tel_boilerplate tel_rubber tel_rubber_aws

Standard boilerplate based app (hosted on Heroku) (TODO):

    rails_apps_composer new <app_name> -q -l $TEL_RAILS_APPS_COMPOSER_RECIPE_PATH -d $TEL_RAILS_APPS_COMPOSER_RECIPE_PATH/defaults.yml -r tel_boilerplate tel_heroku

Custom app:

    rails_apps_composer new <app_name>