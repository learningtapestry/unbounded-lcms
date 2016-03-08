function ExploreCurriculumUnitMap(props) {
  const mainClass = classNames({
    'o-ch-unit-map': props.expanded,
    'o-ch-short-unit-map': !props.expanded
  });

  const cssPrefix = cls => `${mainClass}__${cls}`;

  const details = props.expanded ?
    <div className="o-ch-map__details">
      <span>Show Lessons</span>
    </div> : '';

  const lessons = [];

  for (let i = 0; i < props.curriculum.lesson_count; i++) {
    lessons.push((
      <div key={i} className={cssPrefix('lesson')}></div>
    ));
  }

  return (
    <div className="o-cur-card__map" onClick={props.onClickDetails}>
      <div className={mainClass}>
        <div className={cssPrefix('units-wrap')}>
          <div className={cssPrefix('units')}>
            <div className={cssPrefix('unit')}>
              {lessons}
            </div>
          </div>
        </div>
      </div>
      {details}
    </div>
  );
}
