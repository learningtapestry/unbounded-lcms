import { checkWindow } from 'lib';
import { createLocation } from 'history';
import { Link, Router, Route, browserHistory, createMemoryHistory } from 'react-router';
import { Provider } from 'react-redux';
import ReactOnRails from 'react-on-rails';
import { LessonPage } from 'lesson';

export default function app(props) {
  const store = ReactOnRails.getStore('appStore');
  let history;

  // If the window object does not exist, we're doing server rendering and
  // react-router will use a memory history with the request path as the
  // current location.
  if (checkWindow()) {
    history = browserHistory;
  } else {
    history = createMemoryHistory(store.getState().path);
  }

  return (
    <Provider store={store}>
      <Router history={history}>
        <Route path="/lessons/:id" component={LessonPage}/>
      </Router>
    </Provider>
  );
};
