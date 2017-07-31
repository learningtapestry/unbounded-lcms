function CurriculumMapUnit(props) {
  const curriculum = props.curriculum;
  const isActive = _.includes(props.active, curriculum.id) || props.isActiveBranch;
  const isAssessment = /assessment/.test(curriculum.resource.short_title);
  const cssClasses = classNames( 'o-c-map__unit-title',
                               {[`${props.mapType}-txt-link--base`]: !isActive,
                                [`${props.mapType}-txt-link--${props.colorCode} ${props.mapType}-txt-link--active`]: isActive });
  let lessons;
  if (isAssessment) {
    lessons = [
      <CurriculumMapLesson key={curriculum.resource.id}
                           curriculum={curriculum}
                           colorCode={props.colorCode}
                           active={props.active}
                           mapType={props.mapType}
                           isAssessment={true}
                           isActiveBranch={_.first(props.active) == curriculum.id || props.isActiveBranch}
                           handlePopupState={props.handlePopupState} />
    ];
  } else {
    lessons = curriculum.children.map(
      lesson => <CurriculumMapLesson key={lesson.resource.id}
                                     curriculum={lesson}
                                     colorCode={props.colorCode}
                                     active={props.active}
                                     mapType={props.mapType}
                                     isActiveBranch={_.first(props.active) == curriculum.id || props.isActiveBranch}
                                     handlePopupState={props.handlePopupState} />
    );
  }

  let resourceHtml;
  if (isAssessment) {
    resourceHtml = /mid/.test(curriculum.resource.short_title) ? 'MID' : 'END'
  } else {
    resourceHtml = curriculum.resource.short_title;
  }
  return (
    <div className='o-c-map__unit'>
      <ResourceHover cssClasses={cssClasses}
                     resource={curriculum.resource}
                     resourceHtml={resourceHtml}
                     handlePopupState={props.handlePopupState}/>
      {lessons}
    </div>
  );
}
