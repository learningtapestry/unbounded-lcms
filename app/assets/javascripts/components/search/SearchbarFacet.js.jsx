function SearchbarFacet(props) {
  const className = props.selected ?
    'o-searchbar__facets-list__facet o-searchbar__facets-list__facet--selected' :
    'o-searchbar__facets-list__facet';

  return (
    <div className={className} onClick={props.onClick}>{props.displayName}</div>
  );
}
