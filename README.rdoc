# LT Content

A learning object repository.

## Project setup for new projects

```bash
cp db/content.dump.freeze db/content.dump
rake db:restore
rake db:test:prepare_integration
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

If the development database changes, one should run
`rake db:test:prepare_integration` to update the integration database.

## Recreating the EngageNY (UnboundEd) database from scratch

```bash
cp db/engageny.dump.freeze db/engageny.dump
rake db:create db:migrate
rake db:restore_engageny # This will take a long time
rake db:test:prepare_integration
```
