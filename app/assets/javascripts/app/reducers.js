import merge from 'lodash/merge';
import { combineReducers } from 'redux';
import { lessonPage } from 'lesson/reducers';

function entities(state = { lessons: {} }, action) {
  if (action.payload && action.payload.entities) {
    return merge({}, state, action.payload.entities);
  }

  return state;
}

export default combineReducers({
  entities,
  lessonPage,
  path: (state = '') => state
});
