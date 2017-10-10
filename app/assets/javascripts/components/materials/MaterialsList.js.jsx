// eslint-disable-next-line no-unused-vars
function MaterialsList(props) {
  const materials = props.data.map(m => <li key={m.id}><strong>{m.subtitle}</strong> <a href={m.url}>{m.title}</a></li>);
  return (
    <div className={`o-m-list__wrap o-material-wrapper--${props.subject}`}>
      <h3>Materials</h3>
      <ul className="o-m-list">
        {materials}
      </ul>
    </div>
  );
}
