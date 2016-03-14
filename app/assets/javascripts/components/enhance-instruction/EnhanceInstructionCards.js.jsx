function EnhanceInstructionCards(props) {
  return (
    <div className="o-dsc__cards">
      { props.instructions.map(instruction => {
        return (<EnhanceInstructionCard key={instruction.id} instruction={instruction} />);
      })}
    </div>
  );
}
