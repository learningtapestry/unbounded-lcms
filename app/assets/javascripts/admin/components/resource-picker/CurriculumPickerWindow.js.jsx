class CurriculumPickerWindow extends React.Component {

  constructor(props) {
    super(props);

    this.typeOptions = [
      ['grade', 'grade'],
      ['module', 'module'],
      ['unit', 'unit']
    ];

    this.subjectOptions = [
      ['ela', 'ELA'],
      ['math', 'Math']
    ];

    this.gradeOptions = [
      ['pk', 'prekindergarten'],
      ['k', 'kindergarten'],
      ['1', 'grade 1'],
      ['2', 'grade 2'],
      ['3', 'grade 3'],
      ['4', 'grade 4'],
      ['5', 'grade 5'],
      ['6', 'grade 6'],
      ['7', 'grade 7'],
      ['8', 'grade 8'],
      ['9', 'grade 9'],
      ['10', 'grade 10'],
      ['11', 'grade 11'],
      ['12', 'grade 12']
    ];

    const initialState = {
      pagination: {
        current_page: 1,
        total_pages: 0
      },
      results: [],
      type: 'grade',
      subject: null,
      grade: null,
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
      type: state.type,
      subject: state.subject,
      grade: state.grade,
      q: state.q
    };
  }

  fetch(state = this.state) {
    const query = this.createQuery(state);
    const url = Routes.admin_curriculum_picker_path(query);
    return fetch(url, {credentials: 'same-origin'}).then(r => r.json());
  }

  fetchAndUpdate(state = this.state) {
    this.fetch().then(s => this.setState(this.buildStateFromProps(s)));
  }

  selectResource(resource) {
    if ('onSelectResource' in this.props) {
      this.props.onSelectResource(resource);
    }
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
    const updateType = this.handleUpdateField.bind(this, 'type');
    const updateSubject = this.handleUpdateField.bind(this, 'subject');
    const updateGrade = this.handleUpdateField.bind(this, 'grade');
    const updateQ = this.handleUpdateField.bind(this, 'q');

    return (
      <div className="o-assocpicker">
        <div className="o-page">
          <div className="o-page__module">
            <h4 className="text-center">Select resource</h4>
            <div className="row">
              <label className="medium-3 columns">Curriculum Type
                <select value={this.state.type} onChange={updateType}>
                  {this.typeOptions.map(([value, title]) => (
                    <option key={value} value={value}>{title}</option>
                  ))}
                </select>
              </label>

              <label className="medium-3 columns">Subject
                <select value={this.state.subject} onChange={updateSubject}>
                  <option />
                  {this.subjectOptions.map(([value, title]) => (
                    <option key={value} value={value}>{title}</option>
                  ))}
                </select>
              </label>

              <label className="medium-3 columns">Grade
                <select value={this.state.grade} onChange={updateGrade}>
                  <option />
                  {this.gradeOptions.map(([value, title]) => (
                    <option key={value} value={value}>{title}</option>
                  ))}
                </select>
              </label>

              <label className="medium-3 columns">Title
                <input type="text" value={this.state.q} onChange={this.handleUpdateQ.bind(this)} />
              </label>
            </div>
          </div>
        </div>

        <div className="o-page">
          <div className="o-page__module">
            <table className="c-admcur-results">
              <thead>
                <tr>
                  <th>Title</th>
                </tr>
              </thead>
              <tbody>
                {this.state.results.map(resource => (
                  <tr key={resource.id}>
                    <td onClick={this.selectResource.bind(this, resource)}>{resource.title}</td>
                  </tr>
                ))}
              </tbody>
            </table>
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
          </div>
        </div>
      </div>
    );
  }
}
