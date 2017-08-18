class SubscriptionPopup extends React.Component {
  componentDidMount() {
    if (this._modal && !this.hasCookie()) {
      new Foundation.Reveal($(this._modal)).open();
      this.setCookie();
    }
  }

  setCookie() {
    document.cookie = "unbounded_subscription=true; path=/"
  }

  hasCookie() {
    const name = "unbounded_subscription=";
    const ca = document.cookie.split(';');
    for(var i = 0; i < ca.length; i++) {
      if (ca[i].indexOf(name) >= 0) return true;
    }
    return false;
  }

  render() {
    const csrfToken = $('meta[name=csrf-token]').attr('content');
    return (<div className="o-subscription-modal" ref={(ref) => this._modal = ref} data-reveal>
      <div className="o-subscription-modal__title">
        <div className="u-margin-bottom--xs">Subscribe to our Newsletter</div>
        <div className="u-hr-small"></div>
      </div>
      <div className="o-subscription-modal__content">
        <form method="post" action="/subscription" acceptCharset="UTF-8">
          <input name="utf8" defaultValue="✓" type="hidden" />
          <input name="authenticity_token" defaultValue={csrfToken} type="hidden" />
          <div>
            <input type="text" className="input" placeholder="Enter Full Name" name="subscription[name]" />
          </div>
          <div>
            <input type="email" className="input" placeholder="Enter Email Address*" name="subscription[email]" required="required" />
          </div>
          <div className='o-subscription-form__error'>{this.props.msg}</div>
          <div>
            <button className="o-ub-btn o-ub-btn--yellow" type="submit">Subscribe</button>
          </div>
        </form>
      </div>
      <button className="close-button ub-close-button" data-close aria-label="Close modal" type="button">
       <span aria-hidden="true"><i className="ub-close"></i></span>
      </button>
    </div>);
  }
}
