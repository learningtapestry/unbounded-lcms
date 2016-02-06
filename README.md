# unboundED website

[ ![Codeship Status for learningtapestry/unbounded](https://codeship.com/projects/bae631f0-5a22-0133-cd42-72256058fde0/status?branch=master)](https://codeship.com/projects/110252)

A learning object repository.

## Requirements

* `PostgreSQL 9.4`

## Running tests

```bash
cp db/dump/content.dump.freeze db/dump/content.dump
RAILS_ENV=integration rake db:restore
rake test
```
