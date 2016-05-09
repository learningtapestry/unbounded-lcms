function FreshdeskBtn(props) {
  const onClick = (evt)=> {
    FreshWidget.show();
    return false;
  };

  return <a href="#" className={props.cls} onClick={onClick} >{props.text}</a>
}
