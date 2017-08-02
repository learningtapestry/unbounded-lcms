function LessonCard(props) {
  const url = props.lesson.path;
  const is_prereq = props.lesson.is_prerequisite;

  let title = props.with_breadcrumb ? props.lesson.breadcrumb_title : props.lesson.short_title.toUpperCase();
  if (is_prereq) {
    const numeral = (/lesson (.*)/i).exec(props.lesson.short_title)[1];
    title = `LESSON ${numeral.toLowerCase()} • Prerequisite`;
  }
  const prereq = <div className="o-lesson-card__header--prerequisite"></div>;

  return (
    <a className="o-lesson-card o-lesson-card--base" href={url}>
      <div className={classNames('o-lesson-card__wrap', `cs-bg--${props.colorCode}`)}>
        <div className="o-lesson-card__header cs-txt--light">
          {is_prereq ? prereq : null}
          <span className="o-lesson-card__header--title u-txt--breadcrumbs">{title}</span>
        </div>
        <div className="o-lesson-card__content o-lesson-card__content--base cs-bg--light">
          <h3 className="o-lesson-card__dsc o-lesson-card__dsc--short">{props.lesson.title}</h3>
          <div className="o-lesson-card__duration u-hidden">
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
