== README

* Ruby version

  2.2.0

* System dependencies

  Postgres
  Redis
  Bundler

* Database creation/initialization

  bundle exec rake db:create
  bundle exec rake db:migrate
  bundle exec rake db:seed
  bundle exec rails s

* How to run the test suite

  bundle exec rake db:setup RAILS_ENV=test
  bundle exec rspec

* Services (job queues, cache servers, search engines, etc.)

  bundle exec sidekiq

* Deployment instructions

  See DEPLOY.md