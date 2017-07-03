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
    let(:empty_tree) { [{ name: 'ela', children: [] }.with_indifferent_access] }
    let(:params) { { tree: '[{"text":"ela","children":[]}]' } }

    it 'changes the tree' do
      expect(CurriculumTree.default_tree).to eq(curriculum_tree.tree)

      expect(form.save).to be_truthy
      expect(CurriculumTree.default_tree).to eq(empty_tree)
    end
  end
end
