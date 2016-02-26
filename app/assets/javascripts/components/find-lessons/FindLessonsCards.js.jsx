class FindLessonsCards extends React.Component {
   render () {
    return (
      <div className="o-dsc__cards">
        {this.props.data.map(lesson => {
          return <MediumCard key={lesson.id} resource={lesson} />;
        })}
      </div>
    );
   }
 }
