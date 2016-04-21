function SearchDropdownResults(props) {
  if (props.resources.length == 0) {
    if (props.isSearching) {
      return <div>Searching...</div>;
    } else if (props.search_term && props.search_term.length > 0) {
      return <div>Nothing found.</div>;
    }
    return <div>Enter terms to start searching.</div>;
  }

  const results = props.resources.map((resource, idx) => {
    key = `${resource.curriculum_id}_${resource.id}`;
    return <SearchDropdownResult
      key={key}
      resource={resource}
      selected={props.selected === idx} />;
  });

  return <div>{results}</div>;
}
