class FilterbarResponsive extends React.Component {
  constructor(props) {
    super(props);
    this.state = { breakpoint: 'xxlarge', ...this.props};
    this.WINDOW_BREAKPOINT = 768;
    this.WINDOW_BREAKPOINT_NAMES = ['small', 'medium'];
  }

  handleResize(event, newSize, oldSize) {
    if (_.intersection(this.WINDOW_BREAKPOINT_NAMES, [oldSize, newSize]).length > 0) {
      this.setState({ breakpoint: newSize });
    }
  }

  componentDidMount() {
    $(window).on('changed.zf.mediaquery', this.handleResize.bind(this));
    if ($(window).width() <  this.WINDOW_BREAKPOINT) {
      this.setState({ breakpoint: this.WINDOW_BREAKPOINT_NAMES[0] });
    }
  }

  componentWillUnmount() {
    $(window).off('changed.zf.mediaquery', this.handleResize);
  }

  isMobile() {
    return _.indexOf(this.WINDOW_BREAKPOINT_NAMES, this.state.breakpoint) != -1;
  }

  onClickRefine() {
    $(this.refs.modal).addClass('o-filterbar-modal--show');
  }

  handleRefineClick() {
    $(this.refs.modal).removeClass('o-filterbar-modal--show');
  }

  render() {
    if (this.isMobile()) {
      return (
        <div className="text-center">
          <a className="o-btn o-btn--yellow u-margin-bottom--large" onClick={this.onClickRefine.bind(this)}>Refine Results</a>
          <div className="o-filterbar-modal" ref="modal">
            <Filterbar
               {...this.state}
                withDropdown={false}
                onRefine={this.handleRefineClick.bind(this)} />
          </div>
        </div>
      );
    }
    return (
      <Filterbar {...this.state}/>
    );
  }

}
