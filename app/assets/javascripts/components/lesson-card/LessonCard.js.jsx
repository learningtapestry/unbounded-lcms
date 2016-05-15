function LessonCard(props) {
  const url = props.lesson.path;
  const title = props.with_breadcrumb ? props.lesson.breadcrumb_title : props.lesson.short_title;

  return (
    <a className="o-lesson-card o-lesson-card--base" href={url}>
      <div className={classNames('o-lesson-card__wrap', `cs-bg--${props.colorCode}`)}>
        <div className="o-lesson-card__header cs-txt--light u-text--uppercase">
          <span className="u-txt--breadcrumbs">{title}</span>
        </div>
        <div className="o-lesson-card__content o-lesson-card__content--base cs-bg--light">
          <h3 className="o-lesson-card__dsc o-lesson-card__dsc--short">{props.lesson.title}</h3>
          <div className="o-lesson-card__duration">
            <TimeToTeach duration={props.lesson.time_to_teach} />
          </div>
        </div>
        <div className="o-lesson-card__content o-lesson-card__content--hover">
          <div className="o-lesson-card__dsc o-lesson-card__dsc--full">{props.lesson.teaser}</div>
        </div>
      </div>
    </a>
  );
}
