function SearchResultsHeader(props) {
  let startLessonNum = (props.current_page - 1) * props.per_page + 1;
  let endLessonNum = startLessonNum + props.num_items - 1;

  return (
    <div className="c-fl-s-header">
      <div className="c-fl-s-header__item">
        <p>Showing {startLessonNum}&mdash;{endLessonNum} of {props.total_hits} Lessons</p>
      </div>
    </div>
  );
}
