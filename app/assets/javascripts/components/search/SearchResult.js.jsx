function SearchResult(props) {
  const markup = { __html: props.resource.description  };
  return (
    <li className='o-search-results__item' key={props.key}>
      <div className='o-search-results__item--type'>{props.resource.type.name}</div>
      <div className='o-search-results__item--title'>
        <a href={props.resource.path}>{props.resource.title}</a>
      </div>
      <div className='o-search-results__item--teaser' dangerouslySetInnerHTML={markup} />

    </li>
  );
}
