class Filterbar extends React.Component {
  constructor(props) {
    super(props);

    this.emptyState = {
      subjects: [
        { displayName: 'ELA', name: 'ela', selected: false },
        { displayName: 'MATH', name: 'math', selected: false },
        { displayName: 'LEAD', name: 'lead', selected: false }
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
        { displayName: 'Curriculum', name: 'grade', selected: false },
        { displayName: 'Modules', name: 'module', selected: false },
        { displayName: 'Units', name: 'unit', selected: false },
        { displayName: 'Lessons', name: 'lesson', selected: false },
        { displayName: 'Content Guides', name: 'content_guide', selected: false },
        { displayName: 'Videos', name: 'video', selected: false },
        { displayName: 'Podcasts', name: 'podcast', selected: false },
      ],
      search_term: null
    };

    this.FACET_GROUP_IDX = 4;
    if (!this.props.withLead) {
      this.emptyState.subjects = _.dropRight(this.emptyState.subjects);
    }

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
    this.searchBus.emit('clearSearch');
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

  update(state) {
    const filterbar = this.createQuery(state);
    this.props.onUpdate( filterbar );
    this.updateUrl( filterbar );
  }

  onClickRefine(value) {
    if ('onRefine' in this.props) {
      this.update(this.state);
      this.props.onRefine();
    }
  }

  componentWillUpdate(nextProps, nextState) {
    if (('onUpdate' in this.props) && !('onRefine' in this.props)) {
      if ($.param(this.state) !== $.param(nextState)) {
        this.update(nextState);
      }
    }
  }

  updateUrl(query) {
    urlHistory.update( query, { skipKey: (key, val) => {
      return this.props.withDropdown && key === 'search_term'
    }});
  }

  render() {
    const state = this.state;

    const gradeName = _.find(state.subjects, s => s.name === 'math' && s.selected) ?
      'mathDisplayName' :
      'displayName';

    const subjectSelected =  _.find(state.subjects, 'selected');
    const subjectName = subjectSelected ? subjectSelected.name : 'default';
    const gradeSelected = _.find(state.grades, 'selected');
    const facetSelected = _.find(state.facets, 'selected');
    let facetGroups = [ { data: _.take(state.facets, this.FACET_GROUP_IDX), selected: facetSelected },
                        { data: _.slice(state.facets, this.FACET_GROUP_IDX), selected: facetSelected } ];

    const conciseState = this.createQuery(this.state);

    let filterbarSearch = null;

    if (this.props.withSearch) {
      filterbarSearch = (
        <div className="o-filterbar-search" ref={r => this.searchContainer = r}>
          <FilterbarSearch
            searchLabel={this.props.searchLabel}
            searchTerm={this.state.search_term}
            searchBus={this.searchBus}
            onUpdate={this.onUpdateSearch.bind(this)}/>
          {(this.props.withDropdown) ?
            <SearchDropdown
              searchContainer={() => this.searchContainer}
              searchBus={this.searchBus}
              filterbar={conciseState} /> : <div className="hide"></div>}
        </div>
      );
    }

    let filterbarFacets = null;
    if (this.props.withFacets) {
      filterbarFacets = (
        <div className='o-filterbar'>
          { facetGroups.map( (group, idx) => {
              return (
                <div key={idx} className='o-filterbar__list'>
                  { group.data.map(facet => {
                      return <FilterbarFacet
                        key={facet.name}
                        onClick={this.onClickFacet.bind(this, facet)}
                        displayName={facet.displayName}
                        selected={facet.selected || !group.selected } />;
                    }) }
                </div>);
            })
         }
       </div>);
    }

    const mobileTitle = this.props.withSearch ? 'Filter and Search' : 'Filter';

    return (
      <div>
        <div className='o-filterbar'>
          <div className='o-filterbar__title hide-for-ipad u-margin-bottom--large'>{mobileTitle}</div>
          <div className='o-filterbar__list o-filterbar__list--subjects'>
            {state.subjects.map(subject => {
              return (
                <FilterbarSubject
                  key={subject.name}
                  colorCode={colorCodeCss(subject.name)}
                  cssModifier={state.subjects.length}
                  onClick={this.onClickSubject.bind(this, subject)}
                  displayName={subject.displayName}
                  selected={subject.selected || !subjectSelected} />
              );
            })}
          </div>
          <div className='o-filterbar__list o-filterbar__list--grades'>
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
            <div className='o-filterbar__item o-filterbar__item--clear o-filterbar__item--square hide-for-ipad' onClick={this.onClickClear.bind(this)}>
              <span><i className="ub-close fa-2x"></i></span>
            </div>
          </div>
          <div className='o-filterbar__list show-for-ipad'>
             <div className='o-filterbar__item o-filterbar__item--clear o-filterbar__item--square' onClick={this.onClickClear.bind(this)}>
               <span><i className="ub-close fa-2x"></i></span>
             </div>
          </div>
        </div>
        {filterbarFacets}
        {filterbarSearch}
        <div className='o-filterbar-refine hide-for-ipad u-margin-top--large'>
          <a className='o-btn o-btn--yellow' onClick={this.onClickRefine.bind(this)}>Refine Results</a>
        </div>
      </div>
    );
  }
};
