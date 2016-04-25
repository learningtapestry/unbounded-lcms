class ExploreCurriculumCardItem extends React.Component {
  componentDidMount() {
    new Foundation.DropdownMenu($(this.refs.dropdown), { 'alignment': 'right' });
  }

  componentWillUnmount() {
    if (this.refs.dropdown) {
      $(this.refs.dropdown).foundation('destroy');
    }
  }

  render() {
    const props = this.props;
    const resource = props.curriculum.resource;
    const hasDownloads = resource.downloads && resource.downloads.length > 0;
    const colorCode = props.colorCode;

    const curriculumComponent = {
      'grade': ExploreCurriculumGradeMap,
      'module': ExploreCurriculumModuleMap,
      'unit': ExploreCurriculumUnitMap,
      'lesson': ExploreCurriculumGradeMap
    }[props.curriculum.type];

    const curriculumMap = React.createElement(curriculumComponent, {
      expanded: props.shouldItemExpand,
      curriculum: props.curriculum,
      colorCode: colorCode
    });

    const cssClasses = classNames(
      "o-cur-card",
      `o-cur-card-hover--${props.colorCode}`,
      { "o-cur-card--short": !props.shouldItemExpand },
      `o-cur-card--${props.curriculum.type}`
    );

    const cssActionClasses = classNames(
      "o-cur-card__actions",
      {"o-cur-card__actions--short": !props.shouldItemExpand }
    );

    const cssDownloadBtnClasses = classNames(
      "o-ub-btn", "o-ub-btn--bordered",
      {"o-ub-btn--disabled": !hasDownloads }
    );

    const cssDownloadLinkClasses = classNames(
      {"u-link--disabled": !hasDownloads }
    );

    const resourceType = resource.type.name == 'grade' ? 'curriculum' : resource.type.name;
    const downloadBtnLabel = `Download ${_.capitalize(resourceType)}`;
    const downloadModalId = `downloads-modal-${resource.id}`;

    return (
      <div id={props.curriculum.id} name={resource.path} onClick={props.onClickElement} className={cssClasses} data-magellanhash-target>
        {curriculumMap}
        <div className="o-cur-card__body">
          <div className="o-title u-text--uppercase">
            <span className={`o-title__type u-txt--${colorCode}`}>{resource.short_title}</span>
            <span className="o-title__duration o-cur-card--show-medium"><TimeToTeach duration={resource.time_to_teach} /></span>
          </div>
          <h3 className="o-cur-card__dsc--short">{resource.title}</h3>
          <div className="o-cur-card--show-medium o-cur-card__dsc--full">{resource.teaser}</div>
        </div>
        <div className={cssActionClasses}>
          <ul className="o-cur-card__menu o-cur-card__menu--medium o-cur-card--show-medium">
            <li><a className="o-ub-btn" href={resource.path}>View Details</a></li>
            <li><a className={cssDownloadBtnClasses} data-open={downloadModalId}>{downloadBtnLabel}</a></li>
            <li><a className="o-ub-btn o-ub-btn--bordered o-ub-btn--disabled">Related Instruction</a></li>
          </ul>
          <ul className="o-cur-card__menu o-cur-card__menu--short o-cur-card--show-short" ref="dropdown">
            <li>
              <a href="#" className="o-cur-card__ellipsis"><i className="ub-ellipsis fa-3x"></i></a>
              <ul className="menu">
                <li><a href={resource.path}>View Details</a></li>
                <li><a className={cssDownloadLinkClasses} data-open={downloadModalId}>{downloadBtnLabel}</a></li>
                <li><a className="u-link--disabled">Related Instruction</a></li>
              </ul>
            </li>
          </ul>
        </div>
      </div>
    );
  }
}
