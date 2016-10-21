class AssociationPickerWindow extends React.Component {

  constructor(props) {
    super(props);

    const initialState = {
      pagination: {
        current_page: 1,
        total_pages: 0
      },
      items: [],
      selectedItems: [],
      q: null
    };

    this.state = { ...initialState, ...this.buildStateFromProps(props) };
  }

  buildStateFromProps(props) {
    return { ...props };
  }

  componentDidMount() {
    this.debouncedFetchAndUpdate = _.debounce(this.fetchAndUpdate, 300);
    this.fetchAndUpdate();
  }

  createQuery(state = this.state) {
    return {
      format: 'json',
      page: state.pagination.current_page,
      q: state.q,
      association: this.props.association
    };
  }

  fetch(state = this.state) {
    const query = this.createQuery(state);
    const url = Routes.admin_association_picker_path(query);
    return fetch(url, {credentials: 'same-origin'}).then(r => r.json());
  }

  fetchAndUpdate(state = this.state) {
    this.fetch().then(s => {
      s.items = s.results;
      this.setState(this.buildStateFromProps(s))
    });
  }

  selectItem(item) {
    const operation = this.updateSelectedItems(item);
    if ('onSelectItem' in this.props) {
      this.props.onSelectItem(item, operation);
    }
  }

  updateSelectedItems(item) {
    let operation, newItems;
    if (item._selected) {
      newItems = _.filter(this.state.selectedItems, r => r.id !== item.id);
      operation = 'removed';
    } else {
      newItems = [...this.state.selectedItems, item];
      operation = 'added';
    }
    this.setState(...this.state, {selectedItems: newItems});
    return operation;
  }

  handleUpdateQ(event) {
    var value = event.target.value;
    this.setState({ ...this.state, q: value}, this.debouncedFetchAndUpdate);
  }

  handleUpdateField(field, event) {
    const val = event.target.value;
    this.setState({ ...this.state, [field]: val }, this.fetchAndUpdate);
  }

  handlePageClick(data) {
    const selected = data.selected;
    this.setState({
      ...this.state,
      pagination: {
        ...this.state.pagination,
        current_page: selected+1
      }
    }, this.fetchAndUpdate);
  }

  render() {
    const updatePage = this.handleUpdateField.bind(this, 'page');

    return (
      <div className="o-assocpicker">
        <div className="o-page">
          <div className="o-page__module">
            <h4 className="text-center">Select item</h4>
            <div className="row">
              <label className="medium-3 columns">Name
                <input type="text" value={this.state.q} onChange={this.handleUpdateQ.bind(this)} />
              </label>
            </div>
          </div>
        </div>

        <div className="o-page">
          <div className="o-page__module">
            <AssociationPickerResults
              value={this.state.q}
              items={this.state.items}
              selectedItems={this.state.selectedItems}
              allowCreate={this.props.allowCreate}
              onSelectItem={this.selectItem.bind(this)} />
            <PaginationBoxView previousLabel={"< Previous"}
                            nextLabel={"Next >"}
                            breakLabel={<li className="break"><a href="">...</a></li>}
                            pageNum={this.state.pagination.total_pages}
                            initialSelected={this.state.pagination.current_page - 1}
                            forceSelected={this.state.pagination.current_page - 1}
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

            { (this.props.allowMultiple) ?
              <button type="button"
                      className="button c-assocpicker-submit"
                      onClick={this.props.onClickDone}>Submit</button>
              : null
            }
          </div>
        </div>
      </div>
    );
  }
}
