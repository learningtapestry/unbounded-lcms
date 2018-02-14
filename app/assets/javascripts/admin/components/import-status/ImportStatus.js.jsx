// eslint-disable-next-line no-unused-vars
class ImportStatus extends React.Component {
  constructor(props) {
    super(props);
    this.state = { jobs: props.jobs };
    this.pollingInterval = 5000;
    this.chunkSize = 50;
  }

  componentDidMount() {
    this.intervalFn = setInterval(this.poll.bind(this), this.pollingInterval);
  }

  poll() {
    const pendingJobs = _.compact(_.map(this.state.jobs, (job, jid) => job.status !== 'done' ? jid : null));
    if (pendingJobs.length > 0) {
      _.each(_.chunk(pendingJobs, this.chunkSize), jids => this.updateChunkStatus(jids));
    } else {
      clearInterval(this.intervalFn);
    }
  }

  updateChunkStatus(jids) {
    $.getJSON(`/admin/${this.props.type}/import_status`, {
      jids: jids,
      type: this.props.type,
      _: Date.now() // prevent cached response
    }).done(res => {
      let updatedJobs = {};
      _.each(res, (val, jid) => {
        updatedJobs[jid] = _.extend(this.state.jobs[jid], { status: val.status }, val.result);
      });
      this.setState({ jobs: _.extend(this.state.jobs, updatedJobs) });
    }).fail(res => {
      console.warn('check content export status', res);
    });
  }

  resourceButton(job) {
    return <a href={`/${this.props.type}/${job.model.id}`} className="o-adm-materials__resource ub-icon ub-eye pull-right button primary" target="_blank"></a>;
  }

  spinner() {
    return <i className="fa fa-spin fa-spinner u-margin-left--base" />;
  }

  render() {
    const waitingCount = _.filter(this.state.jobs, (job) =>  job.status !== 'done').length;
    const importedCount = _.filter(this.state.jobs, (job) =>  job.status === 'done' && job.ok ).length;
    const failedCount = _.filter(this.state.jobs, (job) =>  job.status === 'done' && !job.ok ).length;

    const results = _.map(this.state.jobs, (job, key) => {
      let status;
      if (job.status === 'done') {
        status = job.ok ? 'ok' : 'err';
      } else {
        status = job.status;
      }
      return (
        <li className={`o-adm-materials__result o-adm-materials__result--${status}`} key={key}>
          <a href={job.link} target='_blank' className='o-adm-materials__link'>
            {job.link}
            {job.status !== 'done' ? this.spinner() : null}
            {job.status === 'done' && job.ok ? this.resourceButton(job) : null}
          </a>
          {job.errors ? (<p dangerouslySetInnerHTML={{__html: job.errors[0]}}></p>) : null}
        </li>
      );
    });

    return (
      <div>
        <p className="o-adm-materials__summary">
          <span className='summary-entry'>• {waitingCount} Files(s) Processing</span>
          <span className='summary-entry'>✓ {importedCount} File(s) Imported</span>
          <span className='summary-entry'>x {failedCount} File(s) Failed</span>
        </p>
        <aside className='o-adm-materials__summary--aside'>After the (re)import the files for export are still in process of being generated in the background. They will appear soon after.</aside>
        <ul className="o-adm-materials__results">
          {results}
        </ul>
      </div>
    );
  }
}
