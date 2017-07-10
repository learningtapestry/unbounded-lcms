function CurriculumMapUnit(props) {
  const curriculum = props.curriculum;
  const isActive = _.includes(props.active, curriculum.id) || props.isActiveBranch;
  const cssClasses = classNames( 'o-c-map__unit-title',
                               {[`${props.mapType}-txt-link--base`]: !isActive,
                                [`${props.mapType}-txt-link--${props.colorCode} ${props.mapType}-txt-link--active`]: isActive });
  const lessons = curriculum.children.map(
    lesson => <CurriculumMapLesson key={lesson.resource.id}
                                   curriculum={lesson}
                                   colorCode={props.colorCode}
                                   active={props.active}
                                   mapType={props.mapType}
                                   isActiveBranch={_.first(props.active) == curriculum.id || props.isActiveBranch}
                                   handlePopupState={props.handlePopupState} />
  );
  return (
    <div className='o-c-map__unit'>
      <ResourceHover cssClasses={cssClasses}
                     resource={curriculum.resource}
                     resourceHtml={curriculum.resource.short_title}
                     handlePopupState={props.handlePopupState}/>
      {lessons}
    </div>
  );
}
