import { LESSON_PAGE_SUCCESS } from './actions';

export function lessonPage(state = null, action) {
  switch(action.type) {
    case LESSON_PAGE_SUCCESS:
      return action.payload;
    default:
      return state;
  }
};
