class ExpandedMaterial extends React.Component {
  componentDidMount() {
    const { id, url } = this.props;
    const options = {
      pdfOpenParams: { page: 1, view: 'FitV' },
      PDFJS_URL: Routes.pdfjs_full_path()
    };
    PDFObject.embed(url, `#pdfobject-${id}`, options);
  }

  render() {
    const { id, orientation, onMinimize, url } = this.props;
    const clsBtn = "o-btn o-btn--bordered-base o-ub-ld-btn--material u-margin-right--xs";
    return (
      <div className="o-m-preview__wrap u-padding-top--base">
        <div className="o-m-preview__actions u-padding-top--base">
          <button className={clsBtn} onClick={() => onMinimize(false)}>Minimize</button>
          <button className={clsBtn} href={url} target="_blank">Print</button>
          <button className={clsBtn} href={url} target="_blank">View PDF</button>
          <button className="o-btn o-btn--bordered-base o-ub-ld-btn--material o-ub-btn--disabled">Download DOCX</button>
        </div>
        <div className={`o-m-preview--${orientation}`}>
          <div id={`pdfobject-${id}`} className="o-m-preview pdfobject-container content">
          </div>
        </div>
      </div>
    );
  }

}
