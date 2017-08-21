class SubscriptionPopup extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      firstName: '',
      lastName: ''
    }
  }

  render() {
    return (
      <form acceptCharset="UTF-8"
            action="//standardsinstitutes.us11.list-manage.com/subscribe/post?u=ea02a2b276fb89a7c2884182c&id=3c9308d34e"
            method="post"
            onSubmit={this.props.onSubmit}
            target="_blank">
        <input name="utf8" defaultValue="✓" type="hidden" />
        <div>
          <input type="text" className="input" placeholder="Enter Full Name" defaultValue="" onChange={e => this.setName(e)} />
        </div>
        <div>
          <input className="input hide" id="mce-FNAME" name="FNAME" type="text" value={this.state.firstName}/>
        </div>
        <div>
          <input className="input hide" id="mce-LNAME" name="LNAME" type="text" value={this.state.lastName}/>
        </div>
        <div>
          <input className="input" id="mce-EMAIL" name="EMAIL" placeholder="Enter Email Address*" required="required" type="email"/>
        </div>
        <div>
          <button className="o-ub-btn o-ub-btn--yellow" type="submit">Subscribe</button>
        </div>
      </form>
    );
  }

  setName(e) {
    const names = e.target.value.trim().split(' ');
    this.setState({
      firstName: names[0],
      lastName: (names.length > 1 ? names[1] : '')
    })
  }
}
