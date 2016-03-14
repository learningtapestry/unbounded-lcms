function EnhanceInstructionCard(props) {
  const instruction = props.instruction;

  return (
    <a className="o-card o-card--large" href={instruction.path}>
      <div className="c-eh-card u-bg--light">
        <div className="c-eh-card__img"></div>
        <div className="c-eh-card__body">
          <div className="u-text--small">{instruction.short_title}</div>
          <h2>{instruction.title}</h2>
        </div>
      </div>
    </a>
  );
}
