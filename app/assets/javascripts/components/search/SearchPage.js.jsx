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

  fetch(newState) {
    let query = {
      format: 'json',
      per_page: newState.per_page,
      order: newState.order,
      page: newState.current_page,
      ...newState.filterbar,
    }
    let url = Routes.search_path(query);

    fetch(url).then(r => r.json()).then(response => {
      this.setState(this.buildStateFromProps(response));
    });
  }

  handlePageClick(data) {
    let selected = data.selected;
    const newState = _.assign({}, this.state, { current_page: selected + 1 });
    this.fetch(newState);
  }

  handleFilterbarUpdate(filterbar) {
    const newState = _.assign({}, this.state, { filterbar: filterbar, current_page: 1  });
    this.fetch(newState);
  }

  componentWillUpdate(nextProps, nextState) {
    urlHistory.updatePaginationParams(nextState);
  }

  render () {
    return (
      <div>
        <div className="u-bg--base">
          <div className="o-page">
            <div className="o-page__module">
              <div className="o-filterbar-title">
                <h2>Search results</h2>
                <div className="o-filterbar-title__subheader">
                  Filter by subject or grade, or search to reveal assets.
                </div>
              </div>
              <Filterbar
                onUpdate={this.handleFilterbarUpdate.bind(this)}
                searchLabel='Search the site'
                withFacets={true}
                withSearch={true}
                {...this.state.filterbar} />
            </div>
          </div>
        </div>
        <div className="o-page u-margin-bottom--large">
          <div className="o-page__module">
          { ( this.state.resources.length == 0 ) ?
              <SearchResultsEmpty searchTerm={this.state.filterbar.search_term} /> :

              <SearchResults
                resources={this.state.resources}
                current_page={this.state.current_page}
                per_page={this.state.per_page}
                total_hits={this.state.total_hits} />
          }

          <PaginationBoxView previousLabel={<i className="fa-2x ub-angle-left"></i>}
                          nextLabel={<i className="fa-2x ub-angle-right"></i>}
                          breakLabel={<li className="o-pagination__break">...</li>}
                          pageNum={this.state.total_pages}
                          initialSelected={this.state.current_page - 1}
                          forceSelected={this.state.current_page - 1}
                          marginPagesDisplayed={2}
                          pageRangeDisplayed={5}
                          clickCallback={this.handlePageClick.bind(this)}
                          containerClassName={"o-pagination o-page__wrap--row-nest"}
                          itemClassName={"o-pagination__item"}
                          nextClassName={"o-pagination__item--next"}
                          previousClassName={"o-pagination__item--prev"}
                          pagesClassName={"o-pagination__item--middle"}
                          subContainerClassName={"o-pagination__pages"}
                          activeClassName={"o-pagination__page--active"} />
        </div>
      </div>
    </div>
     );
   }
}
