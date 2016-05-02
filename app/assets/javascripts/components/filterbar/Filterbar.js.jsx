class Filterbar extends React.Component {
  constructor(props) {
    super(props);

    this.emptyState = {
      subjects: [
        { displayName: 'ELA', name: 'ela', selected: false },
        { displayName: 'MATH', name: 'math', selected: false }
      ],
      grades: [
        { displayName: 'PK', mathDisplayName: 'PK', name: 'pk', selected: false },
        { displayName: 'K', mathDisplayName: 'K', name: 'k', selected: false },
        { displayName: '1', mathDisplayName: '1', name: '1', selected: false },
        { displayName: '2', mathDisplayName: '2', name: '2', selected: false },
        { displayName: '3', mathDisplayName: '3', name: '3', selected: false },
        { displayName: '4', mathDisplayName: '4', name: '4', selected: false },
        { displayName: '5', mathDisplayName: '5', name: '5', selected: false },
        { displayName: '6', mathDisplayName: '6', name: '6', selected: false },
        { displayName: '7', mathDisplayName: '7', name: '7', selected: false },
        { displayName: '8', mathDisplayName: '8', name: '8', selected: false },
        { displayName: '9', mathDisplayName: 'A1', name: '9', selected: false },
        { displayName: '10', mathDisplayName: 'GE', name: '10', selected: false },
        { displayName: '11', mathDisplayName: 'A2', name: '11', selected: false },
        { displayName: '12', mathDisplayName: 'PC', name: '12', selected: false }
      ],
      facets: [
        { displayName: 'Curriculum', name: 'curriculum', selected: false },
        { displayName: 'Modules', name: 'module', selected: false },
        { displayName: 'Units', name: 'unit', selected: false },
        { displayName: 'Lessons', name: 'lesson', selected: false },
        { displayName: 'Content Guides', name: 'content_guide', selected: false },
        { displayName: 'Videos', name: 'video', selected: false },
        { displayName: 'Resources', name: 'resource', selected: false },
      ],
      search_term: null
    };

    let initialState = _.cloneDeep(this.emptyState);
    initialState.search_term = this.props.search_term;

    this.initSelectedFilters(initialState, 'subjects');
    this.initSelectedFilters(initialState, 'grades');
    this.initSelectedFilters(initialState, 'facets');

    this.state = initialState;
    this.searchBus = new EventEmitter();
  }

  initSelectedFilters(initialState, prop) {
    if (prop in this.props) {
      _.chain(initialState[prop])
       .filter(s => _.includes(this.props[prop], s.name))
       .forEach(s => { s.selected = true; })
       .value();
    }
  }

  getSelected(state, prop) {
    return _.chain(state[prop])
            .filter((obj) => obj.selected)
            .map(obj => obj.name)
            .value();
  }

  createQuery(state) {
    const query = {
      subjects: this.getSelected(state, 'subjects'),
      grades: this.getSelected(state, 'grades'),
      facets: this.getSelected(state, 'facets'),
      search_term: state.search_term
    };
    return query;
  }

  onClickClear() {
    this.setState(this.emptyState);
  }

  onClickGrade(incoming) {
    this.setState({
      ...this.state,
      grades: this.state.grades.map(grade => {
        if (incoming.name !== grade.name) return grade;
        return _.merge({}, grade, { selected: !grade.selected })
      })
    });
  }

  onClickSubject(incoming) {
    this.setState({
      ...this.state,
      subjects: this.state.subjects.map(subject => {
        // Only a single subject may be selected at any given time.
        if (incoming.name !== subject.name) {
          if (!incoming.selected && subject.selected) {
            return _.merge({}, subject, { selected: false });
          } else {
            return subject;
          }
        }
        return _.merge({}, subject, { selected: !subject.selected })
      })
    });
  }

  onClickFacet(incoming) {
    this.setState({
      ...this.state,
      facets: this.state.facets.map(facet => {
        if (incoming.name !== facet.name) return facet;
        return _.merge({}, facet, { selected: !facet.selected })
      })
    });
  }

  onUpdateSearch(value) {
    this.setState({
      ...this.state,
      search_term: value
    });
  }

  componentWillUpdate(nextProps, nextState) {
    if ('onUpdate' in this.props) {
      if ($.param(this.state) !== $.param(nextState)) {
        const filterbar = this.createQuery(nextState);
        this.props.onUpdate( filterbar );
        this.updateUrl( filterbar );
      }
    }
  }

  updateUrl(newState) {
    let query = [];
    _.forEach(newState, (val, k) => {
      if (this.props.withDropdown && k === 'search_term') {
        return;
      }

      if (val) {
        let urlVal = val;
        if (_.isArray(val)) {
          if (val.length) {
            query.push(k+'='+val.join(','));
          }
        } else {
          query.push(k+'='+val);
        }
      }
    });
    query = query.join('&');
    query = query ? '?' + query : window.location.pathname;

    // Make pushState play nice with Turbolinks.
    // Ref https://github.com/turbolinks/turbolinks-classic/issues/363
    const historyState = { turbolinks: true, url: query };
    window.history.pushState(historyState, null, query);
  }

  render() {
    const state = this.state;

    const gradeName = _.find(state.subjects, s => s.name === 'math' && s.selected) ?
      'mathDisplayName' :
      'displayName';

    const subjectSelected =  _.find(state.subjects, 'selected');
    const subjectName = subjectSelected ? subjectSelected.name : 'default';
    const gradeSelected = _.find(state.grades, 'selected');

    const conciseState = this.createQuery(this.state);

    let filterbarSearch = null;

    if (this.props.withSearch) {
      filterbarSearch = (
        <div className="o-filterbar__search" ref={r => this.searchContainer = r}>
          <FilterbarSearch
            searchTerm={this.state.search_term}
            searchBus={this.searchBus}
            onUpdate={this.onUpdateSearch.bind(this)}/>
          {(this.props.withDropdown) ?
            <SearchDropdown
              searchContainer={() => this.searchContainer}
              searchBus={this.searchBus}
              filterbar={conciseState} /> : null}
        </div>
      );
    }

    return (
      <div>
        <div className='o-filterbar'>
          <div className='o-filterbar__list'>
            {state.subjects.map(subject => {
              return (
                <FilterbarSubject
                  key={subject.name}
                  colorCode={colorCodeCss(subject.name)}
                  onClick={this.onClickSubject.bind(this, subject)}
                  displayName={subject.displayName}
                  selected={subject.selected || !subjectSelected} />
              );
            })}
          </div>
          <div className='o-filterbar__list'>
            {state.grades.map(grade => {
              return (
                <FilterbarGrade
                  key={grade.name}
                  colorCode={colorCodeCss(subjectName, grade.name)}
                  onClick={this.onClickGrade.bind(this, grade)}
                  displayName={grade[gradeName]}
                  selected={grade.selected || !gradeSelected} />
              );
            })}
          </div>
          <div className='o-filterbar__list hide-for-small-only'>
             <div className='o-filterbar__item--clear o-filterbar__item--square' onClick={this.onClickClear.bind(this)}>
               <i className="ub-close fa-2x"></i>
             </div>
          </div>
        </div>
        <div className='o-filterbar'>
          {
            (this.props.withFacets) ?
              <div className='o-filterbar__facets-list'>
                {state.facets.map(facet => {
                  return (
                    <FilterbarFacet
                      key={facet.name}
                      onClick={this.onClickFacet.bind(this, facet)}
                      displayName={facet.displayName}
                      selected={facet.selected} />
                  );
                })}
              </div>

              : false
          }
          {filterbarSearch}
        </div>
      </div>
    );
  }
};
