function ExploreCurriculumModuleMap(props) {
  const mainClass = classNames({
    'o-ch-map': props.expanded,
    'o-ch-short-map': !props.expanded
  });

  const cssPrefix = _.curry(classPrefix)(mainClass, '__');

  const details = props.expanded ?
    <div className="o-ch-map__details">
      <span>Show Units</span>
    </div> : '';

  const min = Math.min(...props.curriculum.unit_sizes),
        max = Math.max(...props.curriculum.unit_sizes);

  let units = props.curriculum.unit_sizes.map((size, i) => {
    let lessons = [];

    for (let j = 0; j < size; j++) {
      lessons.push((
        <div key={j} className={cssPrefix('lesson')}></div>
      ));
    }

    return (
      <div key={i} className={cssPrefix('unit')}>
        {lessons}
      </div>
    );
  });

  return (
    <div className="o-cur-card__map" onClick={props.onClickDetails}>
      <div className={mainClass}>
        <div className={cssPrefix('module-wrap')}>
          <div className={cssPrefix('module')}></div>
        </div>
        <div className={cssPrefix('units-wrap')}>
          <div className={cssPrefix('units')}>
            {units}
          </div>
        </div>
      </div>
      {details}
    </div>
  );
}
