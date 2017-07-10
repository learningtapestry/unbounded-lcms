function CurriculumMap(props) {
  const curriculum = props.results;
  const min = Math.min(...curriculum.module_sizes),
        max = Math.max(...curriculum.module_sizes);

  const scale = _.curry(scaleNumber)(70, 100, min, max);
  const colorCode = colorCodeCss(curriculum.resource.subject, curriculum.resource.grade);

  const modules = curriculum.module_sizes.map((size, i) => {
    const styles = { width: `${scale(size)}%` };
    const module = curriculum.children[i];
    return (
      <CurriculumMapModule key={i}
                           styles={styles}
                           curriculum={module}
                           colorCode={colorCode}
                           mapType={props.mapType}
                           subject={curriculum.resource.subject}
                           active={props.active} />
    );
  });

  return (
    <div className="o-c-map">
      {modules}
    </div>
  );
}
