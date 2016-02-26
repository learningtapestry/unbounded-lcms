class MediumCard extends React.Component {
  createMarkup() {
    return {__html: this.props.resource.description }
  }

  render () {
    return (
     <div className="o-card o-card--base">
       <div className="u-wrap--base">
         <div className="o-card__header o-title">
           <span className="o-title__type">{this.props.resource.type}</span>
           <span className="o-title__duration">{this.props.resource.estimated_time} min</span>
         </div>
         <h2>{this.props.resource.title}</h2>
         <div className="o-card__dsc" dangerouslySetInnerHTML={this.createMarkup()} />
       </div>
     </div>
     );
   }
}
