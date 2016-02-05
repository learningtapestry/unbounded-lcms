# LT Content

A learning object repository.

## Requirements

* `PostgreSQL 9.4`

## Running tests

```bash
cp db/dump/content.dump.freeze db/dump/content.dump
RAILS_ENV=integration rake db:restore
rake test
```
