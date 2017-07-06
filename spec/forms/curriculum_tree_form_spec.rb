require 'rails_helper'

describe CurriculumTreeForm do
  let!(:curriculum_tree) { create(:curriculum_tree) }

  let(:params) { {} }
  let(:form) { described_class.new curriculum_tree.id, params }

  it 'has a presenter' do
    expect(form.presenter.class).to eq(CurriculumTreePresenter)
  end

  it 'has the corresponding curriculum model' do
    expect(form.curriculum_tree).to eq curriculum_tree
  end

  describe '#save' do
    let(:tree) { [{ name: 'ela', children: [{ name: 'grade 1', children: [] }] }.with_indifferent_access] }
    let(:params) { { tree: tree.to_json.gsub('"name"', '"text"') } }

    it 'changes the tree' do
      expect(CurriculumTree.default_tree).to eq(curriculum_tree.tree)

      expect(form.save).to be_truthy
      expect(CurriculumTree.default_tree).to eq(tree)
    end

    context 'handles the change_log' do
      let(:dir) { ['ela', 'grade 2', 'module 1', 'unit 1'] }
      let(:new_dir) { ['ela', 'grade 2', 'module 1', 'unit a'] }
      let(:change_log) { [{ op: 'rename', from: dir, to: new_dir }].to_json }
      let(:params) { { tree: '[]', change_log: change_log } }

      before do
        build_resources_chain(dir)
        3.times do |i|
          lesson = "lesson #{i + 1}"
          create(:resource, curriculum_directory: dir + [lesson], title: lesson)
        end
      end

      it 'rename curriuculum tags on the resources' do
        expect(Resource.tree.where_curriculum(dir).count).to eq 4 # 3 lesson + the unit itself
        expect(form.save).to be_truthy
        expect(Resource.tree.where_curriculum(dir).count).to eq 0
        expect(Resource.tree.where_curriculum(new_dir).count).to eq 4
      end
    end
  end
end
