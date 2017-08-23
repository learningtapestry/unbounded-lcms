// eslint-disable-next-line no-unused-vars
class ExpandedMaterial extends React.Component {
  componentDidMount() {
    let { id, url } = this.props;
    const options = {
      pdfOpenParams: { page: 1, view: 'FitV' },
      PDFJS_URL: Routes.pdfjs_full_path()
    };
    if (!PDFObject.supportsPDFs) {
      url = `${Routes.pdf_proxy_resources_path()}?url=${url}`;
    }
    PDFObject.embed(url, `#pdfobject-${id}`, options);
  }

  render() {
    const { id, index, onMinimize, onClick, orientation, url } = this.props;
    const clsBtn = 'o-btn o-btn--bordered-base o-ub-ld-btn--material u-margin-right--xs u-preserve-style';
    return (
      <div className="o-m-preview__wrap u-padding-top--base">
        <div className="o-m-preview__actions u-padding-top--base">
          <a className={clsBtn} onClick={() => onMinimize(false)}>Minimize</a>
          <a className={clsBtn} href={url} onClick={() => onClick('print', index)} target="_blank">Print</a>
          <a className={clsBtn} href={url} onClick={() => onClick('view', index)} target="_blank">View PDF</a>
          <a className="o-btn o-btn--bordered-base o-ub-ld-btn--material o-ub-btn--disabled u-preserve-style" onClick={() => onClick('gdoc', index)}>
            Download DOCX
          </a>
        </div>
        <div className={`o-m-preview--${orientation}`}>
          <div id={`pdfobject-${id}`} className="o-m-preview pdfobject-container content">
          </div>
        </div>
      </div>
    );
  }

}
