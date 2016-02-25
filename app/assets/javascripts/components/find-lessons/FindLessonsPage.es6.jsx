class FindLessonsPage extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      show_by: this.props.meta.show_by,
      sort_by: this.props.meta.sort_by,
      page: this.props.meta.current_page
    }
  }

  loadDataFromServer() {
    location.href = location.pathname + '?' + $.param(this.state);
  }

  handlePageClick(data) {
    let selected = data.selected;
    this.setState({page: selected + 1}, this.loadDataFromServer);
  }

  handleHeaderChanged(data) {
    let newState = Object.assign({}, this.state, data);
    this.setState(newState, this.loadDataFromServer);
  }

  render () {
    return (
      <div className="o-page__wrap--nest">
         <FindLessonsHeader {...this.props.meta}
                            num_items={this.props.data.length}
                            clickCallback={this.handleHeaderChanged.bind(this)} />
         <FindLessonsCards data={this.props.data} />
         <PaginationBoxView previousLabel={"< Previous"}
                         nextLabel={"Next >"}
                         breakLabel={<li className="break"><a href="">...</a></li>}
                         pageNum={this.props.meta.total_pages}
                         initialSelected={this.props.meta.current_page - 1}
                         marginPagesDisplayed={2}
                         pageRangeDisplayed={5}
                         clickCallback={this.handlePageClick.bind(this)}
                         containerClassName={"o-pagination"}
                         itemClassName={"o-pagination__item"}
                         nextClassName={"o-pagination__item--next"}
                         previousClassName={"o-pagination__item--prev"}
                         pagesClassName={"o-pagination__item--middle"}
                         subContainerClassName={"o-pagination__pages"}
                         activeClassName={"o-pagination__page--active"} />
       </div>
     );
   }
}
