class FilterbarSearch extends React.Component {
  constructor(props) {
    super(props);
    this.state = {value: props.searchTerm};

    this.debouncedUpdate = _.debounce(function(value) {
      if ('onUpdate' in this.props) {
        this.props.onUpdate( value );
      }
    }, 300);
  }

  handleChange (event) {
    this.setState({value: event.target.value});
    this.debouncedUpdate(event.target.value);
  }

  render() {
    return (
      <input className='o-filterbar__search' type='text' placeholder='Enter Terms (e.g: writing, geometry, etc)' value={this.state.value} onChange={this.handleChange.bind(this)}/>
    );
  }
}
