class DownloadModal extends React.Component {

  componentDidMount() {
    if (this._modal) {
      new Foundation.Reveal($(this._modal));
    }
  }

  downloadsByCategories(downloads) {
    if (downloads.length < 2) return null;
    return `<strong>${downloads[0]}</strong>
            ${ _.map(downloads[1], item => this.download(item)).join('\n') }`;
  }

  download(download) {
    const indent = download.indent ? 'u-li-indent' : '';
    const cls = `ub-icon fa-lg file-${download.icon} ${indent}`;
    const preview = (download.icon == 'pdf') ?
        `<span>
          <a href=${download.preview_url} data-no-turbolink="true" target="_blank">
            <i class="ub-icon ub-eye" aria-hidden="true"></i>
          </a>
        </span>` : '';
    return `<li>
              ${preview}
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
                ${ _.map(resource.downloads, item => this.downloadsByCategories(item)).join('\n') }
              </ul>
              <div class="o-resource__cc u-margin-top--base u-margin-bottom--zero u-txt--download-copyright">
                ${resource.copyright}
              </div>
            </div>
            <button class="close-button ub-close-button" data-close aria-label="Close modal" type="button">
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
