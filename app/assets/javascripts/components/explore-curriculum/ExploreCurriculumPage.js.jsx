class ExploreCurriculumPage extends React.Component {
  constructor(props) {
    super(props);

    this.state = this.buildStateFromProps(props);
  }

  buildStateFromProps(props) {
    return {
      curriculums: props.results,
      curriculumsIndex: this.buildIndex(props.results),
      filterbar: props.filterbar,
      active: [props.results[0].id]
    };
  }

  buildIndex(curriculums) {
    return _.zipObject(_.pluck(curriculums, 'id'), curriculums);
  }

  createQuery(state) {
    return {
      format: 'json',
      ...state.filterbar.query
    };
  }

  fetch() {
    const query = this.createQuery(this.state);
    const url = Routes.explore_curriculum_index_path(query);
    return fetch(url).then(r => r.json());
  }

  fetchOne(id) {
    const query = { format: 'json', id: id };
    const url = Routes.explore_curriculum_path(id);
    return fetch(url).then(r => r.json());
  }

  setActive(parentage, cur) {
    this.setState({
      ...this.state,
      active: cur.children.length > 0 ?
        [...parentage, cur.children[0].id] :
        [...parentage]
    });
  }

  handleClickExpand(parentage) {
    if (parentage[parentage.length-1] === this.state.active[parentage.length-1]) {
      this.setState({
        ...this.state,
        active: parentage
      });
    } else {
      this.handleClickViewDetails(parentage);
    }
  }

  handleClickViewDetails(parentage) {
    const id = _.last(parentage);
    const cur = this.state.curriculumsIndex[id];

    if (cur && cur.requested) {
      this.setActive(parentage, cur);
    } else {
      this.fetchOne(id).then(response => {
        response.requested = true;
        this.setState({
          ...this.state,
          curriculumsIndex: {
            ...this.state.curriculumsIndex,
            ...this.buildIndex(response.children),
            [response.id]: response
          }
        });
        this.setActive(parentage, response);
      });
    }
  }

  handleFilterbarUpdate(filterbar) {
    const newState = Object.assign({}, this.state, { filterbar: filterbar });
    this.setState(newState, () => {
      this.fetch().then(response => {
        this.setState(this.buildStateFromProps(response));
      });
    });
  }

  render() {
    const curriculums = this.state.curriculums.map(
      c => <ExploreCurriculumItem
        key={c.id}
        id={c.id}
        index={this.state.curriculumsIndex}
        onClickExpand={this.handleClickExpand.bind(this)}
        onClickViewDetails={this.handleClickViewDetails.bind(this)}
        parentage={[c.id]}
        active={this.state.active} />
    );

    return (
      <div className="o-page__wrap--nest">
        <Filterbar
          onUpdate={this.handleFilterbarUpdate.bind(this)}
          {...this.state.filterbar} />
        <ExploreCurriculumHeader totalItems={this.state.curriculums.length} />
        <div className="c-ec-cards">
          {curriculums}
        </div>
      </div>
    );
  }
}
