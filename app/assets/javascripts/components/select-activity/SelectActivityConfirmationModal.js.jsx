class SelectActivityConfirmationModal extends React.Component {
  constructor(props) {
    super(props);

    this.heapTracked = false;
    this.expanded = false;
  }

  clickKeep() {
    this.track('Kept');
    this.$modal.close();
  }

  clickRemove() {
    this.track('Deselected', { learnMore: this.expanded });
    this.props.callback();
    this.$modal.close();
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
      } else {
        this.expanded = true;
        this.text.textContent = this.props.text;
      }
    });

    $body.on('closed.zf.reveal', () => {
      if (this.heapTracked && this.expanded) return
      this.track('Close', { expanded: this.expanded, learnMore: this.expanded });
    });

    this.$modal = new Foundation.Reveal($body);
    this.$modal.$element.on('click', '.js-confirm', this.clickRemove.bind(this));
    this.$modal.$element.on('click', '.js-expand', this.expandText.bind(this));
    this.$modal.$element.on('click', '.js-keep', this.clickKeep.bind(this));
  }

  expandText() {
    setTimeout(() => {
      this.text.classList.add('o-activity-modal--content--expanded');
      this.text.textContent = this.props.text;
      this.expanded = true;
      this.track('Learn More Expanded')
    })
  }

  render() {
    const modalId = `confirm-${this.props.item.id}`;

    return (
      <div className="o-ld-activity-confirm-modal reveal" data-reveal id={modalId} ref={x => this.body = x}>
        <h1 className="o-ld-activity-confirm-modal__title">Before removing, consider the following:</h1>
        <div className="u-hr-small" />
        <p className="o-activity-modal--content" ref={x => this.text = x}>
          <span className="js-text">{this.props.text}</span>
          <span className="u-margin-left--xs js-ellipsis">
            ...
            <a className="cs-txt-link--yellow js-expand u-margin-left--xs" href="javascript:;">Learn More</a>
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
    heap.track(`Activity ${event}`, { ...extras, id: this.props.item.id })
  }
}
