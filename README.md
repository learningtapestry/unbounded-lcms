# unboundED CMS

[ ![Codeship Status for learningtapestry/unbounded](https://codeship.com/projects/bae631f0-5a22-0133-cd42-72256058fde0/status?branch=master)](https://codeship.com/projects/110252)

unboundED CMS is a specialized content management system for high quality
education materials.

The application is built as a standard Rails project with an integrated React.js
front-end.

## Requirements

* `ruby v2.1.5`
* `node v5.6.0`
* `PostgreSQL 9.4`

## Project setup

1. Set up `.env.test`, `.env.development` and `.env.integration`
2. `bundle && bundle exec rake cloud66:after_bundle`
3. `npm i && npm run build`

### Integration database

For convenience, a copy of a reference unboundED database is available
at `db/dump/content.dump.freeze`. 

Besides being useful for development, this copy is expected to
feed the `integration` environment DB. Please set up a `.env.integration`
file to use it.

Currently, the `integration` environment is required for tests.

```bash
cp db/dump/content.dump.freeze db/dump/content.dump
RAILS_ENV=development rake db:restore
RAILS_ENV=integration rake db:restore
rake test
```

## React integration

`package.json` and `webpack.config.js` sit in the project root to drive `npm`
and `webpack`.

Components are developed in `app/assets/components` and registered in bundles
in `app/assets/bundles`. Once a bundle is added as an entry point in
`webpack.config.js`, `webpack` generates the bundled codebase inside
`app/assets/javascripts/generated`.

A generated bundle may be required inside a JavaScript file known by Rails 
(for example, `application.js`). Once it is required, all the registered
components are made available for inclusion in Rails views by using the
`react_on_rails` helpers, such as `react_component`.

### Development

A convenient `Procfile.dev` is available to run `webpack --watch` in parallel
with the Rails development server. Run it with `foreman start -f Procfile.dev`.
