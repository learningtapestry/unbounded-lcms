class RelatedInstruction extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      id: props.id,
      resourceType: props.resource_type || 'Resource',
      instructions: props.instructions,
      expandedInstructions: [],
      expanded: false,
      hasMore: props.has_more,
    };
  }

  fetch() {
    let url = Routes.related_instruction_path(this.state.id, {expanded: !this.state.expanded});

    fetch(url).then(r => r.json()).then(response => {
      let sum = 0;
      let sliceIdx = _.findIndex(response.instructions,
                                 item => { sum += item.instruction_type === 'instruction' ? 2 : 1;
                                           return sum > 4; }
                                );
      if (sliceIdx == -1) sliceIdx = response.instructions.length;
      const newState = { instructions:  _.take(response.instructions, sliceIdx),
                         expandedInstructions:  _.slice(response.instructions, sliceIdx),
                         hasMore: false,
                         expanded: true
                       };
      this.setState(Object.assign({}, this.state, newState));
    });
  }

  handleBtnClick(evt) {
    this.fetch();
  }

  render () {
    const allInstructionsPath = Routes.enhance_instruction_index_path();
    const instructions = this.state.instructions.map(
        item => <InstructionCard key={item.id} item={item} />
    );
    const expandedInstructions = this.state.expandedInstructions.map(
        item => <InstructionCard key={item.id} item={item} />
    );
    const actions = (this.state.instructions.length == 0) ?
      <p className="o-related-instruction__empty lead">
        This {_.capitalize(this.state.resourceType)} doesn&rsquo;t have any related instructions. To see all visit <a href={allInstructionsPath}>Enhance Instruction</a>.
      </p> :
      <ul className="o-related-instruction__actions">
        { this.state.hasMore ?
          <li><a className="o-ub-btn o-ub-btn--yellow u-margin-bottom--zero" onClick={this.handleBtnClick.bind(this)}>More Instruction</a></li>
          : false
        }
        <li><a className="o-ub-btn o-ub-btn--2bordered-gray u-margin-bottom--zero" href={allInstructionsPath}>All Instructions</a></li>
      </ul>;

    return (
      <div className="o-related-instruction o-page__module u-pd-content--xlarge">
        <h2 className="o-related-instruction__title">Related Instruction</h2>
        <p className="o-related-instruction__teaser">
          Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat
        </p>
        <div className="o-related-instruction__list o-page__wrap--row-nest">
          {instructions}
        </div>
        <div className="o-related-instruction__list">
          <React.addons.CSSTransitionGroup transitionName="m-fadeIn" transitionEnterTimeout={400} transitionLeaveTimeout={0} component="div" className="o-page__wrap--row-nest">
            {expandedInstructions}
          </React.addons.CSSTransitionGroup>
        </div>
        {actions}
      </div>
     );
   }
}
