function AssociationPickerItem(props) {
  let input;

  if (props.item._create) {
    input = <input type="hidden" name={`${props.create_name}[]`} value={props.item.name} />;
  } else if (props.allow_multiple) {
    input = <input type="hidden" name={`${props.name}[]`} value={props.item.id} />;
  } else {
    input = <input type="hidden" name={props.name} value={props.item.id} />;
  }

  return (
    <div className="o-assocpicker-selection">
      {input}
      <div className="o-assocpicker-title">
        {props.item.name}
        <span className="o-assocpicker-close" onClick={props.onClickClose}>×</span>
      </div>
    </div>
  );
}
