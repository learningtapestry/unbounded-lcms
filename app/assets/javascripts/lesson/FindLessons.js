import React from 'react';
import { connect } from 'react-redux';
import { fetchFindLessons } from './actions';
import { Page } from 'page';
import Lesson from './Lesson';

export default class FindLessons extends React.Component {
  componentDidMount() {
    this.fetch();
  }

  fetch() {
    this.props.dispatch(fetchFindLessons());
  }

  render() {
    return <div />;
  }
}

export default connect(state => {
  return { ...state.findLessons };
})(FindLessons);
