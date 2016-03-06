function ExploreCurriculumItem(props) {
  let curriculum = props.index[props.id];
  // An item should expand if its parent is the last parent in the active branch.
  // Collapsed Grade -> Collapsed Mod -> Expanded Unit 1, Unit 2, Unit 3
  let item;
  let activeParent = props.index[props.active[props.active.length - 2]];
  let shouldItemExpand = props.active.length === 1 ||
    _.some(activeParent.children, c => c.id === props.id);

  item = shouldItemExpand ?
    <ExploreCurriculumExpandedItem
      curriculum={curriculum}
      onClickViewDetails={props.onClickViewDetails.bind(this, props.parentage)} /> :
    <ExploreCurriculumCollapsedItem
      curriculum={curriculum}
      onClickExpand={props.onClickExpand.bind(this, props.parentage)} />;

  // Children should be rendered if the item is a parent in the active branch.
  let children;
  const shouldRenderChildren = props.active.length > 1 &&
    _.includes(props.active, props.id) &&
    _.last(props.active) !== props.id;

  const cssClasses = classNames( 'c-ec-cards__children',
                               { 'c-ec-cards__children--lessons': curriculum.type === 'unit',
                                 'c-ec-cards__children--expanded': shouldRenderChildren });

  children = shouldRenderChildren ?
    curriculum.children.map(c => (
      c.type === 'lesson' ?
        <LessonCard key={c.resource.id} lesson={c.resource} type="light" /> :
        <ExploreCurriculumItem
          key={c.id}
          id={c.id}
          index={props.index}
          onClickExpand={props.onClickExpand}
          onClickViewDetails={props.onClickViewDetails}
          parentage={[...props.parentage, c.id]}
          active={props.active} />
    )) : [];

  return (
    <div>
      {item}
      <div className={cssClasses}>
        {children}
      </div>
    </div>
  );
}
