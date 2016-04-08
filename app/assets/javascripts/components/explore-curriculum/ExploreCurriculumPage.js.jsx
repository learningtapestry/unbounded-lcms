class ExploreCurriculumPage extends React.Component {
  constructor(props) {
    super(props);

    this.state = this.buildStateFromProps(props);
    this.ANIMATION_DURATION = 400;
    this.EXPANDED_POSTFIX = '--expanded';
  }

  isExpanded(id) {
    const activeLength = this.state.active.length;
    return activeLength > 1 && _.lastIndexOf(this.state.active, id, activeLength - 2) != -1;
  }

  updateUrl($active) {
    let hash = $active ? $active[0].getAttribute('name') : null;
    if ($active && this.isExpanded(parseInt($active[0].id))) {
      hash += this.EXPANDED_POSTFIX;
    }
    if (window.history) {
      const newUrl = window.history.state.url.replace(/#.+/, '') + (hash ? `#${hash}` : '');
      const historyState = { turbolinks: true, url: newUrl };
      window.history.replaceState(historyState, null, newUrl);
    } else{
      window.location.hash = hash;
    }
  }

  componentDidMount() {
    new Foundation.MaggelanHash($(this.refs.curriculumList),
                                { deepLinking: true,
                                  updateUrl: this.updateUrl.bind(this),
                                  threshold: 20,
                                  animationDuration: this.ANIMATION_DURATION,
                                  onScrollFinished: this.onScrollFinished.bind(this)
                                });
    const activePath = _.trim(window.location.hash, this.EXPANDED_POSTFIX);
    const activeId = window.location.hash ? `[name="${activePath.slice(1)}"]` : null;
    this.scrollToActive(activeId);
  }

  componentWillUnmount() {
    if (this.refs.curriculumList) {
      $(this.refs.curriculumList).foundation('destroy');
    }
  }

  onScrollFinished(el) {
    _.delay(() => { const yOffset = $(el).offset().top;
                    if (Math.abs($(document).scrollTop() - yOffset) > 50) {
                      $('html, body').scrollTop(yOffset);
                    }
                    $(this.refs.curriculumList).foundation('mutexScrollUnlock');
                    $(this.refs.curriculumList).foundation('reflow');
                  }, this.ANIMATION_DURATION / 4);
  }

  scrollToActive(el) {
    if (el && $(el).length) {
      $(this.refs.curriculumList).foundation('mutexScrollLock');
      $(this.refs.curriculumList).foundation('scrollToLoc', el);
    }
    else {
      this.updateUrl(null);
    }
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

  setActive(parentage, cur, el) {
    this.setState({
      ...this.state,
      active: this.getActive(parentage, cur)
    }, this.scrollToActive.bind(this, el));
  }

  handleClickExpand(parentage, e) {
    if (e.target.nodeName === "A") return;
    e.preventDefault();
    const currentTarget = `#${e.currentTarget.id}`;
    if (parentage[parentage.length-1] === this.state.active[parentage.length-1]) {
      this.setState({
        ...this.state,
        active: parentage
      }, this.scrollToActive.bind(this, currentTarget));
    } else {
      this.handleClickViewDetails(parentage, e);
    }
  }

  handleClickViewDetails(parentage, e) {
    if (e.target.nodeName === "A") return;
    e.preventDefault();
    const currentTarget = `#${e.currentTarget.id}`;
    const id = _.last(parentage);
    const cur = this.state.curriculumsIndex[id];

    if (cur && cur.requested) {
      this.setActive(parentage, cur, currentTarget);
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
        }, this.scrollToActive.bind(this, currentTarget));
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
      <div>
        <div className="u-bg--base">
          <div className="o-page">
            <div className="o-page__module">
              <div className="o-filterbar-title">
                <h2>Enhance Instruction with comprehensive content guides and educator videos.</h2>
                <div className="o-filterbar-title__subheader">
                  Filter by subject or grade, or search to reveal assets.
                </div>
              </div>
              <Filterbar
                onUpdate={this.handleFilterbarUpdate.bind(this)}
                {...this.state.filterbar} />
            </div>
          </div>
        </div>
        <div className="o-page">
          <div className="o-page__module" ref="curriculumList">
            <ExploreCurriculumHeader totalItems={this.state.curriculums.length} />
            {curriculums}
          </div>
        </div>
      </div>
    );
  }
}
