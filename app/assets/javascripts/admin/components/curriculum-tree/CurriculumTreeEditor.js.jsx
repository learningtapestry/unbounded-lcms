class CurriculumTreeEditor extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      data: props.tree,
      changeLog: []
    };
  }

  componentDidMount() {
    const $this = $(ReactDOM.findDOMNode(this));
    $this.parent().addClass('o-curriculum-tree-editor__container');

    const editor = $this.find('#curriculum-tree-editor');
    editor
      .on('rename_node.jstree', this.onRenameNode.bind(this))
      .on('move_node.jstree', this.onMoveNode.bind(this))
      .jstree({
        core : {
          animation : 0,
          themes: { dots: true },
          check_callback: true,
          data : this.state.data
        },
        plugins : [ "contextmenu", "dnd", "wholerow", "changed" ]
      });

    // preserve jsTree reference so we can call methods directly
    this.jsTree = editor.data('jstree');
  }

  onRenameNode(_e, data) {
    const parents = this.hierarchy(data.node).slice(0, -1);

    const newChangeLog = this.state.changeLog.concat({
      id:   data.node.id,
      op:   'rename',
      from: parents.concat(data.old),
      to:   parents.concat(data.text)
    });
    this.updateChangelog(newChangeLog);
  }

  onMoveNode(_e, data) {
    const oldParents = this.hierarchy(data.old_parent);
    const newParents = this.hierarchy(data.parent);

    const newChangeLog = this.state.changeLog.concat({
      id:   data.node.id,
      op:   'move',
      from: oldParents.concat(data.node.text),
      to:   newParents.concat(data.node.text)
    });
    this.updateChangelog(newChangeLog);
  }

  hierarchy(node) {
    if (typeof node === 'string') {
      node = this.jsTree.get_node(node);
    }
    return node.parents
               .map(el => this.jsTree.get_node(el).text)
               .reverse()
               .slice(1)
               .concat(node.text);
  }

  updateChangelog(changeLog) {
    this.setState({...this.state, changeLog: changeLog});
  }

  handleSubmit(e) {
    const form = $(e.target);
    const jsonData = JSON.stringify(this.jsTree.get_json());
    // update the 'tree' json field
    form.find('[name="curriculum_tree[tree]"]').val(jsonData);
  }

  render() {
    const jsonData = JSON.stringify(this.state.data);
    const jsonChangeLog = JSON.stringify(this.state.changeLog);
    return (
      <div>
        <form action={this.props.form_url} acceptCharset="UTF-8" method="post" onSubmit={this.handleSubmit.bind(this)}>
          <input name="utf8" value="✓" type="hidden" />
          <input name="_method" value="patch" type="hidden" />
          <input name="authenticity_token" value={this.props.form_token} type="hidden" />
          <input name="curriculum_tree[tree]" type="hidden" value={jsonData} />
          <input name="curriculum_tree[change_log]" type="hidden" value={jsonChangeLog} />
          <input value="Save Changes" className="button primary" type="submit" />
        </form>
        <p className="o-curriculum-tree-editor__menu-info">(Click on a node with the right button to add/edit/remove)</p>
        <div id="curriculum-tree-editor" className="o-curriculum-tree-editor"></div>
      </div>
    );
  }
}
