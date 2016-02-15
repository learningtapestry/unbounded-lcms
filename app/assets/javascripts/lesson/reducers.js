import { RECEIVE_LESSON, } from './actions';

export function lessons(state = {}, action) {
  switch(action.type) {
    case RECEIVE_LESSON:
      return Object.assign({}, state, {
        [action.payload.id]: action.payload
      });
    default:
      return state;
  }
};
