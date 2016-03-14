const ANIMATION_DURATION = 800;

class ExploreCurriculumPage extends React.Component {
  constructor(props) {
    super(props);

    this.state = this.buildStateFromProps(props);
  }

  getYOffset(activeId) {
    let yOffset = $('#' + activeId).offset().top;
    yOffset -= ($(window).scrollTop() < yOffset) ? 0 : 20;
    return yOffset;
  }

  scrollToActive(activeOffset=2) {
    const activeId = this.state.active[Math.max(0, this.state.active.length - activeOffset)];
    const yOffset = this.getYOffset(activeId);
    $('html, body').stop(true)
                   .animate({ scrollTop: yOffset },
                            ANIMATION_DURATION, 'linear',
                            () => {window.location.hash = activeId;});
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
      ...state.filterbar
    };
  }

  fetch(state) {
    const query = this.createQuery(state);
    const url = Routes.explore_curriculum_index_path(query);
    return fetch(url).then(r => r.json());
  }

  fetchOne(id) {
    const query = { format: 'json', id: id };
    const url = Routes.explore_curriculum_path(id);
    return fetch(url).then(r => r.json());
  }

  getActive(parentage, cur) {
    return cur.children.length > 0 ?
        [...parentage, cur.children[0].id] :
        [...parentage];
  }

  setActive(parentage, cur) {
    this.setState({
      ...this.state,
      active: this.getActive(parentage, cur)
    }, this.scrollToActive);
  }

  handleClickExpand(parentage) {
    if (parentage[parentage.length-1] === this.state.active[parentage.length-1]) {
      this.setState({
        ...this.state,
        active: parentage
      }, this.scrollToActive.bind(this, 1));
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
          },
          active: this.getActive(parentage, response)
        }, this.scrollToActive);
      });
    }
  }

  handleFilterbarUpdate(filterbar) {
    const newState = Object.assign({}, this.state, { filterbar: filterbar });
    this.fetch(newState)
        .then(response => { this.setState(this.buildStateFromProps(response)); });
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
