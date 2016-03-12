class SearchResults extends React.Component {
  render() {
    return (
      <div>
        <SearchResultsHeader
          current_page={this.props.current_page}
          per_page={this.props.per_page}
          num_items={this.props.resources.length}
          total_hits={this.props.total_hits} />

        <ul>
          {this.props.resources.map((resource) => {
            return <li key={resource.id}>{resource.title}</li>
          })}
        </ul>
      </div>
    );
  }
}
