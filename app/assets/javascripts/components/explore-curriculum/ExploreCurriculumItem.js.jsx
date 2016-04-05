class ExploreCurriculumItem extends React.Component {
  curriculum() {
    return this.props.index[this.props.id];
  }

  modalId() {
    const resource = this.curriculum().resource;
    return `downloads-modal-${resource.id}`
  }

  download(download) {
    const cls = `fa fa-lg file-${download.icon}`;
    return (
      <li>
        <i className={cls}></i>
        <span>
          <a href={download.url} className="resource-attachment" target="_blank">{download.title}</a>
        </span>
      </li>
    );
  }

  modal() {
    const resource = this.curriculum().resource;
    return (
      <div className="o-download-modal" id={this.modalId()} data-reveal>
        <button className="close-button" data-close aria-label="Close modal" type="button">
          <span aria-hidden="true">&times;</span>
        </button>
        <h2>Download {_.capitalize(resource.type.name)}</h2>
        { (resource.downloads && resource.downloads.length > 0) ?
            <ul className="o-resource__list o-resource__list--icons">
              { _.map(resource.downloads, item => this.download(item)) }
            </ul>

            : <div className="c-downloads-list__empty">No downloads for this resource</div>
        }
      </div>
    );
  }

  componentDidMount() {
    const modalEl = $(`#${this.modalId()}`);
    new Foundation.Reveal(modalEl);
  }

  render() {
    const props = this.props;
    const curriculum = this.curriculum();

    // An item should expand if its parent is the last parent in the active branch.
    // Collapsed Grade -> Collapsed Mod -> Expanded Unit 1, Unit 2, Unit 3
    const activeParent = props.index[props.active[props.active.length - 2]];
    const shouldItemExpand = props.active.length === 1 ||
      _.some(activeParent.children, c => c.id === props.id);

    const item =
      <ExploreCurriculumCardItem
        curriculum={curriculum}
        onClickElement={ shouldItemExpand ? props.onClickViewDetails.bind(this, props.parentage) : props.onClickExpand.bind(this, props.parentage)}
        shouldItemExpand={shouldItemExpand}/>;

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
        {/*TODO: add React.addons.CSSTransitionGroup for animation*/}
        <div className={cssClasses}>
            {children}
        </div>
        {this.modal()}
      );
   }
}
