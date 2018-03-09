// eslint-disable-next-line no-unused-vars
function PickerButton(props) {
  return (
    <div className="o-assocpicker-container">
      <button
        type="button"
        className="o-assocpicker-add button"
        onClick={e => props.onClick(e)}>Select</button>
      <div className="o-assocpicker-selections">
        {props.hiddenInputs}
        {props.content}
      </div>
      <div
        className="o-assocpicker-modal reveal"
        ref={m => props.onRef(m)}>
      </div>
    </div>
  );
}
