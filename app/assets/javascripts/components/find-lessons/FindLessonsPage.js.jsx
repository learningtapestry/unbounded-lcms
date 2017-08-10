class FindLessonsPage extends React.Component {
  constructor(props) {
    super(props);

    this.state = this.buildStateFromProps(props);
  }

  buildStateFromProps(props) {
    return {
      lessons: props.results,
      per_page: props.pagination.per_page,
      order: props.pagination.order,
      current_page: props.pagination.current_page,
      total_pages: props.pagination.total_pages,
      num_items: props.pagination.num_items,
      total_hits: props.pagination.total_hits,
      filterbar: props.filterbar
    };
  }

  fetch(newState) {
    const url = Routes.find_lessons_path({
      per_page: newState.per_page,
      order: newState.order,
      page: newState.current_page,
      ...newState.filterbar
    });

    return $.getJSON(url).then(response => {
      if (window.ga) {
        ga('send', 'pageview', url);
      }
      this.setState(this.buildStateFromProps(response));
    });
  }

  handlePageClick(data) {
    const selected = data.selected;
    const newState = _.assign({}, this.state, { current_page: selected + 1 });
    this.fetch(newState);
  }

  handleChangePerPage(event) {
    const newPerPage = event.target.value;
    const newState = _.assign({}, this.state, { per_page: newPerPage, current_page: 1 });
    this.fetch(newState);
  }

  handleChangeOrder(event) {
    const newOrder = event.target.value;
    const newState = _.assign({}, this.state, { order: newOrder, current_page: 1 });
    this.fetch(newState);
  }

  handleFilterbarUpdate(filterbar) {
    const newState = _.assign({}, this.state, { filterbar: filterbar, current_page: 1 });
    this.fetch(newState);
  }

  componentWillUpdate(nextProps, nextState) {
    urlHistory.updatePaginationParams(nextState);
  }

  render () {
    return (
      <div>
        <div className="u-bg--base-gradient">
          <div className="o-page">
            <div className="o-page__module">
              <div className="o-filterbar-title">
                <h2>Find Lessons</h2>
                <div className="o-filterbar-title__subheader">
                  Search our free collection for specific lessons or topics within a grade. Download, adapt, share.
                </div>
              </div>
              <FilterbarResponsive
                searchLabel='What do you want to teach?'
                withSearch={true}
                onUpdate={this.handleFilterbarUpdate.bind(this)}
                {...this.state.filterbar} />
            </div>
          </div>
        </div>
        <div className="o-page o-page--margin-bottom">
          <div className="o-page__module">
            { (this.state.lessons.length > 0) ?
              <SearchResultsHeader
                onChangePerPage={this.handleChangePerPage.bind(this)}
                current_page={this.state.current_page}
                per_page={this.state.per_page}
                num_items={this.state.lessons.length}
                total_hits={this.state.total_hits}
                per_page={this.state.per_page}
                order={this.state.order} />

              : false
            }

            { (this.state.lessons.length > 0) ?
              <FindLessonsCards lessons={this.state.lessons} />

              : <FindLessonsCardsEmpty searchTerm={this.state.filterbar.search_term} />
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
