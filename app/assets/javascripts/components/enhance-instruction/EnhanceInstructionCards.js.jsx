function EnhanceInstructionCards(props) {
  return (
    <div className="o-page__wrap--row-nest">
      { props.instructions.map(instruction => {
        return (<EnhanceInstructionCard key={instruction.id} instruction={instruction} />);
      })}
    </div>
  );
}
