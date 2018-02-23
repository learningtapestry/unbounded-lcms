//= require ./searchPageWrapper.js

class SearchPage extends React.Component {
  render() {
    const searchResults = (this.props.data.length === 0) ?
      <SearchResultsEmpty searchTerm={this.props.filterbar.search_term} /> :

      <SearchResults
        resources={this.props.data}
        current_page={this.props.current_page}
        per_page={this.props.per_page}
        total_hits={this.props.total_hits} />;

    return (
      <div>
        <div className="u-bg--base-gradient">
          <div className="o-page">
            <div className="o-page__module">
              <div className="o-filterbar-title">
                <h2>Search results</h2>
                <div className="o-filterbar-title__subheader">
                  Filter by subject or grade, or search to reveal assets.
                </div>
              </div>
              <FilterbarResponsive
                onUpdate={this.props.handleFilterBar}
                searchLabel='Search the site'
                withFacets={true}
                withSearch={true}
                {...this.props.filterbar} />
            </div>
          </div>
        </div>
        <div className="o-page o-page--margin-bottom">
          <div className="o-page__module">
            {searchResults}
            {this.props.pagination}
          </div>
        </div>
      </div>
    );
  }
}

// eslint-disable-next-line no-unused-vars,no-undef
const SearchPageComponent = searchPageWrapper(SearchPage);
