import { fetchJson } from 'lib';
import { createAction } from 'redux-actions';

export const
  REQUEST_LESSON = 'REQUEST_LESSON',
  requestLesson = createAction(REQUEST_LESSON),

  RECEIVE_LESSON = 'RECEIVE_LESSON',
  receiveLesson = createAction(RECEIVE_LESSON);

export function fetchLesson(id) {
  return (dispatch, getState) => {
    const { lessons } = getState();

    if (id in lessons) {
      return lessons[id];
    }

    dispatch(requestLesson(id));

    return fetchJson(`http://localhost:3000/lessons/${id}.json`)
      .then(lesson => {
        dispatch(receiveLesson(lesson));
        return lesson;
      });
  };
};
