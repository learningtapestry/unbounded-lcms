function ExploreCurriculumUnitMap(props) {
  const mapClass = classNames({
    'o-cur-card__map': true,
    'o-cur-card__map--medium': props.expanded,
    'o-cur-card__map--short': !props.expanded
  });

  const mainClass = classNames({
    'o-ch-unit-map': true,
    'o-ch-unit-map--medium': props.expanded,
    'o-ch-unit-map--short': !props.expanded
  });

  const bemClass = _.partial(convertToBEM, mainClass);
  const colorCodeClass = `cs-bg--${props.colorCode}`;

  const details = props.expanded ?
    <div className="o-ch-map__details">
      <span>Show Lessons</span>
    </div> : '';

  const lessons = [];

  for (let i = 0; i < props.curriculum.lesson_count; i++) {
    lessons.push((
      <div key={i} className={classNames(bemClass('lesson'), colorCodeClass)}></div>
    ));
  }

  return (
    <div className={mapClass}>
      <div className={mainClass}>
        <div className={bemClass('units-wrap')}>
          <div className={bemClass('units')}>
            <div className={bemClass('unit')}>
              {lessons}
            </div>
          </div>
        </div>
      </div>
      {details}
    </div>
  );
}
