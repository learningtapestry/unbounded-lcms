class EnhanceInstructionPage extends React.Component {
  constructor(props) {
    super(props);

    this.state = this.buildStateFromProps(props);
  }

  buildStateFromProps(props) {
    return {
      instructions: props.results,
      per_page: props.pagination.per_page,
      order: props.pagination.order,
      current_page: props.pagination.current_page,
      total_pages: props.pagination.total_pages,
      num_items: props.pagination.num_items,
      total_hits: props.pagination.total_hits,
      filterbar: props.filterbar
    };
  }

  createQuery(newState) {
    return {
      format: 'json',
      per_page: newState.per_page,
      order: newState.order,
      page: newState.current_page,
      ...newState.filterbar
    };
  }

  fetch(newState) {
    const query = this.createQuery(newState);
    const url = Routes.enhance_instruction_index_path(query);
    fetch(url).then(r => r.json()).then(response => {
      this.setState(this.buildStateFromProps(response));
    });
  }

  handlePageClick(data) {
    const selected = data.selected;
    const newState = Object.assign({}, this.state, { current_page: selected + 1 });
    this.fetch(newState);
  }

  handleChangePerPage(event) {
    const newPerPage = event.target.value;
    const newState = Object.assign({}, this.state, { per_page: newPerPage });
    this.fetch(newState);
  }

  handleChangeOrder(event) {
    const newOrder = event.target.value;
    const newState = Object.assign({}, this.state, { order: newOrder });
    this.fetch(newState);
  }

  handleFilterbarUpdate(filterbar) {
    const newState = Object.assign({}, this.state, { filterbar: filterbar });
    this.fetch(newState);
  }

  render() {
    return (
      <div className="o-page__wrap--nest">
        <Filterbar
          onUpdate={this.handleFilterbarUpdate.bind(this)}
            {...this.props.filterbar} />
        <Tabs tabActive={1} className='c-eh-tab'>
           <Tabs.Panel title='Content Guides'>
             <SearchResultsHeader
               onChangePerPage={this.handleChangePerPage.bind(this)}
               onChangeOrder={this.handleChangeOrder.bind(this)}
               current_page={this.state.current_page}
               per_page={this.state.per_page}
               num_items={this.state.instructions.length}
               total_hits={this.state.total_hits}
               per_page={this.state.per_page}
               order={this.state.order} />
             <EnhanceInstructionCards instructions={this.state.instructions} />
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
           </Tabs.Panel>
           <Tabs.Panel title='Videos'>
             <div className="o-page__section u-margin-top--base"><h3>Under Construction</h3></div>
           </Tabs.Panel>
        </Tabs>
       </div>
    );
  }
}