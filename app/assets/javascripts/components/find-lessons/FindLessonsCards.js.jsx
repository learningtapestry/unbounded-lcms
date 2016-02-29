function FindLessonsCards(props) {
  return (
    <div className="o-dsc__cards">
      {props.lessons.map(lesson => {
        return <MediumCard key={lesson.id} resource={lesson} />;
      })}
    </div>
  );
}
