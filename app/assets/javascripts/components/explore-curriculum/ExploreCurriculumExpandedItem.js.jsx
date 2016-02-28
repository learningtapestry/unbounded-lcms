function ExploreCurriculumExpandedItem(props) {
  const description = { __html: props.curriculum.description };
  
  return (
    <div className="o-expcur o-expcur--base">
      <div className="o-expcur__body">
        <h2>{props.curriculum.title}</h2>
        <div dangerouslySetInnerHTML={description}></div>
        <button onClick={props.onClickViewDetails}>
          VIEW DETAILS
        </button>
      </div>
    </div>
  );
}
