function FilterbarFacet(props) {
  const className = props.selected ?
    'o-filterbar__facets-list__facet o-filterbar__facets-list__facet--selected' :
    'o-filterbar__facets-list__facet';

  return (
    <div className={className} onClick={props.onClick}>{props.displayName}</div>
  );
}
