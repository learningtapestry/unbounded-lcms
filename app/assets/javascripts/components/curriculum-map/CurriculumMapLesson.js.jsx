function CurriculumMapLesson(props) {
  const curriculum = props.curriculum;
  const isActive = (props.isUnitActive && props.active.length < 4) || _.includes(props.active, curriculum.id);
  const cssClasses = classNames('o-c-map__lesson',
                                { 'cs-bg--base': !isActive,
                                  [`cs-bg--${props.colorCode}`]: isActive });
  return (
    <ResourceHover cssClasses={cssClasses}
                   resource={curriculum.resource}
                   handlePopupState={props.handlePopupState}/>
  );
}
