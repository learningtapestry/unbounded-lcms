# UnboundED CMS

[ ![Codeship Status for learningtapestry/unbounded](https://codeship.com/projects/bae631f0-5a22-0133-cd42-72256058fde0/status?branch=master)](https://codeship.com/projects/110252)

UnboundED CMS is a specialized content management system for high quality
education materials.

The application is built as a standard Rails project with an integrated React.js
front-end.

## Requirements

* `ruby v2.1.5`
* `node v5.6.0`
* `PostgreSQL 9.4`
* `ElasticSearch >=2.2.0`
* `Redis`

## Project setup

1. Set up `.env.test`, `.env.development` and `.env.integration`
2. `bundle && bundle exec rake cloud66:after_bundle`

You should also run the task `routes:generate_js` every time routes are updated.
This task is run as part of `cloud66:after_bundle`.

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

### ElasticSearch index

run the following task to setup your index and import the data into ES:

```bash
rake es:load
```

## React front-end

The project is using `react-rails` to integrate React components with the Rails
project. `react-rails` works by connecting the `babel` transpiler to the assets
pipeline and adding lightweight helpers to plumb React components with Rails
views.

### File and folder structure

Components should go inside `app/assets/javascripts/components`. Dependencies
may be installed with `rails-assets`. If a dependency is used in a React
component, it must be declared inside `components.js` (in addition to
`application.js` if it's used elsewhere). Server side rendering won't work
otherwise.

- Each standalone component should reside in a separate folder with the format
`example-component/`
- Reusable classes must be defined each in a single file with the format
  `ExampleClass.js.jsx`
- ES6 and JSX files must end in `.js.jsx`

### Data flow and state management

Currently we're not using any libraries or frameworks to manage data flow and
state in the application. This might change in the future. Smart components
keep track of and modify their own state, and eventually fetch remote data. The
preferred HTTP requests library is HTML5 fetch.

### Guidelines for components development

- Whenever possible, write [stateless functional components](https://facebook.github.io/react/blog/2015/10/07/react-v0.14.html#stateless-functional-components)
- Ideally there should be a single stateful component per page
- Components should be as dumb as possible.

  Example: if an UI interaction with a child component might result in state
  changes, do not trigger those changes inside the child component. Pass it a
  callback as a prop and have the child component wire the UI interaction with
  the callback. Only handle actual state changes in the parent component.

## CSS development guidelines

We're using the Foundation framework in flex grid mode, and following the `BEM`
methodology to standardize stylesheet development.

- [7-1](http://sass-guidelin.es/#the-7-1-pattern) pattern for file and folder structure
- We're using Harry Roberts' style for `BEM`
- The following namespaces are used:
  - `o`, for objects that will be used across the app.
  - `c`, for components that are specific to a part of the UI and safe to change.
  - `u`, for utils like text sizes, margins and so on.
- It's not recommended to use elements of elements in `BEM`
- It's fine to add Foundation classes to HTML, especially during active development


## Google Dev Account for Content Guide Import Process

- Create a new project here: https://console.developers.google.com
- Enable Drive API on the Overview screen.
- Go to the Credentials tab and create credentials for OAuth2 (application type should be Web application). The path of the Redirect URI should be /admin/google_oauth2_callback.
- Use cliend ID and client secret values to create the GOOGLE_OAUTH2_CLIENT_ID and GOOGLE_OAUTH2_CLIENT_SECRET environment variables respectively.
