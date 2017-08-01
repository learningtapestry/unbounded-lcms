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

  const details = props.expanded && !props.curriculum.resource.is_assessment ?
    <div className="o-ch-map__details">
      <span>Show Lessons</span>
    </div> : '';

  const lessons = [];
  const isAssessment = /assessment/.test(props.curriculum.resource.short_title);

  for (let i = 0; i < props.curriculum.lesson_count; i++) {
    const assessmentClass =  isAssessment ? `o-ch-unit-map__assessment--${props.colorCode}` : '';
    lessons.push((
      <div key={i} className={classNames(bemClass('lesson'), colorCodeClass, assessmentClass)}></div>
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
