# Deployment notes

## Infrastructure

Project is hosted with Cloud66 on Amazon AWS.

Currently we have:

- Load balancer (ELB)
- App servers (EC2)
- Postgres database (RDS)
- Elasticsearch server (EC2)

The app servers have a Varnish instance (port 8080) sitting sitting in front of nginx (port 80).

ELB routes requests to port 8080, hitting Varnish.

## Staging

The staging environment closely mimics production.

The production database is currently a mirror of the staging database. Database changes are queued on staging
and then replicated in production.

## Deployment instructions

There is a `release` branch which is the deployed branch on staging and production.

1. Rebase `release` with `master` and hit deploy on the Cloud66 interface.
2. Run the `Migrate from staging` task from the Cloud66 UI if a database sync between staging and production
   is necessary.
