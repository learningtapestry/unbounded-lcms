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
          { isInstruction ?
            <div className="o-instruction-card__teaser">{item.teaser}</div>
            : null
          }
          <h3 className={bemClass('title')} dangerouslySetInnerHTML={{ __html: item.title }}></h3>
          { ! isInstruction ?
            <div className={bemClass('duration')}>
              <MediaTime duration={item.time_to_teach} />
            </div>
            : null
          }
        </div>
      </div>
    </a>
  );

}
