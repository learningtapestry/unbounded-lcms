function FindLessonsCards(props) {
  return (
    <div className="o-dsc__cards">
      {props.lessons.map(lesson => {
        const key = `${lesson.id}_${lesson.curriculum_id}`;
        return (<LessonCard key={key} lesson={lesson} type='base' />);
      })}
    </div>
  );
}
