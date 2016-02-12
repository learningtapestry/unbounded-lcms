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

## Integration database

For convenience, a copy of the unboundED materials database is available
in `db/dump/content.dump.freeze`.

This PostgreSQL dump is expected to feed the `integration` environment DB.
Please set up a `.env.integration` file to use it.

## Running tests

```bash
cp db/dump/content.dump.freeze db/dump/content.dump
RAILS_ENV=integration rake db:restore
rake test
```
