Installation
------------

Run the following:

    vagrant up
    vagrant ssh
    cd /vagrant
    bundle install
    bin/rake db:setup
    foreman s

NOTE: If needed, pipedrive api_token can be changed in config/application.rb.

This would bring a new vagrant machine up and install all dependencies (using ansible). Foreman would run both ```sidekiq``` and ```Rails``` server in foreground.

Running/Debugging
-----------------

Open ```http://192.168.33.99:3000``` in browser (that would redirect to ```/docs```). You should see a simple documentaiton on available API endpoints.

Open ```http://192.168.33.99:3000/jobs``` to see and manage ```Sidekiq``` backend (it is used for background processing, specifically - syncing with pipedrive.com).

All communication with pipedrive is logged to log/pipedrive.log.

phpMyAdmin available at ```http://192.168.33.99/phpmyadmin``` (user ```root```, pass ```123```)

Running tests
-------------

    rspec -f d

Sample output:

    OrganizationsController
      prints list of organizations
      creates models from json
      deletes all organizations and relations and calls DeleteAllJob
        should be success
        should change result from 2 to 0
        should change result from 1 to 0
        should enqueue a DeleteAllJob with [[15, 25]]

    RelationsController
      prints list of relations

    DeleteAllJob
      Posts to pipedrive

    OrganizationCreateJob
      Posts to pipedrive

    RelationCreateJob
      Posts to pipedrive

    SyncJob
      schedules OrganizationCreateJob
      does not schedule RelationCreateJob
      ...until all Organizations got synced

    Finished in 0.3525 seconds (files took 1.79 seconds to load)
    13 examples, 0 failures

