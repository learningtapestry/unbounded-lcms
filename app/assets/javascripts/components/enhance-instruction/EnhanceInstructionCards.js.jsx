function EnhanceInstructionCards(props) {
  return (
    <div className="o-page__wrap--row-nest">
      { props.items.map(item => {
        return (<InstructionCard key={item.id} item={item} />);
      })}
    </div>
  );
}
