function ExploreCurriculumCollapsedItem(props) {
  return (
    <div className="o-expcur o-expcur--base">
      <div className="o-expcur__body">
        <div>
          <strong>{props.curriculum.title}</strong>
          &nbsp;<button onClick={props.onClickExpand}>EXPAND</button>
        </div>
      </div>
    </div>
  );
}
