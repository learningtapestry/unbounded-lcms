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
  const isInstruction = (item.instruction_type === 'instruction');

  return (
    <a className={cssInstruction} href={props.item.path}>
      <div className={cssWrapper}>
        <div className={cssImage}>
          <img src={item.img}/>
        </div>
        <div className={cssBody}>
          <div className="o-title">
            <span className="o-title__type">{item.short_title}</span>
            { (!isInstruction) ?
              <span className="o-title__duration u-text--uppercase"><TimeToTeach duration={item.time_to_teach} /></span> : false
            }
            <h3 className={bemClass('title')}>{item.title}</h3>
          </div>
          { isInstruction ?
            <div className="o-instruction-card__dsc">{item.teaser}</div> : false
          }
        </div>
      </div>
    </a>
  );

}
