class SearchResults extends React.Component {
  render() {
    return (
      <div className='o-search-results'>
        <SearchResultsHeader
          current_page={this.props.current_page}
          per_page={this.props.per_page}
          num_items={this.props.resources.length}
          total_hits={this.props.total_hits} />

        <ul className='o-search-results__list'>
          {this.props.resources.map((resource) => {
            return <SearchResult key={resource.id} resource={resource} />
          })}
        </ul>
      </div>
    );
  }
}
