function SearchDropdownResult(props) {
  const classes = classNames({
    'o-search-dropdown-result': true,
    'o-search-dropdown-result__selected': props.selected
  });

  return (
    <div className={classes}>
      <a href={props.resource.path}>{props.resource.title}</a>
    </div>
  );
}
