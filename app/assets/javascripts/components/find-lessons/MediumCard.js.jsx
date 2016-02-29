function MediumCard(props) {
  let markup = { __html: props.resource.description };

  return (
    <div className="o-card o-card--base">
      <div className="u-wrap--base">
        <div className="o-card__header o-title">
          <span className="o-title__type">{props.resource.type}</span>
          <span className="o-title__duration">{props.resource.estimated_time} min</span>
        </div>
        <h2>{props.resource.title}</h2>
        <div className="o-card__dsc" dangerouslySetInnerHTML={markup} />
      </div>
    </div>
  );
}
