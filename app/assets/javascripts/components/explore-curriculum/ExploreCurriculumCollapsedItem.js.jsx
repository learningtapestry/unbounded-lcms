class ExploreCurriculumCollapsedItem extends React.Component {
  componentDidMount() {
    let el = new Foundation.DropdownMenu($(this.refs.dropdown), { 'alignment': 'right' });
  }

  componentWillUnmount() {
    $(this.refs.dropdown).foundation('destroy');
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
      expanded: false,
      onClickDetails: this.props.onClickExpand,
      curriculum: this.props.curriculum
    });

    const cssClasses = classNames(
      "o-cur-card",
      "o-cur-card--short",
      `o-cur-card--${this.props.curriculum.type}`
    );

    const resourceType = resource.type.name == 'grade' ? 'curriculum' : resource.type.name;
    const downloadBtnLabel = `Download ${_.capitalize(resourceType)}`;

    return (
      <div id={this.props.curriculum.id} className={cssClasses}>
        {curriculumMap}
        <div className="o-cur-card__body o-cur-card__body--short" onClick={this.props.onClickExpand}>
          <strong className="u-text--capitalized">{resource.short_title}</strong>
          <span> {resource.title}</span>
          <span> {resource.text_description}</span>
        </div>
        <div className="o-cur-card__actions">
          <ul className="menu" ref="dropdown">
            <li>
              <a href="#" className="o-cur-card__ellipsis"><i className="fa fa-lg fa-ellipsis-h"></i></a>
              <ul className="menu">
                <li><a href={resource.path}>View Details</a></li>
                <li><a href="#">{downloadBtnLabel}</a></li>
                <li><a href="#">Related Instruction</a></li>
              </ul>
            </li>
          </ul>
        </div>
      </div>
    );
  }
}
