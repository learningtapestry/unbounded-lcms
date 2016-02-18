import { fetchJson } from 'lib';
import { createAction } from 'redux-actions';
import { normalize, Schema, arrayOf } from 'normalizr';

const lessonSchema = new Schema('lessons');

export const LESSON_REQUEST = 'LESSON_REQUEST';
export const LESSON_SUCCESS = 'LESSON_SUCCESS';

export function fetchLesson(id) {
  return (dispatch, getState) => {
    const { entities } = getState();

    if (id in entities.lessons) {
      return Promise.resolve(entities.lessons[id]);
    }

    dispatch({
      type: LESSON_REQUEST,
      payload: id
    });

    return fetchJson(`http://localhost:3000/lessons/${id}.json`)
      .then(lesson => {
        const normalized = normalize(lesson, lessonSchema);

        dispatch({
          type: LESSON_SUCCESS,
          payload: normalized
        });

        return normalized;
      });
  };
};

export const LESSON_PAGE = 'LESSON_PAGE';
export function lessonPage(id) {
  return dispatch => {
    return dispatch(fetchLesson(id)).then(lesson => {    
      dispatch({
        type: LESSON_PAGE_SUCCESS,
        payload: id
      });

      return id;
    });
  };
};

export const LESSON_PAGE_SUCCESS = 'LESSON_PAGE_SUCCESS';
