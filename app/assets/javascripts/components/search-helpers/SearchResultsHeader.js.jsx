function SearchResultsHeader(props) {
  const startNum = (props.current_page - 1) * props.per_page + 1;
  const endNum = startNum + props.num_items - 1;

  return (
    <div className="o-s-header">
      <div className="o-s-header__item">
        <p>Showing {startNum}&mdash;{endNum} of {props.total_hits}</p>
      </div>
      <div className="o-s-header__item">
        <div className="o-s-select">
          {
            (props.onChangePerPage) ?
              <div className="o-s-select__item">
                <select value={props.per_page} onChange={props.onChangePerPage}>
                  <option value="12">Show 12</option>
                  <option value="24">Show 24</option>
                </select>
              </div>

            : false
          }

          {
            (props.onChangeOrder) ?
              <div className="o-s-select__item">
                <select value={props.order} onChange={props.onChangeOrder}>
                  <option value="asc">Sort by asc</option>
                  <option value="desc">Sort by desc</option>
                </select>
              </div>

            : false
          }
        </div>
      </div>
    </div>
  );
}
