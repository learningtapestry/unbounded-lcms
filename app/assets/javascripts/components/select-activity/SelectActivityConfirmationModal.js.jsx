class SelectActivityConfirmationModal extends React.Component {
  constructor(props) {
    super(props);

    this.heapTracked = false;
    this.expanded = false;
    this.track = this.track.bind(this)
  }

  clickKeep() {
    this.track('Kept');
    this.$modal.close();
  }

  clickRemove() {
    this.track('Deselected');
    this.props.callback();
    this.$modal.close();
  }

  closeModal() {
    this.heapTracked || this.track('Close');
    this.heapTracked = false // restore state
  }

  componentDidMount() {
    if (!this.body) return;

    let $body = $(this.body);

    $body.on('open.zf.reveal', () => {
      let innerText = this.text.querySelector('.js-text');
      if (!innerText) return;

      if (this.text.scrollHeight > this.text.clientHeight) {
        let chunks = this.props.text.trim().split(/\s+/);
        while (this.text.scrollHeight > this.text.clientHeight) {
          chunks.splice(chunks.length - 1, 1)
          innerText.textContent = chunks.join(' ');
        }
        innerText.classList.remove('js-text')
      } else {
        this.text.textContent = this.props.text;
      }
    });

    $body.on('closed.zf.reveal', this.closeModal.bind(this));

    this.$modal = new Foundation.Reveal($body);
    this.$modal.$element.on('click', '.js-confirm', this.clickRemove.bind(this));
    this.$modal.$element.on('click', '.js-expand', this.expandText.bind(this));
    this.$modal.$element.on('click', '.js-keep', this.clickKeep.bind(this));
  }

  expandText(e) {
    setTimeout(() => {
      this.text.classList.add('o-ld-selection-modal__content--expanded');
      this.text.textContent = this.props.text;
      this.expanded = true;
      this.track('Learn More');
      this.heapTracked = false // ^^ is not a final event
    })
  }

  render() {
    const modalId = `confirm-${this.props.item.id}`;

    return (
      <div className="o-ld-selection-modal reveal" data-reveal id={modalId} ref={x => this.body = x}>
        <h1 className="o-ld-selection-modal__title">Before removing, consider the activity's purpose:</h1>
        <div className="u-hr-small" />
        <p className="o-ld-selection-modal__content" ref={x => this.text = x}>
          <span className="js-text">{this.props.text}</span>
          <span className="u-margin-left--xs js-ellipsis">
            ...
            <a className="cs-txt-link--dark-gold js-expand u-margin-left--xs" href="javascript:;">Learn More</a>
          </span>
        </p>
        <div className="u-text--right">
          <button className="js-confirm o-btn o-btn--xs-full o-btn--bordered-yellow u-color--base u-margin-right--base" type="button">Remove Activity</button>
          <button className="js-keep o-btn o-btn--yellow o-btn--xs-full" type="button">Keep Activity</button>
        </div>
      </div>
    )
  }

  track(event, extras = {}) {
    this.heapTracked = true
    heap.track(`Activity ${event}`, { ...extras, id: this.props.item.id, learnMore: this.expanded })
  }
}
