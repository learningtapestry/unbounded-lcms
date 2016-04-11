function LessonCard(props) {
  const url = props.lesson.path;

  return (
    <a className="o-lesson-card o-lesson-card--base" href={url}>
      <div className={`cs-bg--${props.colorCode}`}>
        <div className="o-lesson-card__header o-title cs-txt--white">
          <span className="o-title__type">{props.lesson.short_title}</span>
        </div>
        <div className="o-lesson-card__content o-lesson-card__content--base cs-bg--white">
          <h3 className="o-lesson-card__dsc--short">{props.lesson.title}</h3>
          <div className="o-lesson-card__duration">
            <TimeToTeach duration={props.lesson.time_to_teach} />
          </div>
        </div>
        <div className="o-lesson-card__content o-lesson-card__content--hover">
          <div className="o-lesson-card__dsc--full">{props.lesson.teaser}</div>
        </div>
      </div>
    </a>
  );
}
