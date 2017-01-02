function InstructionCard(props) {
  const item = props.item;
  const mainClass = `o-instruction-card--${item.instruction_type}`;
  const bemClass = _.partial(convertToBEM, mainClass);
  const cssInstruction = classNames(
    'o-instruction-card',
    `cs-link-bg--${colorCodeCss(item.subject, item.grade_avg)}`,
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
  const instructionBody = isInstruction ?
    (
      <div className={cssBody}>
        <div className="o-instruction-card__teaser">{item.teaser}</div>
        <h3 className={bemClass('title')} dangerouslySetInnerHTML={{ __html: item.title }}></h3>
      </div>
    ) :
    (
      <div className={cssBody}>
        <div className={bemClass('title-wrap')}>
          <h3 className={bemClass('title')} dangerouslySetInnerHTML={{ __html: item.title }}></h3>
          <i className={bemClass('icon')}></i>
        </div>
        <div className={bemClass('duration')}>
          <MediaTime duration={item.time_to_teach} />
        </div>
      </div>
    )

  return (
    <a className={cssInstruction} href={props.item.path}>
      <div className={cssWrapper}>
        <div className={cssImage}>
          <img src={item.img}/>
        </div>
        {instructionBody}
      </div>
    </a>
  );

}
