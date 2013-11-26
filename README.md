## Setup
    rvm gemset use <APP_NAME> --create
    gem install rails
    gem install rails_apps_composer
    export TEL_RAILS_APPS_COMPOSER_RECIPE_PATH=/path/to/your/recipes

## Examples

Standard boilerplate based app (hosted on Digital Ocean):

    rails_apps_composer new <APP_NAME> -l $TEL_RAILS_APPS_COMPOSER_RECIPE_PATH -r tel_boilerplate tel_rubber tel_rubber_digitalocean

 Standard boilerplate based app (hosted on AWS) (TODO):

    rails_apps_composer new <APP_NAME> -l $TEL_RAILS_APPS_COMPOSER_RECIPE_PATH -r tel_boilerplate tel_rubber tel_rubber_aws

Standard boilerplate based app (hosted on Heroku) (TODO):

    rails_apps_composer new <APP_NAME> -l $TEL_RAILS_APPS_COMPOSER_RECIPE_PATH -r tel_boilerplate tel_rubber tel_heroku

Custom app:

    rails_apps_composer new <APP_NAME>