class ResourcePreview extends React.Component {
  constructor(props) {
    super(props);
    this.hOffset = 30;
  }

  render() {
    const props = this.props;
    let styles;
    if (props.isHovering) {
      let $anchorDims = Foundation.Box.GetDimensions(props.anchor);
      styles = { left: $anchorDims.offset.left + $anchorDims.width + this.hOffset,
                 top: $anchorDims.offset.top
               };
    }
    const cssStyles = classNames('dropdown-pane',
                                 { 'is-open': props.isHovering });
    return (
      <div className={cssStyles} style={styles}>
        <strong>{props.resource.title}</strong>
        <p>{props.resource.teaser}</p>
      </div>
    );
  }
}
