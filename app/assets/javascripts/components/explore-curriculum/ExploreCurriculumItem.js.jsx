class ExploreCurriculumItem extends React.Component {
  curriculum() {
    return this.props.index[this.props.id];
  }

  render() {
    const props = this.props;
    const curriculum = this.curriculum();
    const colorCode = colorCodeCss(curriculum.resource.subject, curriculum.resource.grade);

    // An item should expand if its parent is the last parent in the active branch.
    // Collapsed Grade -> Collapsed Mod -> Expanded Unit 1, Unit 2, Unit 3
    const activeParent = props.index[props.active[props.active.length - 2]];
    const shouldItemExpand = props.active.length === 1 ||
      _.some(activeParent.children, c => c.id === props.id);

    const item =
      <ExploreCurriculumCardItem
        curriculum={curriculum}
        onClickElement={ shouldItemExpand ? props.onClickViewDetails.bind(this, props.parentage) : props.onClickExpand.bind(this, props.parentage)}
        shouldItemExpand={shouldItemExpand}
        colorCode={colorCode} />;

    // Children should be rendered if the item is a parent in the active branch.
    const shouldRenderChildren = props.active.length > 1 &&
      _.includes(props.active, props.id) &&
      _.last(props.active) !== props.id;

    const cssClasses = classNames( 'c-ec-cards__children',
                                 { 'c-ec-cards__children--lessons': curriculum.type === 'unit',
                                   'c-ec-cards__children--expanded': shouldRenderChildren });

    const children = shouldRenderChildren ?
      curriculum.children.map(c => (
        c.type === 'lesson' ?
          <LessonCard key={c.resource.id} lesson={c.resource} type='light' colorCode={colorCode} /> :
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
        {/*TODO: add React.addons.CSSTransitionGroup for animation*/}
        <div className={cssClasses}>
            {children}
        </div>
        <DownloadModal {...curriculum.resource} />
      </div>
      );
   }
}
