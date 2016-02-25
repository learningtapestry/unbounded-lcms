class FindLessonsHeader extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      show_by: this.props.show_by,
      sort_by: this.props.sort_by
    }

  }

  handleShowByClick(evt) {
    evt.preventDefault ? evt.preventDefault() : (evt.returnValue = false);
    if (this.state.show_by === parseInt(evt.target.value)) return;
    this.setState({show_by: parseInt(evt.target.value)}, this.callCallback);
  }

  handleSortByClick(evt) {
    evt.preventDefault ? evt.preventDefault() : (evt.returnValue = false);
    if (this.state.show_by === evt.target.value) return;
    this.setState({sort_by: evt.target.value}, this.callCallback);
  }

  callCallback(selectedItem) {
    if (typeof(this.props.clickCallback) !== "undefined" &&
        typeof(this.props.clickCallback) === "function") {
      this.props.clickCallback(this.state);
    }
  }

  render() {
    return (
      <div className="c-fl-s-header">
        <div className="c-fl-s-header__item">
          <p>Showing {this.props.num_items} of {this.props.total_hits} Lessons</p>
        </div>
        <div className="c-fl-s-header__item">
          <div className="c-fl-s-select">
            <div className="c-fl-s-select__item">
              <select value={this.state.show_by} onChange={this.handleShowByClick.bind(this)}>
                <option value="12">Show 12</option>
                <option value="24">Show 24</option>
              </select>
            </div>
            <div className="c-fl-s-select__item">
              <select value={this.state.sort_by} onChange={this.handleSortByClick.bind(this)}>
                <option value="asc">Sort by asc</option>
                <option value="desc">Sort by desc</option>
              </select>
            </div>
          </div>
        </div>
      </div>
    );
  }
}
