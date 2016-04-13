class ExploreCurriculumPage extends React.Component {
  constructor(props) {
    super(props);

    this.state = this.buildStateFromProps(props);
    this.ANIMATION_DURATION = 400;
  }

  updateUrl($active) {
    if (!$active && !/p=/.test(location.search)) {
      return;
    }

    let query = [];

    const queryStringArr = window.location.search.slice(1).split('&');
    query = _.filter(queryStringArr, function(piece) {
      return !(piece.startsWith('e=') || piece.startsWith('p='));
    });

    if ($active) {
      query.push('p=' + $active[0].getAttribute('name'));

      if (this.state.active[this.state.active.length-2] == $active[0].id) {
        query.push('e=1');
      }
    }

    if (window.history) {
      const prefix = window.location.pathname;
      const queryString = query.length ? '?' + query.join('&') : '';
      let newUrl = prefix + queryString;
      if (newUrl[newUrl.length-1] == '?') {
        newUrl = newUrl.slice(0, -1);
      }
      const historyState = { turbolinks: true, url: newUrl };
      window.history.replaceState(historyState, null, newUrl);
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
    let elm;
    if (this.scrollImmediately === 'item') {
      elm = document.getElementById(this.state.active[this.state.active.length-1]);
      if (!elm) {
        elm = document.getElementById(this.state.active[this.state.active.length-2]);
      }
      this.scrollToActive(elm);
    } else if (this.scrollImmediately === 'expanded') {
      elm = document.getElementById(this.state.active[this.state.active.length-2]);
      this.scrollToActive(elm);
    }
  }

  componentWillUnmount() {
    if (this.refs.curriculumList) {
      $(this.refs.curriculumList).foundation('destroy');
    }
  }

  onScrollFinished(el) {
    _.delay(() => { const yOffset = $(el).offset().top;
                    if (Math.abs($(document).scrollTop() - yOffset) > 25) {
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
    let active;

    if (props.active) {
      active = props.active;

      if (props.expanded) {
        this.scrollImmediately = 'expanded';
      } else {
        this.scrollImmediately = 'item';
      }
    } else {
      active = [props.results[0].id];
    }

    return {
      curriculums: props.results,
      curriculumsIndex: this.buildIndex(props.results),
      filterbar: props.filterbar,
      active: active
    };
  }

  buildIndex(curriculums, zip = {}) {
    _.forEach(curriculums, curriculum => {
      zip[curriculum.id] = curriculum;

      if (curriculum.children.length) {
        this.buildIndex(curriculum.children, zip);
      }
    });

    return zip;
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
    const hasCached = cur &&
      (cur.requested ||
        (cur.children.length &&
          this.state.curriculumsIndex[cur.children[0].id]));

    if (hasCached) {
      this.setActive(parentage, cur, currentTarget);
    } else {
      this.fetchOne(id).then(response => {
        response.requested = true;
        const newIndex = { ...this.state.curriculumsIndex };
        this.buildIndex([response], newIndex);
        this.setState({
          ...this.state,
          curriculumsIndex: newIndex,
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
                <h2>Explore curriculum, then download or share anything yout want &mdash; it's free!</h2>
                <div className="o-filterbar-title__subheader">
                  Filter by subject or grade, or search to reveal curriculum resources.
                </div>
              </div>
              <Filterbar
                onUpdate={this.handleFilterbarUpdate.bind(this)}
                {...this.state.filterbar} />
            </div>
          </div>
        </div>
        <div className="o-page u-margin-bottom--xlarge">
          <div className="o-page__module" ref="curriculumList">
            <ExploreCurriculumHeader totalItems={this.state.curriculums.length} />
            {curriculums}
          </div>
        </div>
      </div>
    );
  }
}
