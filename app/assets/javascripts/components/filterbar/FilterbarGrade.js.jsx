function FilterbarGrade(props, context) {
  const className = props.selected ?
    'o-filterbar__grades-list__grade o-filterbar__grades-list__grade--selected' :
    'o-filterbar__grades-list__grade';

  return (
    <div className={className} onClick={props.onClick}>
      {props.displayName}
    </div>
  );
}
