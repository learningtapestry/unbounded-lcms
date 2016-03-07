function ExploreCurriculumCollapsedItem(props) {
  const resource = props.curriculum.resource;

  const curriculumComponent = {
    'grade': ExploreCurriculumGradeMap,
    'module': ExploreCurriculumModuleMap,
    'unit': ExploreCurriculumUnitMap,
    'lesson': ExploreCurriculumGradeMap
  }[props.curriculum.type];

  const curriculumMap = React.createElement(curriculumComponent, {
    expanded: false,
    onClickDetails: props.onClickExpand,
    curriculum: props.curriculum
  });

  const cssClasses = classNames(
    "o-cur-card",
    "o-cur-card--short",
    `o-cur-card--${props.curriculum.type}`
  );

  return (
    <div className={cssClasses}>
      {curriculumMap}
      <div className="o-cur-card__body o-cur-card__body--short" onClick={props.onClickExpand}>
        <strong className="u-text--capitalized">{resource.short_title}</strong>
        <span> {resource.title}</span>
        <span> {resource.text_description}</span>
      </div>
      <div className="o-cur-card__actions">
        <i className="fa fa-lg fa-ellipsis-h" onClick={props.onClickExpand}>
        </i>
      </div>
    </div>
  );
}
