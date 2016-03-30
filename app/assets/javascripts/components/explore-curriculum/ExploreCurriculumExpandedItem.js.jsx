function ExploreCurriculumExpandedItem(props) {
  const resource = props.curriculum.resource;

  const curriculumComponent = {
    'grade': ExploreCurriculumGradeMap,
    'module': ExploreCurriculumModuleMap,
    'unit': ExploreCurriculumUnitMap,
    'lesson': ExploreCurriculumGradeMap
  }[props.curriculum.type];

  const curriculumMap = React.createElement(curriculumComponent, {
    expanded: true,
    onClickDetails: props.onClickViewDetails,
    curriculum: props.curriculum
  });

  const cssClasses = classNames(
    'o-cur-card',
    `o-cur-card--${props.curriculum.type}`
  );

  const description = { __html: resource.description };

  const resourceType = resource.type.name == 'grade' ? 'curriculum' : resource.type.name;
  const downloadBtnLabel = `Download ${_.capitalize(resourceType)}`;

  return (
    <div id={props.curriculum.id} className={cssClasses}>
      {curriculumMap}
      <div className="o-cur-card__body" onClick={props.onClickViewDetails}>
        <div className="o-title">
          <span className="o-title__type">{resource.short_title}</span>
          <span className="o-title__duration">{resource.time_to_teach} min</span>
        </div>
        <h2>{resource.title}</h2>
        <div className="u-html-description" dangerouslySetInnerHTML={description}></div>
      </div>
      <div className="o-cur-card__actions">
        <div>
          <a className="o-ub-btn" href={resource.path}>View Details</a>
        </div>
        <div>
          <button className="o-ub-btn o-ub-btn--bordered">{downloadBtnLabel}</button>
        </div>
        <div>
          <button className="o-ub-btn o-ub-btn--bordered">Related Instruction</button>
        </div>
      </div>
    </div>
  );
}
