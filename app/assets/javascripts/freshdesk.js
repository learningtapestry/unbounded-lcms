window.initializeFreshDesk = function() {
  FreshWidget.init("", {
    "queryString": "&widgetType=popup&formTitle=Get+in+touch&submitThanks=Thank+you+for+your+feedback",
    "utf8": "✓",
    "widgetType": "popup",
    "buttonType": "text",
    "buttonText": "Contact Us",
    "buttonColor": "white",
    "buttonBg": "#009f93",
    "alignment": "4",
    "offset": "235px",
    "submitThanks": "Thank you for your feedback",
    "formHeight": "500px",
    "url": "https://unbounded.freshdesk.com"
  });
};
