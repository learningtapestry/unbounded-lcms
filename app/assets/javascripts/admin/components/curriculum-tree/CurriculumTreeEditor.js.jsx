class CurriculumTreeEditor extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      data: props.tree,
      changeLog: [],
      createdIds: [],
    };
  }

  componentDidMount() {
    const $this = $(ReactDOM.findDOMNode(this));
    $this.parent().addClass('o-curriculum-tree-editor__container');

    const editor = $this.find('#curriculum-tree-editor');
    editor
      .on('rename_node.jstree', this.onRenameNode.bind(this))
      .on('move_node.jstree', this.onMoveNode.bind(this))
      .on('create_node.jstree', this.onCreateNode.bind(this))
      .on('delete_node.jstree', this.onDeleteNode.bind(this))
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
    // after a create we have a rename, so we store the reference on the
    // created event and grab the full event data here
    if (this.state.createdIds.indexOf(data.node.id) > -1) {
      this.appendToChangelog({
        id:    data.node.id,
        op:    'create',
        chain: this.hierarchy(data.node),
        name:  data.node.text
      });

    } else {
      const parents = this.hierarchy(data.node).slice(0, -1);
      this.appendToChangelog({
        id:   data.node.id,
        op:   'rename',
        from: parents.concat(data.old),
        to:   parents.concat(data.text)
      });
    }
  }

  onMoveNode(_e, data) {
    const oldParents = this.hierarchy(data.old_parent);
    const newParents = this.hierarchy(data.parent);

    this.appendToChangelog({
      id:   data.node.id,
      op:   'move',
      from: oldParents.concat(data.node.text),
      to:   newParents.concat(data.node.text)
    });
  }

  onCreateNode(_e, data) {
    const createdIds = this.state.createdIds.concat(data.node.id);
    this.setState({...this.state, createdIds: createdIds});
  }

  onDeleteNode(_e, data) {
    this.appendToChangelog({
      id:    data.node.id,
      op:    'delete',
      chain: this.hierarchy(data.node),
      name:  data.node.text
    });
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

  appendToChangelog(newEntry) {
    const changeLog = this.state.changeLog.concat(newEntry);
    this.setState({...this.state, changeLog: changeLog});
  }

  handleSubmit(e) {
    const form = $(e.target);
    // update the 'tree' json field
    const jsonData = JSON.stringify(this.jsTree.get_json());
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
