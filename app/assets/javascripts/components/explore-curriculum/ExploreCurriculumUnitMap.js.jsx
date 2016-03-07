function ExploreCurriculumUnitMap(props) {
  const mainClass = classNames({ 'o-ch-unit-map': props.expanded,
                                 'o-ch-short-unit-map': !props.expanded });
  const cssClasses = cssCurrirulumMapClasses(mainClass);

  const details = props.expanded ?
          <div className="o-ch-map__details">
            <span>Show Lessons</span>
          </div> : '';

  let unit =  { lessons: _.range(_.random(4, 16)) };

  return (
    <div className="o-cur-card__map" onClick={props.onClickDetails}>
      <div className={mainClass}>
        <div className={cssClasses['units-wrap']}>
          <div className={cssClasses['units']}>
            <div className={cssClasses['unit']}>
              { unit.lessons.map(lesson => {
                return <div className={cssClasses['lesson']}></div>;
              })}
            </div>
          </div>
        </div>
      </div>
      {details}
    </div>
  );
}
