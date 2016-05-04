class ResourcePicker extends React.Component {
  constructor(props) {
    super(props);

    const resources = 'resources' in props ? props.resources : [];

    this.state = {
      resources:  resources
    };
  }

  get jqmodal() {
    return $(this.modal);
  }

  componentDidMount() {
    new Foundation.Reveal(this.jqmodal);
    this.jqmodal.on('open.zf.reveal', () => this.jqmodal.css({top: '15px'}));
    this.jqmodal.on('closed.zf.reveal', () => {
      ReactDOM.unmountComponentAtNode(this.modal);
    });
  }

  onClickSelect() {
    const picker = React.createElement(ResourcePickerWindow, {
      onSelectResource: this.selectResource.bind(this),
    }, null);
    ReactDOM.render(picker, this.modal);
    this.jqmodal.foundation('open');
  }

  selectResource(resource) {
    this.jqmodal.foundation('close');

    this.setState({
      ...this.state,
      resources: [...this.state.resources, resource]
    });
  }

  removeResource(resource) {
    this.setState({
      ...this.state,
      resources: _.filter(this.state.resources, r => r.id !== resource.id)
    });
  }

  render() {
    const resources = this.state.resources.map(resource => {
      return <ResourcePickerResource
        key={resource.id}
        name={this.props.name}
        resource={resource}
        onClickClose={() => this.removeResource(resource)}
      />;
    });

    return (
      <div className="o-assocpicker-container">
        <button
          type="button"
          className="o-assocpicker-add button"
          onClick={e => this.onClickSelect(e)}>Select</button>
        <div className="o-assocpicker-selections">
          <input type="hidden" name={this.props.name} value="" />
          {resources}
        </div>
        <div
          className="o-assocpicker-modal reveal"
          ref={m => this.modal = m}>
        </div>
      </div>
    );
  }
}
