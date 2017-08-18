class SubscriptionPopupContainer extends React.Component {
  componentDidMount() {
    if (this.modalId  && !this.hasCookie()) {
      this.$modal = new Foundation.Reveal($(this.modalId))
      setTimeout(() => this.$modal.open(), 3000);

      this.setCookie();

      const popup = React.createElement(SubscriptionPopup, {onSubmit: this.onSubmit.bind(this)});
      ReactDOM.render(popup, this.content);

      $(this.modalId).on('closed.zf.reveal', () => {
        setTimeout(() => ReactDOM.unmountComponentAtNode(this.content), 1000)
      });
    }
  }

  hasCookie() {
    const name = "unbounded_subscription=";
    const ca = document.cookie.split(';');
    for(var i = 0; i < ca.length; i++) {
      if (ca[i].indexOf(name) >= 0) return true;
    }
    return false;
  }

  onSubmit() {
    this.$modal.close()
  }

  render() {
    return (
      <div className="o-subscription-modal" ref={ref => this.modalId = ref} data-reveal>
        <div className="o-subscription-modal__title">
          <div className="u-margin-bottom--xs">Subscribe to our Newsletter</div>
          <div className="u-hr-small"></div>
        </div>
        <div className="o-subscription-modal__content" ref={ref => this.content = ref}>
        </div>
        <button className="close-button ub-close-button" data-close="" aria-label="Close modal" type="button">
          <span aria-hidden="true"><i className="ub-close"></i></span>
        </button>
      </div>
    );
  }

  setCookie() {
    document.cookie = "unbounded_subscription=true; path=/"
  }
}
