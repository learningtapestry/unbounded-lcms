# LT Content

A learning object repository.

## Requirements

* `PostgreSQL 9.4`
* `Elasticsearch 1.5`

Make sure you have the Postgres users created (with database creation permissions) 
before running the rake tasks.

## Project setup for new projects

```bash
bundle install
cp db/dump/content.dump.freeze db/dump/content.dump
rake db:restore
rake db:migrate
rake content:elasticsearch:full_reindex
rake integration:setup
rake test
```

## Integration tests

For integration tests based around the development database, mark the test
class with `uses_integration_database`.

```ruby
class ApiControllerTest < ActionController::TestCase
  uses_integration_database

  def test_something
    # assert true
  end
end
```

If the development database changes, one should run `rake integration:setup`
to update the integration database.

## Recreating the ENY/UnboundEd db from scratch

```bash
cp db/dump/engageny.dump.freeze db/dump/engageny.dump
rake db:create db:migrate
rake db:restore_engageny # This will take a long time
rake integration:setup
```
