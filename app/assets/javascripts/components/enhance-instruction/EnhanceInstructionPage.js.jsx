class EnhanceInstructionPage extends React.Component {
  constructor(props) {
    super(props);

    let initTab = () => { return { current_page: 1, total_pages: 1,
                                   num_items: 0, total_hits: 0,
                                   items: []}; };
    this.state = { tabs: _.times(2, initTab) };
    this.state = this.buildStateFromProps(props);
  }

  buildStateFromProps(props) {
    return {
      items: props.results,
      per_page: props.pagination.per_page,
      order: props.pagination.order,
      filterbar: props.filterbar,
      activeTab: props.tab,
      tabs: this.updateTabs(props)
    };
  }

  updateTabs(props) {
    this.state.tabs[props.tab] = {
      current_page: props.pagination.current_page,
      total_pages: props.pagination.total_pages,
      num_items: props.pagination.num_items,
      total_hits: props.pagination.total_hits,
      items: props.results,
    };
    return this.state.tabs;
  }

  createQuery(newState) {
    const tab = newState.activeTab;
    const current_page =  newState.current_page || newState.tabs[tab].current_page
    return {
      format: 'json',
      per_page: newState.per_page,
      order: newState.order,
      page: current_page,
      tab: tab,
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

  handleTabChange(idxTab) {
    if (idxTab != (this.state.activeTab + 1)) {
      const newState = Object.assign({}, this.state, { activeTab: idxTab - 1, current_page: 1 });
      this.fetch(newState);
    }
  }

  renderTab(title, idx) {
    const tabData = this.state.tabs[idx];
    return  (
      <Tabs.Panel title={title}>
        <SearchResultsHeader
          onChangePerPage={this.handleChangePerPage.bind(this)}
          onChangeOrder={this.handleChangeOrder.bind(this)}
          current_page={tabData.current_page}
          per_page={this.state.per_page}
          num_items={tabData.items.length}
          total_hits={tabData.total_hits}
          per_page={this.state.per_page}
          order={this.state.order} />
        <EnhanceInstructionCards items={tabData.items} />
        <PaginationBoxView previousLabel={<i className="fa-2x ub-angle-left"></i>}
                        nextLabel={<i className="fa-2x ub-angle-right"></i>}
                        breakLabel={<li className="o-pagination__break">...</li>}
                        pageNum={tabData.total_pages}
                        initialSelected={tabData.current_page - 1}
                        forceSelected={tabData.current_page - 1}
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
      </Tabs.Panel>);
  }

  render() {
    const tabGuides = this.renderTab('Content Guides', 0);
    const tabResources = this.renderTab('Resources', 1);
    return (
      <div>
        <div className="u-bg--base">
          <div className="o-page">
            <div className="o-page__module">
              <div className="o-filterbar-title">
                <h2>Enhance Instruction</h2>
                <div className="o-filterbar-title__subheader">
                  Search our free professional learning resources for teaching guides, videos and podcasts that focus on the application of content related to the standards in the classroom. Download, adapt, share.
                </div>
              </div>
              <Filterbar
                onUpdate={this.handleFilterbarUpdate.bind(this)}
                withSearch={false}
                {...this.state.filterbar} />
            </div>
          </div>
        </div>
        <div className="o-page u-margin-bottom--xlarge">
          <Tabs tabActive={this.state.activeTab + 1} onBeforeChange={this.handleTabChange.bind(this)} className='c-eh-tab o-page__module'>
             {tabGuides}
             {tabResources}
          </Tabs>
       </div>
     </div>
    );
  }
}
