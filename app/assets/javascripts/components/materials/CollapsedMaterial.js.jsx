function CollapsedMaterial(props) {
  return (
    <div className="o-m-thumbnail">
      <div className="o-m-overlay__wrap">
        <img src={props.thumb}/>
        <div className="o-m-overlay">
          <div className="o-m-overlay__preview" onClick={() => props.onPreview(true, props.index)}>
            <a className="u-preserve-style cs-txt-link--light">
              <i className="ub-icon ub-eye fa-2x" aria-hidden="true"></i>
            </a>
          </div>
          <div className="o-m-overlay__actions">
            <ul className="menu align-center">
              <li>
                <a className="u-preserve-style cs-txt-link--light" href={props.url} target="_blank">
                  <i className="ub-icon ub-print" aria-hidden="true"></i>
                </a>
              </li>
              <li>
                <a className="u-preserve-style cs-txt-link--light" href={props.url} target="_blank">
                  <i className="ub-icon ub-file-pdf" aria-hidden="true"></i>
                </a>
              </li>
              <li>
                <a className="u-preserve-style cs-txt-link--light u-link--disabled">
                  <i className="ub-icon ub-file-gdoc" aria-hidden="true"></i>
                </a>
              </li>
            </ul>
          </div>
        </div>
      </div>
      <div className="u-txt--m-subtitle u-padding-top--base u-text--uppercase">{props.subtitle}</div>
      <div className="u-txt--m-title">{props.title}</div>
    </div>
  );
}
