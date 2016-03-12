class SearchPage extends React.Component {
  constructor(props) {
    super(props);

    this.state = this.buildStateFromProps(props);
  }

  buildStateFromProps(props) {
    return {
      resources: props.results,
      per_page: props.pagination.per_page,
      order: props.pagination.order,
      current_page: props.pagination.current_page,
      total_pages: props.pagination.total_pages,
      num_items: props.pagination.num_items,
      total_hits: props.pagination.total_hits,
      filterbar: props.filterbar,
    };
  }

  fetch() {
    let query = {
      format: 'json',
      per_page: this.state.per_page,
      order: this.state.order,
      page: this.state.current_page,
      ...this.state.filterbar.query,
    }
    let url = Routes.search_path(query);

    fetch(url).then(r => r.json()).then(response => {
      this.setState(this.buildStateFromProps(response));
    });
  }

  handlePageClick(data) {
    let selected = data.selected;
    this.setState(Object.assign({}, this.state, { current_page: selected + 1 }), this.fetch);
  }

  handleFilterbarUpdate(filterbar) {
    this.setState(Object.assign({}, this.state, { filterbar: filterbar }), this.fetch);
  }

  render () {
    return (
      <div className="o-page__wrap--nest">
        <Filterbar
          onUpdate={this.handleFilterbarUpdate.bind(this)}
          withFacets={true}
          withSearch={true}
          {...this.props.filterbar} />

        { ( this.state.resources.length == 0 ) ?
            <SearchResultsEmpty /> :

            <SearchResults
              resources={this.state.resources}
              current_page={this.state.current_page}
              per_page={this.state.per_page}
              total_hits={this.state.total_hits} />
        }

        <PaginationBoxView previousLabel={"< Previous"}
                        nextLabel={"Next >"}
                        breakLabel={<li className="break"><a href="">...</a></li>}
                        pageNum={this.state.total_pages}
                        initialSelected={this.state.current_page - 1}
                        forceSelected={this.state.current_page - 1}
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
