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
