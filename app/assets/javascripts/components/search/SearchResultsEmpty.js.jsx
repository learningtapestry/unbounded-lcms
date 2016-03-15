function SearchResultsEmpty(props) {
  return (
    <div className='o-search-results__empty'>
      <h2>Sorry, No Results were found for "{props.searchTerm}"</h2>
      <p>
        <h3 className='u-text--large'>Sugestions</h3>
        <ul>
          <li>Check your spelling</li>
          <li>Try user fewer filters</li>
          <li>Try more general Terms</li>
        </ul>
      </p>
      <hr />

      <p>
        <h3 className='u-text--large'>Or, Maybe We Can Help</h3>

        <ul>
          <li><a href="">Explore Our Curriculum</a></li>
          <li><a href="">Find Lessons in our Library</a></li>
          <li><a href="">Contact Us</a></li>
        </ul>
      </p>
    </div>
  );
}
