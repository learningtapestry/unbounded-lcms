function RelatedInstructionItem(props) {
  const markup = { __html: props.item.teaser };

  return (
    <a className="o-card o-card--base" href={props.item.path}>
      <div className="u-wrap--light">
        <div className="o-card__header o-title">
          <span className="o-title__type">{props.item.short_title}</span>
          <span className="o-title__duration"><TimeToTeach duration={props.item.time_to_teach} /></span>
        </div>
        <h2>{props.item.title}</h2>
        <div className="o-card__dsc" dangerouslySetInnerHTML={markup} />
      </div>
    </a>
  );

}
