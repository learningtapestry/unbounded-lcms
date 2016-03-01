function LessonCard(props) {
  let markup = { __html: props.lesson.description };
  const url = Routes.lesson_path(props.lesson.id);

  return (
    <a className="o-card o-card--base" href={url}>
      <div className="u-wrap--base">
        <div className="o-card__header o-title">
          <span className="o-title__type">{props.lesson.type}</span>
          <span className="o-title__duration">{props.lesson.estimated_time} min</span>
        </div>
        <h2>{props.lesson.title}</h2>
        <div className="o-card__dsc" dangerouslySetInnerHTML={markup} />
      </div>
    </a>
  );
}
