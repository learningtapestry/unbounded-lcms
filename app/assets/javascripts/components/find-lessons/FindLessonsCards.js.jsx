function FindLessonsCards(props) {
  return (
    <div className="o-dsc__cards">
      {props.data.map(lesson => {
        return <MediumCard key={lesson.id} resource={lesson} />;
      })}
    </div>
  );
}
