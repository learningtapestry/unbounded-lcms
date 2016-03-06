function ExploreCurriculumGradeMap(props) {
  const mainClass = classNames({ 'o-ch-map': props.expanded,
                                 'o-ch-short-map': !props.expanded });
  const cssClasses = cssCurrirulumMapClasses(mainClass);
  const details = props.expanded ?
          <div className="o-ch-map__details">
            <span>Show Modules</span>
          </div> : '';

  let grades = _.range(7).map((v, i) => { return { styles: {width: `${_.random(70, 100)}%`}, short_title: `grade ${i}` }; });

  return (
    <div className="o-cur-card__map" onClick={props.onClickDetails}>
      <div className={mainClass}>
        { grades.map(grade => {
          return (
            <div className={cssClasses['module-wrap']}>
              <div className={cssClasses['module']} style={grade.styles}></div>
            </div>
          );
        })}
      </div>
      {details}
    </div>
  );
}
