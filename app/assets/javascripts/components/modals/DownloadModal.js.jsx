class DownloadModal extends React.Component {

  componentDidMount() {
    if (this._modal) {
      new Foundation.Reveal($(this._modal));
    }
  }

  download(download) {
    const cls = `ub-icon fa-lg file-${download.icon}`;
    return `<li>
              <i class="${cls}"></i>
              <span>
                <a href=${download.url} data-no-turbolink="true" class="resource-attachment">${download.title}</a>
              </span>
            </li>`;
  }

  modalContentData() {
    const resource = this.props.resource;
    return `<div class="o-download-modal__title">
              <div class="u-margin-bottom--xs">Download ${_.capitalize(resource.type.name)}</div>
              <div class="u-hr-small"></div>
            </div>
            <div class="o-download-modal__content">
              <ul class="o-resource__list o-resource__list--icons o-resource__list--${resource.subject}-base">
                ${ _.map(resource.downloads, item => this.download(item)).join('\n') }
              </ul>
            </div>
            <button class="close-button" data-close aria-label="Close modal" type="button">
              <span aria-hidden="true"><i class="ub-close"></i></span>
            </button>`;
  }

  modalContent() {
    return { __html: this.modalContentData() };
  }

  render() {
    const resource = this.props.resource;
    const modalId = `downloads-modal-${resource.id}`;

    return (resource.downloads && resource.downloads.length > 0) ?
      (
        <div className="o-download-modal" ref={(ref) => this._modal = ref} id={modalId}
             data-reveal dangerouslySetInnerHTML={ this.modalContent() }>
        </div>
      ) : <div className="hide"></div>;
  }
}
