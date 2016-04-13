function ExploreCurriculumModuleMap(props) {
  const mapClass = classNames({
    'o-cur-card__map': true,    
    'o-cur-card__map--medium': props.expanded,
    'o-cur-card__map--short': !props.expanded
  });

  const mainClass = classNames({
    'o-ch-map': true,
    'o-ch-map--medium': props.expanded,
    'o-ch-map--short': !props.expanded
  });

  const bemClass = _.partial(convertToBEM, mainClass);
  const colorCodeClass = `cs-bg--${props.colorCode}`;

  const details = props.expanded ?
    <div className="o-ch-map__details">
      <span>Show Units</span>
    </div> : '';

  const units = props.curriculum.unit_sizes.map((size, i) => {
    const lessons = [];

    for (let j = 0; j < size; j++) {
      lessons.push((
        <div key={j} className={classNames(bemClass('lesson'), colorCodeClass)}></div>
      ));
    }

    return (
      <div key={i} className={bemClass('unit')}>
        {lessons}
      </div>
    );
  });

  return (
    <div className={mapClass}>
      <div className={mainClass}>
        <div className={bemClass('module-wrap')}>
          <div className={classNames(bemClass('module'), colorCodeClass)}></div>
        </div>
        <div className={bemClass('units-wrap')}>
          <div className={bemClass('units')}>
            {units}
          </div>
        </div>
      </div>
      {details}
    </div>
  );
}
