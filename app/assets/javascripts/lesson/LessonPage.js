import { connect } from 'react-redux';
import { lessonPage } from './actions';
import { Link } from 'react-router';
import { Page } from 'page';
import Lesson from './Lesson';

class LessonPage extends Page {
  get lessonId() {
    return this.props.params.id;
  }

  showable(id) {
    return (id in this.props.lessons);
  }

  componentDidMount() {
    this.fetch();
  }

  componentDidUpdate(prevProps) {
    let oldId = prevProps.params.id;
    if (this.lessonId !== oldId) {
      this.fetch();
    }
  }

  fetch() {
    this.tryDispatch(lessonPage(this.lessonId));
  }

  render() {
    const lesson = this.props.lessons[this.props.lessonPage];

    return this.tryRender(
      <div>
      <Lesson {...lesson} />
      </div>
    );
  }
}

export default connect(state => ({
  lessons: state.entities.lessons,
  lessonPage: state.lessonPage
}))(LessonPage);
