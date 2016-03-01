function ExploreCurriculumExpandedItem(props) {
  let resource = props.curriculum.resource;
  const description = { __html: resource.description };
  
  return (
    <div className="o-expcur o-expcur--base">
      <div className="o-expcur__body">
        <h2>{resource.title}</h2>
        <div dangerouslySetInnerHTML={description}></div>
        <button onClick={props.onClickViewDetails}>
          VIEW DETAILS
        </button>
      </div>
    </div>
  );
}
