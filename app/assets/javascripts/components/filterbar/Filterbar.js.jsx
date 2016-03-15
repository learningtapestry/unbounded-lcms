class Filterbar extends React.Component {
  constructor(props) {
    super(props);

    const initialState = {
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
        { displayName: 'CURRICULUM', name: 'curriculum', selected: false },
        { displayName: 'INSTRUCTION', name: 'instruction', selected: false }
      ],
      search_term: this.props.search_term
    };

    this.initSelectedFilters(initialState, 'subjects');
    this.initSelectedFilters(initialState, 'grades');
    this.initSelectedFilters(initialState, 'facets');

    this.state = initialState;
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
      subjects   : this.getSelected(state, 'subjects'),
      grades     : this.getSelected(state, 'grades'),
      facets     : this.getSelected(state, 'facets'),
      search_term: state.search_term
    };
    return query;
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
        this.props.onUpdate( this.createQuery(nextState) );
      }
    }
  }

  render() {
    const state = this.state;

    const gradeName = _.find(state.subjects, s => s.name === 'math' && s.selected) ?
      'mathDisplayName' :
      'displayName';

    return (
      <div>
        <div className='o-filterbar'>
          <div className='o-filterbar__subjects-list'>
            {state.subjects.map(subject => {
              return (
                <FilterbarSubject
                  key={subject.name}
                  onClick={this.onClickSubject.bind(this, subject)}
                  displayName={subject.displayName}
                  selected={subject.selected} />
              );
            })}
          </div>
          <div className='o-filterbar__grades-list'>
            {state.grades.map(grade => {
              return (
                <FilterbarGrade
                  key={grade.name}
                  onClick={this.onClickGrade.bind(this, grade)}
                  displayName={grade[gradeName]}
                  selected={grade.selected} />
              );
            })}
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
          {
            (this.props.withSearch) ?
              <FilterbarSearch
                searchTerm={this.state.search_term}
                onUpdate={this.onUpdateSearch.bind(this)}/>

              : false
          }
        </div>
      </div>
    );
  }
};
