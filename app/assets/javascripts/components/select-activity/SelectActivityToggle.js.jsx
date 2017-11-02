/* eslint-disable no-unused-vars */
class SelectActivityToggle extends React.Component {
  constructor(props) {
    super(props);

    this.toggle = this.toggle.bind(this);
    this.modalText = [
      this.props.preface ? this.props.preface.textContent : null,
      this.props.meta ? this.props.meta.textContent : null,
    ].filter(x => !!x).join(' ');
  }

  render() {
    return (
      <div className="o-ld-selection">
        <div className="o-ld-selection__switch" onClick={this.toggle}></div>
        <span className="o-ld-selection__label" onClick={this.toggle}>Use Activity</span>
        { this.props.item.active && <SelectActivityConfirmationModal text={this.modalText} { ...this.props } /> }
      </div>
    );
  }

  toggle() {
    const item = this.props.item;
    if (item.active && this.modalText) {
      if (item.isOptional) {
        heap.track('Optional Activity Enabled', { id: item.id});
        this.props.callback();
      } else {
        heap.track('Click to Deselect Activity', { id: item.id });
        $(document.getElementById(`confirm-${item.id}`)).foundation('open');
      }
    } else {
      const event = item.isOptional ? 'Optional Activity Disabled' : 'Activity Selected';
      heap.track(event, { id: item.id });
      this.props.callback();
    }
  }
}
