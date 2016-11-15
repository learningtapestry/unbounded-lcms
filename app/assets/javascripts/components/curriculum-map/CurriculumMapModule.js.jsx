class CurriculumMapModule extends React.Component {
  constructor(props) {
    super(props);
    this.state = { isHovering: false, resource: { title: '' } };
    this._handlePopupState = this.handlePopupState.bind(this);
    this.WINDOW_BREAKPOINT = 768;
  }

  handlePopupState(newState) {
    if ((newState == this.state) || ($(window).width() < this.WINDOW_BREAKPOINT)) return;
    this.setState(newState);
  }

  render() {
    const props = this.props;
    const curriculum = props.curriculum;
    const isActive = _.includes(props.active, curriculum.id);
    const cssClasses = classNames( 'o-c-map__module',
                                 { 'cs-bg--base': !isActive,
                                  [`cs-bg--${props.colorCode}`]: isActive });

    const units = curriculum.children.map(
      unit => <CurriculumMapUnit key={unit.resource.id}
                                 curriculum={unit}
                                 colorCode={props.colorCode}
                                 active={props.active}
                                 handlePopupState={this._handlePopupState} />
    );
    return (
      <div>
        <div className='o-c-map__module-wrap' ref={ (m) => this.domModule = m }>
          <ResourceHover cssClasses={cssClasses}
                         styles={props.styles}
                         resource={curriculum.resource}
                         resourceHtml={curriculum.resource.short_title}
                         handlePopupState={this._handlePopupState}/>
          <ResourcePreview anchor={this.domModule}
                           isHovering={this.state.isHovering}
                           resource={this.state.resource}
                           colorCode={props.colorCode}
          />
        </div>
        <div className='o-c-map__units-wrap'>
          <div className='o-c-map__units'>
            {units}
          </div>
        </div>
      </div>
    );
  }
}
