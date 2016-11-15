class ResourceHover extends React.Component {
  handleMouseOver () {
    if (Modernizr.touchevents) return;
    newState = { isHovering: true,
                 resource: this.props.resource };
    this.props.handlePopupState(newState);
  }

  handleMouseOut () {
    if (Modernizr.touchevents) return;
    newState = { isHovering: false,
                 resource: this.props.resource };
    this.props.handlePopupState(newState);
  }

  render () {
    const props = this.props;
    return (
      <a href={props.resource.path} className={props.cssClasses}
         style={props.styles}
         onMouseOver={this.handleMouseOver.bind(this)}
         onMouseOut={this.handleMouseOut.bind(this)}>
           {props.resourceHtml}
      </a>
    );
  }
}
