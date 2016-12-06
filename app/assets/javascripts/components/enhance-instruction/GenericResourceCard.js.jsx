function GenericResourceCard(props) {
  const item = props.item;
  const mainClass = 'o-generic-card';
  const bemClass = _.partial(convertToBEM, mainClass);
  const cssGeneric = classNames(
    mainClass,
    `cs-link-bg--${colorCodeCss(item.subject)}`
  );

  return (
    <a className={cssGeneric} href={item.path}>
      <div className={bemClass('wrap')}>
        <div className={bemClass('title')}>{item.title}</div>
        <div className={bemClass('teaser')}>{item.teaser}</div>
      </div>
    </a>
  );
}
