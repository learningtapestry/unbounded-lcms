function EnhanceInstructionCards(props) {
  items = props.items.map(item => (
    item.instruction_type == 'generic' ?
      <GenericResourceCard key={item.id} item={item} /> :
      <InstructionCard key={item.id} item={item} />
  ));
  return (
    <div className="o-page__wrap--row-nest">
      {items}
    </div>
  );
}
