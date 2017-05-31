class CurriculumTreePicker extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      tree: props.tree,
      directory: props.directory
    };
  }

  componentDidMount() {
    const $this = $(ReactDOM.findDOMNode(this));
    $this.parent().addClass('o-curriculum-tree-picker__container');

    // start jstree
    const editor = $this.find('#curriculum-tree-picker');
    editor
      .on('changed.jstree', this.onChanged.bind(this))
      .jstree({
        core : {
          animation : 0,
          themes: { dots: true },
          check_callback: true,
          data : this.state.tree
        },
        plugins : ["wholerow", "changed" ]
      });

    // preserve jsTree reference so we can call methods directly
    this.jsTree = editor.data('jstree');

    // start tagsinput
    this.dirTags = $this.find('#resource_curriculum_directory')
    this.dirTags.tagsInput({
      height: '2.5em',
      width:'65%',
    });

    // start modal
    this.jqmodal = $this.find('#curriculum-picker-modal');
    new Foundation.Reveal(this.jqmodal);

  }

  closeModal() {
    this.jqmodal.foundation('close');
  }

  onChanged(_e, data) {
    this.dirTags.importTags(this.directory(data.node).join(','));
    this.closeModal();
  }

  onClick(_e) {
    this.jqmodal.foundation('open');
  }

  directory(node) {
    return node.parents
               .map(el => this.jsTree.get_node(el).text)
               .reverse()
               .slice(1)
               .concat(node.text);
  }

  render() {
    const dir = this.state.directory.join(',');
    return (
      <div>
        <div className="input text optional resource_curriculum_directory">
          <label className="text optional" htmlFor="resource_curriculum_directory">Curriculum directory <aside>(You can pick a directory on the right, or enter curriculum tags on the left; i.e.: subject, grade, unit, etc;)</aside></label>

          <input className="text optional" name="resource[curriculum_directory]" id="resource_curriculum_directory" defaultValue={dir}></input>
          <span className='separator'> - OR - </span>
          <a href="#" className="button reveal-button" onClick={this.onClick.bind(this)}>Select Curriculum Directory</a>
        </div>
        <div className="curriculum-picker-modal reveal" id="curriculum-picker-modal" >
          <h2>Select a Curriculum Directory</h2>
          <div id="curriculum-tree-picker" className="o-curriculum-tree-picker"></div>
        </div>
      </div>
    );
  }
}
