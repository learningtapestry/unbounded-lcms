class AssociationPicker extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      items: this.props.items || []
    };
  }

  componentDidMount() {
    new Foundation.Reveal(this.modal);
    this.modal.on('open.zf.reveal', () => this.modal.css({top: '15px'}));
  }

  onClickSelect() {
    const picker = React.createElement(AssociationPickerWindow, {
      onSelectItem: this.selectItem.bind(this),
      association: this.props.association,
      allowCreate: this.props.allow_create
    }, null);
    ReactDOM.render(picker, this.modal[0]);
    this.modal.foundation('open');
  }

  selectItem(item) {
    ReactDOM.unmountComponentAtNode(this.modal[0]);
    this.modal.foundation('close');

    const newItems = this.props.allow_multiple ?
      [...this.state.items, item] :
      [item];

    this.setState({
      ...this.state,
      items: newItems
    });
  }

  removeItem(item) {
    this.setState({
      ...this.state,
      items: _.filter(this.state.items, r => r.id !== item.id)
    });
  }

  render() {
    const items = this.state.items.map((item, i) => {
      return <AssociationPickerItem
        key={item.id}
        name={this.props.name}
        create_name={this.props.create_name}
        association={this.props.association}
        allow_multiple={this.props.allow_multiple}
        item={item}
        onClickClose={() => this.removeItem(item)}
      />;
    });

    const blankInput = this.props.allow_multiple ?
      <input type="hidden" name={`${this.props.name}[]`} value="" /> :
      <span className="hide" />;

    return (
      <div className="o-assocpicker-container">
        <button
          type="button"
          className="o-assocpicker-add button"
          onClick={e => this.onClickSelect(e)}>Select</button>
        <div className="o-assocpicker-selections">
          {blankInput}
          {items}
        </div>
        <div
          className="o-assocpicker-modal reveal"
          ref={m => this.modal = $(m)}>
        </div>
      </div>
    );
  }
}
