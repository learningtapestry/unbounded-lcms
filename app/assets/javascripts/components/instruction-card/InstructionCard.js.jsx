function InstructionCard(props) {
  const item = props.item;
  const mainClass = `o-instruction-card--${item.instruction_type}`;
  const bemClass = _.partial(convertToBEM, mainClass);
  const cssInstruction = classNames(
    'o-instruction-card',
    `cs-link-bg--${colorCodeCss(item.subject)}`,
    mainClass
  );
  const cssWrapper = classNames(
    'o-instruction-card__wrap',
    bemClass('wrap')
  );
  const cssImage = classNames(
    'o-instruction-card__img',
    bemClass('img')
  );
  const cssBody = classNames(
    'o-instruction-card__body',
    bemClass('body')
  );

  return (
    <a className={cssInstruction} href={props.item.path}>
      <div className={cssWrapper}>
        <div className={cssImage}>
          <img src={item.img}/>
        </div>
        <div className={cssBody}>
          { item.instruction_type == 'instruction' ?
            <div className="o-instruction-card__teaser">{item.teaser}</div>
            : null
          }
          <h3 className={bemClass('title')} dangerouslySetInnerHTML={{ __html: item.title }}></h3>
        </div>
      </div>
    </a>
  );

}
