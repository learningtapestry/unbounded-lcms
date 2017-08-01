class SelectActivityToggle extends React.Component {
  constructor(props) {
    super(props)

    this.toggle = this.toggle.bind(this)
    this.modalText = this.props.meta ? this.props.meta.textContent : null
  }

  render() {
    return (
      <div className="o-ld-selection" onClick={this.toggle}>
        <div className="o-ld-selection__switch"></div>
        <span className="o-ld-selection__label">Use Activity</span>
        { this.props.item.active && <SelectActivityConfirmationModal text={this.modalText} { ...this.props } /> }
      </div>
    )
  }

  toggle() {
    const item = this.props.item;
    if (item.active && this.modalText) {
      heap.track('Click to Deselect Activity', { id: item.id });
      $(document.getElementById(`confirm-${item.id}`)).foundation('open');
    } else {
      heap.track('Activity Selected', { id: item.id });
      this.props.callback();
    }
  }
}
