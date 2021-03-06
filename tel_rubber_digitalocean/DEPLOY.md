== DEPLOY

* Provisioning

  1) Create the S3 bucket
    Make sure to use U.S. Standard as the region
    Bucket name should be <project-name>-staging

  2) Setup missing environment variables in rubber.profile

  3) Export those environment variables into your shell

  4) Ensure your digital ocean public and private key are in place and added to your agent
    The keys' names should match the result of doing a `whoami` in your terminal
    => cp ~/.ssh/id_rsa ~/.ssh/digitalocean-<project-name>/<whoami>
    => cp ~/.ssh/id_rsa.pub ~/.ssh/digitalocean-<project-name>/<whoami>.pub
    => ssh-add ~/.ssh/digitalocean-<project-name>/<whoami>

  5) Create the server
    => RUBBER_ENV=staging ALIAS=staging-master ROLES=background_worker,common,db:primary=true,nginx,postgresql,postgresql_master,redis,redis_master,sidekiq,unicorn,web,app,whenever cap rubber:create
    # If you have issues with create, and figure them out, run `RUBBER_ENV=staging cap rubber:refresh` to pick up where you left off.
    # A common issue is that a past IP address in your ~/.ssh/known_hosts is conflicting with the new droplet's IP address since Digital Ocean resuses released IPs. Remove the offending line.

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