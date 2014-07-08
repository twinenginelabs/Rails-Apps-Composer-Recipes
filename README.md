## Setup
    export TEL_RAILS_APPS_COMPOSER_RECIPE_PATH=/path/to/this/folder
    
    # rvm
    rvm install 2.1.2
    rvm gemset use <app_name> --create

    # rbenv
    rbenv install 2.1.2
    rbenv local 2.1.2

    gem install rails -v 4.1.1
    gem install rails_apps_composer

## Examples

Standard boilerplate based app (hosted on Digital Ocean):

    rails_apps_composer new <app_name> -q -l $TEL_RAILS_APPS_COMPOSER_RECIPE_PATH -d $TEL_RAILS_APPS_COMPOSER_RECIPE_PATH/defaults.yml -r tel_boilerplate tel_rubber tel_rubber_digitalocean

Standard boilerplate based app (hosted on AWS) (TODO):

    rails_apps_composer new <app_name> -q -l $TEL_RAILS_APPS_COMPOSER_RECIPE_PATH -d $TEL_RAILS_APPS_COMPOSER_RECIPE_PATH/defaults.yml -r tel_boilerplate tel_rubber tel_rubber_aws

Standard boilerplate based app (hosted on Heroku) (TODO):

    rails_apps_composer new <app_name> -q -l $TEL_RAILS_APPS_COMPOSER_RECIPE_PATH -d $TEL_RAILS_APPS_COMPOSER_RECIPE_PATH/defaults.yml -r tel_boilerplate tel_rubber tel_heroku

Custom app:

    rails_apps_composer new <app_name>