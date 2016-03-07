function ExploreCurriculumModuleMap(props) {
  const mainClass = classNames({ 'o-ch-map': props.expanded,
                                 'o-ch-short-map': !props.expanded });
  const cssClasses = cssCurrirulumMapClasses(mainClass);

  const details = props.expanded ?
          <div className="o-ch-map__details">
            <span>Show Units</span>
          </div> : '';

  let module = { styles: {width: `${_.random(70, 100)}%`},
                 units: _.range(3).map((v) => { return { lessons: _.range(_.random(4, 16)) }; }) };

  return (
    <div className="o-cur-card__map" onClick={props.onClickDetails}>
      <div className={mainClass}>
        <div className={cssClasses['module-wrap']}>
          <div className={cssClasses['module']} style={module.styles}></div>
        </div>
        <div className={cssClasses['units-wrap']}>
          <div className={cssClasses['units']}>
            { module.units.map(unit => {
              return (
                  <div className={cssClasses['unit']}>
                    { unit.lessons.map(lesson => {
                      return <div className={cssClasses['lesson']}></div>;
                    })}
                  </div>
            );
            })}
          </div>
        </div>
      </div>
      {details}
    </div>
  );
}
