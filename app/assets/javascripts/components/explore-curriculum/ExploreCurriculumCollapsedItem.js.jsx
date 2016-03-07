function ExploreCurriculumCollapsedItem(props) {
  let resource = props.curriculum.resource;
  const cssClasses = classNames("o-cur-card", "o-cur-card--short", `o-cur-card--${props.curriculum.type}`);
  const dsc = resource.description.replace(/(<([^>]+)>)/ig,"");
  let curriculumMap = React.createElement(curriculumMapComponents[props.curriculum.type],
                                         { expanded: false, onClickDetails: props.onClickExpand});

  return (
    <div className={cssClasses}>
      {curriculumMap}
      <div className="o-cur-card__body o-cur-card__body--short" onClick={props.onClickExpand}>
        <strong className="u-text--capitalized">{resource.short_title}</strong>
        <span> {resource.title}</span>
        <span> {dsc}</span>
      </div>
      <div className="o-cur-card__actions">
        <i className="fa fa-lg fa-ellipsis-h" onClick={props.onClickExpand}>
        </i>
      </div>
    </div>
  );
}
