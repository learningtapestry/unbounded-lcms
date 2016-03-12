function ExploreCurriculumModuleMap(props) {
  const mainClass = classNames({
    'o-ch-map': props.expanded,
    'o-ch-short-map': !props.expanded
  });

  const cssPrefix = cls => `${mainClass}__${cls}`;

  const details = props.expanded ?
    <div className="o-ch-map__details">
      <span>Show Units</span>
    </div> : '';

  const units = props.curriculum.unit_sizes.map((size, i) => {
    const lessons = [];

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
