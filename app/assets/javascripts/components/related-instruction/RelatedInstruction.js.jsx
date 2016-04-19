class RelatedInstruction extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      id: props.resource.id,
      related_instruction: [],
      expanded: false,
    };
  }

  fetch() {
    let url = Routes.related_instruction_path(this.state.id, {expanded: this.state.expanded});

    fetch(url).then(r => r.json()).then(response => {
      this.setState(Object.assign({}, this.state, {related_instruction: response.resources}));
    });
  }

  componentDidMount() {
    this.fetch();
  }

  relatedInstructionList() {
    return $('.o-related-instruction__list');
  }

  componentWillUpdate(nextProps, nextState) {
    if (this.state.expanded !== nextState.expanded) {
      this.relatedInstructionList().fadeOut();
    }
  }

  componentDidUpdate(prevProps, prevState) {
    if (this.state.expanded !== prevState.expanded) {
      this.relatedInstructionList().fadeIn();
    }
  }

  handleBtnClick(evt) {
    this.setState(Object.assign({}, this.state, {expanded: !this.state.expanded}), this.fetch)
  }

  btnLabel() {
    return this.state.expanded ? 'Show Less' : 'Show More';
  }

  render () {
    const allInstructionsPath = Routes.enhance_instruction_index_path();
    return (
      <div id="related-instruction" className="o-related-instruction">

        <h2 className="o-related-instruction__title">Related Instruction</h2>

        <p className="o-related-instruction__teaser">
          Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat
        </p>

        <div className="o-related-instruction__list o-dsc__cards">
          {
            this.state.related_instruction.map((item)=> {
              {/* TODO implement cards properly */}
              return <RelatedInstructionItem key={item.id} item={item} />;
            })
          }
        </div>

        <div className="o-related-instruction__actions">

          <button className="o-related-instruction__action o-related-instruction__action--expand"
                  onClick={this.handleBtnClick.bind(this)}>{this.btnLabel()}</button>
                <a className="o-related-instruction__action o-related-instruction__action--all"
                   href={allInstructionsPath}>All Instructions</a>
        </div>
      </div>
     );
   }
}
