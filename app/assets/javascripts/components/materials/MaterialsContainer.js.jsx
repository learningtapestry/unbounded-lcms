class MaterialsContainer extends React.Component {
  constructor(props) {
    super(props);
    this.state = {bExpanded: false, activeTab: 0};
    this.toggleView = this.handleToggleView.bind(this);
  }

  handleToggleView(newState, idx = 0) {
    this.setState({bExpanded: newState, activeTab: idx});
  }

  renderTab(m, idx) {
    return (
      <Tabs.Panel key={`p-${m.idx}`} title={m.subtitle}>
        <ExpandedMaterial key={`exm${m.id}`} index={idx} {...m} onMinimize={this.toggleView}/>
      </Tabs.Panel>
    );
  }

  render() {
    const { data, pdf_type, subject } = this.props;
    if (!_.includes(['none', 'tm'], pdf_type)) return null;
    if (pdf_type === 'tm') {
      return (
        <MaterialsList {...this.props}/>
      );
    }
    let materials = null;
    if (this.state.bExpanded) {
      materials = data.map((m, idx) => this.renderTab(m, idx));
    } else {
      materials = data.map((m, idx) => <CollapsedMaterial key={`cm-${m.id}`} index={idx} onPreview={this.toggleView} {...m}/>);
    }
    const clsTitle = classNames(
      'u-txt--m-tab-title',
      {'o-m-title--underlined': !this.state.bExpanded }
    );

    return (
      <div className={`u-padding-bottom--gutter o-page__section o-material-wrapper o-material-wrapper--${subject}`}>
        <div className={clsTitle}>Material(s)</div>
        { this.state.bExpanded ? (
          <div key={"key-m-wrap-expanded"} className="o-page__wrap--row">
            <Tabs tabActive={this.state.activeTab + 1} className="o-page__module">
               {materials}
            </Tabs>
          </div>
          ) : (
          <div key={"key-m-wrap-collapsed"} className="o-page__wrap--row-nest">
            {materials}
          </div>
          )
        }
      </div>
    );
  }
}
