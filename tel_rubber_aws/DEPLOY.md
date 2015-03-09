== DEPLOY

* Provisioning

  1) Create the S3 bucket
    Make sure to use U.S. Standard as the region
    Bucket name should be <project-name>-staging

  2) Setup missing environment variables in rubber.profile

  3) Export those environment variables into your shell

  4) Ensure your aws key pair is setup and/or downloaded
    => ~/.ssh/aws/<project-name>.pem
    => ~/.ssh/aws/<project-name>.pub

  5) Create the server
    => RUBBER_ENV=staging ALIAS=staging-master ROLES=background_worker,common,db:primary=true,nginx,postgresql,postgresql_master,redis,redis_master,sidekiq,unicorn,web,app,whenever cap rubber:create
    # If you have issues with create, and figure them out, run `RUBBER_ENV=staging cap rubber:refresh` to pick up where you left off.

  6) Rename the instance via AWS UI
    ie: staging-master becomes <project-name>-staging-master

  7) Add the created instance-staging to source control
    => git add -A; git commit -m  "Add staging instance digest."; git push

  8) Provision the server
    => RUBBER_ENV=staging cap rubber:bootstrap

* Deploying

  1) RUBBER_ENV=staging cap deploy:migrations