function LessonCard(props) {
  const markup = { __html: props.lesson.teaser };
  const url = props.lesson.path;
  const cssClasses = `u-wrap--${props.type}`;

  return (
    <a className="o-card o-card--base" href={url}>
      <div className={cssClasses}>
        <div className="o-card__header o-title">
          <span className="o-title__type">{props.lesson.short_title}</span>
          <span className="o-title__duration">{props.lesson.estimated_time} min</span>
        </div>
        <h2>{props.lesson.title}</h2>
        <div className="o-card__dsc" dangerouslySetInnerHTML={markup} />
      </div>
    </a>
  );
}
