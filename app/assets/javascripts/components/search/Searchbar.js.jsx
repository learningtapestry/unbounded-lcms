class Searchbar extends React.Component {
  constructor(props) {
    super(props);

    let initialState = {
      facets: [
        { displayName: 'CURRICULUM', name: 'curriculum', selected: false },
        { displayName: 'INSTRUCTION', name: 'instruction', selected: false }
      ]
    };

    if ('facets' in this.props) {
      _
      .chain(initialState.facets)
      .filter(s => _.includes(this.props.facets, s.name))
      .forEach(s => {
        s.selected = true;
      })
      .value();
    }

    this.state = this.withQuery(initialState);
  }

  withQuery(state) {
    state.query = this.createQuery(state);
    return state;
  }

  createQuery(state) {
    let query = {
      facets: _.chain(state.facets)
        .filter((facet) => facet.selected)
        .map(facet => facet.name)
        .value()
    };
    return query;
  }

  onClickFacet(incoming) {
    this.setState(this.withQuery({
      ...this.state,
      grades: this.state.facets.map(facet => {
        if (incoming.name !== facet.name) return facet;
        return _.merge({}, facet, { selected: !facet.selected })
      })
    }));
  }

  componentWillUpdate(nextProps, nextState) {
    if ('onUpdate' in this.props) {
      if ($.param(this.state.query) !== $.param(nextState.query)) {
        this.props.onUpdate( nextState );
      }
    }
  }

  render() {
    const state = this.state;

    return (
      <div className='o-searchbar'>
        <div className='o-searchbar__facets-list'>
          {state.facets.map(facet => {
            return (
              <SearchbarFacet
                key={facet.name}
                onClick={this.onClickFacet.bind(this, facet)}
                displayName={facet.displayName}
                selected={facet.selected} />
            );
          })}
        </div>
        <SearchInput />
      </div>
    );
  }
};
