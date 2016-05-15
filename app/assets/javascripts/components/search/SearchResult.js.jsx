function SearchResult(props) {
  const breadcrumb = props.resource.breadcrumbs ?
          <span className='o-search-results__subheader'><span className='s-bullet'></span>{props.resource.breadcrumbs}</span>
          : null;
  const colorCode = colorCodeCss(props.resource.subject, props.resource.grade);
  return (
    <li className='o-search-results__item'>
      <div className={`cs-txt--${colorCode}`}>
        <span className='o-search-results__header'>{props.resource.type_name}</span>
        {breadcrumb}
      </div>
      <div className='o-search-results__title'>
        <a href={props.resource.path}><h3>{props.resource.title}</h3></a>
      </div>
      <div className='o-search-results__teaser'>
        {props.resource.teaser}
      </div>
    </li>
  );
}
