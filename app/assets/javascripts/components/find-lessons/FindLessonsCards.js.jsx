function FindLessonsCards(props) {
  return (
    <div className="o-dsc__cards">
      {props.lessons.map(lesson => {
        return <LessonCard key={lesson.id} lesson={lesson} />;
      })}
    </div>
  );
}
