function SearchDropdownResults(props) {
  if (props.resources.length == 0) {
    const cls = 'o-search-dropdown-result';
    if (props.isSearching) {
      return <div className={cls}>Searching...</div>;
    } else if (props.search_term && props.search_term.length > 0) {
      return <div className={cls}>Nothing found.</div>;
    }
    return <div className={cls}>Enter terms to start searching.</div>;
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
