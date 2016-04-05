class ExploreCurriculumCardItem extends React.Component {
  componentDidMount() {
    let el = new Foundation.DropdownMenu($(this.refs.dropdown), { 'alignment': 'right' });
  }

  componentWillUnmount() {
    if (this.refs.dropdown) {
      $(this.refs.dropdown).foundation('destroy');
    }
  }

  render() {
    const resource = this.props.curriculum.resource;

    const curriculumComponent = {
      'grade': ExploreCurriculumGradeMap,
      'module': ExploreCurriculumModuleMap,
      'unit': ExploreCurriculumUnitMap,
      'lesson': ExploreCurriculumGradeMap
    }[this.props.curriculum.type];

    const curriculumMap = React.createElement(curriculumComponent, {
      expanded: this.props.shouldItemExpand,
      curriculum: this.props.curriculum
    });

    const cssClasses = classNames(
      "o-cur-card",
      { "o-cur-card--short": !this.props.shouldItemExpand },
      `o-cur-card--${this.props.curriculum.type}`
    );

    const cssCardClasses = classNames(
      "o-cur-card__body",
      {"o-cur-card__body--short": !this.props.shouldItemExpand }
    );

    const cssActionClasses = classNames(
      "o-cur-card__actions",
      {"o-cur-card__actions--short": !this.props.shouldItemExpand }
    );

    const description = { __html: resource.description };
    const hash = resource.path.replace(/^\//, '');
    const resourceType = resource.type.name == 'grade' ? 'curriculum' : resource.type.name;
    const downloadBtnLabel = `Download ${_.capitalize(resourceType)}`;
    const downloadModalId = `downloads-modal-${resource.id}`

    return (
      <div id={this.props.curriculum.id} name={hash} className={cssClasses} onClick={this.props.onClickElement} data-magellanhash-target>
        {curriculumMap}
        <div className={cssCardClasses}>
          <div className="o-title u-margin-bottom--zero">
            <span className="o-title__type">{resource.short_title}</span>
            <span className="o-title__duration o-cur-card--show-full"><TimeToTeach duration={resource.time_to_teach} /></span>
          </div>
          <h2>{resource.title}</h2>
          <div className="u-html-description o-cur-card--show-medium" dangerouslySetInnerHTML={description}></div>
        </div>
        <div className={cssActionClasses}>
          <ul className="o-cur-card__menu o-cur-card__menu--medium o-cur-card--show-medium">
            <li><a className="o-ub-btn" href={resource.path}>View Details</a></li>
            <li><a className="o-ub-btn o-ub-btn--bordered" href="#" data-open={downloadModalId}>{downloadBtnLabel}</a></li>
            <li><a className="o-ub-btn o-ub-btn--bordered">Related Instruction</a></li>
          </ul>
          <ul className="o-cur-card__menu o-cur-card__menu--short o-cur-card--show-short" ref="dropdown">
            <li>
              <a href="#" className="o-cur-card__ellipsis"><i className="fa fa-lg fa-ellipsis-h"></i></a>
              <ul className="menu">
                <li><a href={resource.path}>View Details</a></li>
                <li><a href="#"data-open={downloadModalId}>{downloadBtnLabel}</a></li>
                <li><a href="#">Related Instruction</a></li>
              </ul>
            </li>
          </ul>
        </div>
      </div>
    );
  }
}
