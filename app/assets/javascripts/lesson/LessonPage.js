import { connect } from 'react-redux';
import { fetchLesson } from './actions';
import { Link } from 'react-router';
import { Page } from 'page';
import Lesson from './Lesson';

class LessonPage extends Page {
  get lessonId() {
    return this.props.params.id;
  }

  get lesson() {
    return this.props.lessons[this.lessonId];
  }

  componentDidMount() {
    if (!(this.lessonId in this.props.lessons)) {
      this.fetch();
    }
  }

  componentDidUpdate(prevProps) {
    let oldId = prevProps.params.id;
    if (this.lessonId !== oldId) {
      this.fetch();
    }
  }

  fetch() {
    this.tryDispatch(fetchLesson(this.lessonId));
  }

  render() {
    return this.tryRender(
      <Lesson {...this.lesson} />
    );
  }
}

export default connect(state => ({
  lessons: state.lessons
}))(LessonPage);
