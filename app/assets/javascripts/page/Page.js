import React from 'react';
import { ErrorPage } from 'errors';

export default class Page extends React.Component {
  constructor(...args) {
    super(...args);
    this.state = { error: null };
  }

  tryDispatch(action) {
    return Promise.resolve(this.props.dispatch(action))
      .then(value => {
        this.setState({ error: null });
        return value;
      })
      .catch(error => {
        this.setState({ error });
      });
  }

  tryRender(tree) {
    return this.state.error ? <ErrorPage error={this.state.error} /> : tree;
  }
}
