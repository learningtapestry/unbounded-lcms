class FindLessonsHeader extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      per_page: this.props.per_page,
      order: this.props.order
    }

  }

  handleShowByClick(evt) {
    evt.preventDefault ? evt.preventDefault() : (evt.returnValue = false);
    if (this.state.per_page === parseInt(evt.target.value)) return;
    this.setState({per_page: parseInt(evt.target.value)}, this.callCallback);
  }

  handleSortByClick(evt) {
    evt.preventDefault ? evt.preventDefault() : (evt.returnValue = false);
    if (this.state.per_page === evt.target.value) return;
    this.setState({order: evt.target.value}, this.callCallback);
  }

  callCallback(selectedItem) {
    if (typeof(this.props.clickCallback) !== "undefined" &&
        typeof(this.props.clickCallback) === "function") {
      this.props.clickCallback(this.state);
    }
  }

  render() {
    let startLessonNum = (this.props.current_page - 1) * this.state.per_page + 1;
    let endLessonNum = startLessonNum +  this.props.num_items - 1;
    return (
      <div className="c-fl-s-header">
        <div className="c-fl-s-header__item">
          <p>Showing {startLessonNum}&mdash;{endLessonNum} of {this.props.total_hits} Lessons</p>
        </div>
        <div className="c-fl-s-header__item">
          <div className="c-fl-s-select">
            <div className="c-fl-s-select__item">
              <select value={this.state.per_page} onChange={this.handleShowByClick.bind(this)}>
                <option value="12">Show 12</option>
                <option value="24">Show 24</option>
              </select>
            </div>
            <div className="c-fl-s-select__item">
              <select value={this.state.order} onChange={this.handleSortByClick.bind(this)}>
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
