function ExploreCurriculumCollapsedItem(props) {
  let resource = props.curriculum.resource;

  return (
    <div className="o-expcur o-expcur--base">
      <div className="o-expcur__body">
        <div>
          <strong>{resource.title}</strong>
          &nbsp;<button onClick={props.onClickExpand}>EXPAND</button>
        </div>
      </div>
    </div>
  );
}
