function pickResource(callback) {
  var container = $('#resource-picker');

  if (container.length === 0) {
    container = $('<div id="resource-picker" class="large reveal" />');
    new Foundation.Reveal(container);
  }

  var props = {
    onSelectResource: function(resource) {
      callback(resource);
      ReactDOM.unmountComponentAtNode(container[0]);
      container.foundation('close');
    }
  };

  var resourcePicker = React.createElement(ResourcePicker, props, null);

  ReactDOM.render(resourcePicker, container[0]);

  var fixTop = function() {
    $(this).css({top: '15px'});
  };

  container.on('open.zf.reveal', fixTop);
  container.foundation('open');
}
