class Searchbar extends React.Component {
  constructor(props) {
    super(props);

    let initialState = {
      search_term: this.props.search_term
    };
    this.state = this.withQuery(initialState);
  }

  withQuery(state) {
    state.query = this.createQuery(state);
    return state;
  }

  createQuery(state) {
    let query = {
      search_term: state.search_term,
    };
    return query;
  }


  componentWillUpdate(nextProps, nextState) {
    if ('onUpdate' in this.props) {
      if ($.param(this.state.query) !== $.param(nextState.query)) {
        this.props.onUpdate( nextState );
      }
    }
  }

  onUpdateSearch(value) {
    console.log('onUpdateSearch:', value);
    this.setState(this.withQuery({
      ...this.state,
      search_term: value
    }));
  }

  render() {
    const state = this.state;

    return (
      <div className='o-searchbar'>
        <SearchInput
          searchTerm={this.state.search_term}
          onUpdate={this.onUpdateSearch.bind(this)}/>
      </div>
    );
  }
};
