class Filterbar extends React.Component {
  constructor(props) {
    super(props);

    let initialState = {
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
    };

    if ('subjects' in this.props) {
      _
      .chain(initialState.subjects)
      .filter(s => _.includes(this.props.subjects, s.name))
      .forEach(s => {
        s.selected = true;
      })
      .value();
    }

    if ('grades' in this.props) {
      _
      .chain(initialState.grades)
      .filter(g => _.includes(this.props.grades, g.name))
      .forEach(g => {
        g.selected = true;
      })
      .value();
    }

    if ('facets' in this.props) {
      _
      .chain(initialState.facets)
      .filter(s => _.includes(this.props.facets, s.name))
      .forEach(s => {
        s.selected = true;
      })
      .value();
    }

    this.state = this.withQuery(initialState);
  }

  withQuery(state) {
    state.query = this.createQuery(state);
    return state;
  }

  createQuery(state) {
    let query = {
      subjects: _.chain(state.subjects)
        .filter((subject) => subject.selected)
        .map(subject => subject.name)
        .value(),
      grades: _.chain(state.grades)
        .filter((grade) => grade.selected)
        .map(grade => grade.name)
        .value(),
      facets: _.chain(state.facets)
        .filter((facet) => facet.selected)
        .map(facet => facet.name)
        .value(),
    };
    return query;
  }

  onClickGrade(incoming) {
    this.setState(this.withQuery({
      ...this.state,
      grades: this.state.grades.map(grade => {
        if (incoming.name !== grade.name) return grade;
        return _.merge({}, grade, { selected: !grade.selected })
      })
    }));
  }

  onClickSubject(incoming) {
    this.setState(this.withQuery({
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
    }));
  }

  onClickFacet(incoming) {
    this.setState(this.withQuery({
      ...this.state,
      facets: this.state.facets.map(facet => {
        if (incoming.name !== facet.name) return facet;
        return _.merge({}, facet, { selected: !facet.selected })
      })
    }));
  }

  componentWillUpdate(nextProps, nextState) {
    if ('onUpdate' in this.props) {
      if ($.param(this.state.query) !== $.param(nextState.query)) {
        this.props.onUpdate( nextState );
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
          {(() => {
              if(this.props.withFacets) {
                return (
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
                );
              } else { return false; }
          })()}
        </div>
      </div>
    );
  }
};
