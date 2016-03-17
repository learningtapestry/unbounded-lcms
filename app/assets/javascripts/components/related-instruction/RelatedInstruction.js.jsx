class RelatedInstruction extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      id: props.resource.id,
      limit: 4,
      related_instruction: []
    };
  }

  fetch() {
    console.log('fetch', this.state)
    let url = Routes.related_instruction_path(this.state.id, {limit: this.state.limit});

    fetch(url).then(r => r.json()).then(response => {
      this.setState(Object.assign({}, this.state, {related_instruction: response.resources}));
    });
  }

  componentDidMount() {
    this.fetch();
  }

  render () {
    return (
      <div className="o-related-instruction">

        <h2 className="o-related-instruction__title">Related Instruction</h2>

        <p className="o-related-instruction__teaser">
          Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat
        </p>

        <div className="o-related-instruction__list">
          {
            this.state.related_instruction.map((resource)=> {
              {/* TODO implement cards properly */}
              return <div key={resource.id}>{resource.title}</div>
            })
          }
        </div>

        <div className="o-related-instruction__controls">
          <button>show more</button>
        </div>
      </div>
     );
   }
}
