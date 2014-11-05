== DEPLOY

* Provisioning

  1) Create the S3 bucket
    Make sure to use U.S. Standard as the region
    Bucket name should be <project-name>-staging

  2) Setup missing environment variables in rubber.profile

  3) Export those environment variables into your shell

  4) Ensure your digital ocean private key is in your authentication agent
    The private key's name should match the result of doing a `whoami` in your terminal
    => ssh-add ~/.ssh/digitalocean-<project-name>/<whoami>

  5) Create the server
    => RUBBER_ENV=staging ALIAS=staging-master ROLES=background_worker,common,db:primary=true,nginx,postgresql,postgresql_master,redis,redis_master,sidekiq,unicorn,web,app,whenever cap rubber:create
    # If you have issues with create, and figure them out, run `RUBBER_ENV=staging cap rubber:refresh` to pick up where you left off.

  6) Rename the droplet via DigitalOcean UI
    ie: staging-master becomes <project-name>-staging-master or domain-name.com (if you want the PTR Record)

  7) Setup the /etc/hosts aliases
    => RUBBER_ENV=staging cap rubber:setup_remote_aliases

  8) Add the created instance-staging to source control
    => git add -A; git commit -m  "Add staging instance digest."; git push

  9) Provision the server
    => RUBBER_ENV=staging cap rubber:bootstrap

* Deploying

  1) RUBBER_ENV=staging cap deploy:migrations

* Adding a user with deploy rights

  1) Have them create an ssh key @ ~/.ssh/digitalocean-<project-name>/<whoami>

  2) Have them upload that ssh key to Digitial Ocean with the same name

  3) SSH into the box and add their public ssh key to the authorized keys
    => ~/.ssh/authorized_keys