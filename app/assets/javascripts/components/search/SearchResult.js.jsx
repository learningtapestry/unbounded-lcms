function SearchResult(props) {
  let markup = { __html: props.resource.teaser };

  return (
    <li className='o-search-results__item' key={props.key}>
      <div className='o-search-results__item--type'>{props.resource.type}</div>
      <div className='o-search-results__item--title'>
        <a href={props.resource.link}>{props.resource.title}</a>
      </div>
      <div className='o-search-results__item--teaser' dangerouslySetInnerHTML={markup} />

    </li>
  );
}
