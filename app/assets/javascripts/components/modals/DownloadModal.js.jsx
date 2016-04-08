class DownloadModal extends React.Component {

  componentDidMount() {
    if (this.refs.modal) {
      new Foundation.Reveal($(this.refs.modal));
    }
  }

  download(download) {
    const cls = `fa fa-lg file-${download.icon}`;
    return `<li>
              <i class="${cls}"></i>
              <span>
                <a href=${download.url} class="resource-attachment" target="_blank">${download.title}</a>
              </span>
            </li>`;
  }

  modalContentData() {
    const resource = this.props;
    return `<h2>Download ${_.capitalize(resource.type.name)}</h2>
            <div class="o-download-modal__content">
              <ul class="o-resource__list o-resource__list--icons">
                ${ _.map(resource.downloads, item => this.download(item)).join('\n') }
              </ul>
            </div>
            <button class="close-button" data-close aria-label="Close modal" type="button">
              <span aria-hidden="true">&times;</span>
            </button>`;
  }

  modalContent() {
    return { __html: this.modalContentData() };
  }

  render() {
    const resource = this.props;
    const modalId = `downloads-modal-${resource.id}`;

    return (resource.downloads && resource.downloads.length > 0) ?
      (
        <div className="o-download-modal" ref="modal" id={modalId}
             data-reveal dangerouslySetInnerHTML={ this.modalContent() }>
        </div>
      ) : null;
  }
}
