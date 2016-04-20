function SearchResult(props) {
  return (
    <li className='o-search-results__item'>
      <div className='o-search-results__item--type'>{props.resource.type.name}</div>
      <div className='o-search-results__item--title'>
        <a href={props.resource.path}>{props.resource.title}</a>
      </div>
      <div className='o-search-results__item--teaser'>
        {props.resource.teaser}
      </div>
    </li>
  );
}
