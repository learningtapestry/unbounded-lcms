function FindLessonsHeader(props) {
  let startLessonNum = (props.current_page - 1) * (props.per_page + 1);
  let endLessonNum = startLessonNum + props.num_items - 1;

  return (
    <div className="c-fl-s-header">
      <div className="c-fl-s-header__item">
        <p>Showing {startLessonNum}&mdash;{endLessonNum} of {props.total_hits} Lessons</p>
      </div>
      <div className="c-fl-s-header__item">
        <div className="c-fl-s-select">
          <div className="c-fl-s-select__item">
            <select value={props.per_page} onChange={props.onChangePerPage}>
              <option value="12">Show 12</option>
              <option value="24">Show 24</option>
            </select>
          </div>
          <div className="c-fl-s-select__item">
            <select value={props.order} onChange={props.onChangeOrder}>
              <option value="asc">Sort by asc</option>
              <option value="desc">Sort by desc</option>
            </select>
          </div>
        </div>
      </div>
    </div>
  );
}
