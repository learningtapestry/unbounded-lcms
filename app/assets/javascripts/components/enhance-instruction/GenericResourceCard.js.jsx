// eslint-disable-next-line no-unused-vars
function GenericResourceCard(props) {
  const item = props.item;
  const mainClass = 'o-generic-card';
  const bemClass = _.partial(convertToBEM, mainClass);
  const cssGeneric = classNames(
    mainClass,
    `cs-link-bg--${colorCodeCss(item.subject, item.grade_avg)}`
  );

  const onCardClick = () => heap.track('PD Resource Opened', { title: item.title, type: item.instruction_type });

  return (
    <a className={cssGeneric} href={item.path} onClick={onCardClick}>
      <div className={bemClass('wrap')}>
        <div className={bemClass('title')}>{item.title}</div>
        <div className={bemClass('teaser')}>{item.teaser}</div>
      </div>
    </a>
  );
}
