function ExploreCurriculumExpandedItem(props) {
  let resource = props.curriculum.resource;
  const description = { __html: resource.description };
  const cssClasses = classNames("o-cur-card", `o-cur-card--${props.curriculum.type}`);
  let curriculumMap = React.createElement(curriculumMapComponents[props.curriculum.type],
                                         { expanded: true, onClickDetails: props.onClickViewDetails});

  return (
    <div className={cssClasses}>
      {curriculumMap}
      <div className="o-cur-card__body" onClick={props.onClickViewDetails}>
        <div className="o-title">
          <span className="o-title__type">{resource.short_title}</span>
          <span className="o-title__duration">{resource.estimated_time} min</span>
        </div>
        <h2>{resource.title}</h2>
        <div className="u-html-description" dangerouslySetInnerHTML={description}></div>
      </div>
      <div className="o-cur-card__actions">
        <div>
          <button className="o-ub-btn" onClick={props.onClickViewDetails}>View Details</button>
        </div>
        <div>
          <button className="o-ub-btn o-ub-btn--bordered">Download Curriculum</button>
        </div>
        <div>
          <button className="o-ub-btn o-ub-btn--bordered">Related Instruction</button>
        </div>
      </div>
    </div>
  );
}
