function FilterbarSubject(props) {
  const className = props.selected ?
    'o-filterbar__subjects-list__subject o-filterbar__subjects-list__subject--selected' :
    'o-filterbar__subjects-list__subject';

  return (
    <div className={className} onClick={props.onClick}>{props.displayName}</div>
  );
}
