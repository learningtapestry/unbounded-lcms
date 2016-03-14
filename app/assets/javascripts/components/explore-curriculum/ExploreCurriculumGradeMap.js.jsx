function ExploreCurriculumGradeMap(props) {
  const mainClass = classNames({
    'o-ch-map': props.expanded,
    'o-ch-short-map': !props.expanded
  });

  const details = props.expanded ?
    <div className="o-ch-map__details">
      <span>Show Modules</span>
    </div> : '';

  const min = Math.min(...props.curriculum.module_sizes),
        max = Math.max(...props.curriculum.module_sizes);

  const scale = _.curry(scaleNumber)(70, 100, min, max);

  const grades = props.curriculum.module_sizes.map((size, i) => {
    const styles = { width: `${scale(size)}%` };
    return (
      <div key={i} className={`${mainClass}__module-wrap`}>
        <div className={`${mainClass}__module`} style={styles}></div>
      </div>
    );
  });

  return (
    <div className="o-cur-card__map" onClick={props.onClickDetails}>
      <div className={mainClass}>
        {grades}
      </div>
      {details}
    </div>
  );
}
