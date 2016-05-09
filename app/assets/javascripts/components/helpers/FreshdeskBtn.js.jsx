let initializeFreshdesk = (function() {
  FreshWidget.init("", {
    "queryString": "&widgetType=popup&formTitle=Get+in+touch&submitThanks=Thank+you+for+your+feedback",
    "utf8": "✓",
    "widgetType": "popup",
    "buttonType": "text",
    "buttonText": "Contact Us",
    "buttonColor": "white",
    "buttonBg": "#009f93",
    "backgroundImage": "",
    "alignment": "4",
    "offset": "-1500px",
    "formHeight": "500px",
    "submitThanks": "Thank you for your feedback",
    "url": "https://unbounded.freshdesk.com"
  });
})();

function FreshdeskBtn(props) {
  const onClick = (evt)=> {
    FreshWidget.show();
    return false;
  };

  return <a href="#" className={props.cls} onClick={onClick} >{props.text}</a>
}
