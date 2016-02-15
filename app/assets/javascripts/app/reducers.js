import { combineReducers } from 'redux';
import { lessons } from 'lesson/reducers';

// If initial state is undefined, returns a default value.
// Otherwise, returns the new state.
function identity(value) {
  return (state = value) => state;
}

export default combineReducers({
  lessons,
  path: identity('')
});
