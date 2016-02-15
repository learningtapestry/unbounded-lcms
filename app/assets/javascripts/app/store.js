import { checkWindow } from 'lib';
import { createStore, applyMiddleware, compose } from 'redux';
import reducers from './reducers';
import thunk from 'redux-thunk';

let middleware = [thunk].map(fn => applyMiddleware(fn));

if (checkWindow() && window.devToolsExtension) {
  middleware.push(window.devToolsExtension());
}

export default function appStoreCreator(props = {}) {
  return createStore(
    reducers,
    props,
    compose(...middleware)
  );
}
