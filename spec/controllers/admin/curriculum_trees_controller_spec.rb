require 'rails_helper'

describe Admin::CurriculumTreesController do
  let(:user) { create :admin }
  let(:curriculum) { create :curriculum_tree }

  before { sign_in user }

  describe '#index' do
    subject { get :index }

    it { is_expected.to be_success }
  end

  describe '#edit' do
    subject { get :edit, id: curriculum.id }

    it { is_expected.to render_template :edit }
  end

  describe '#update' do
    let(:empty_tree) { [{ name: 'ela', children: [] }.with_indifferent_access] }
    let(:empty_tree_json) { '[{"text":"ela","children":[]}]' }

    before { curriculum }

    it 'changes the tree' do
      expect(CurriculumTree.default_tree).to eq(curriculum.tree)

      patch :update, id: curriculum.id, curriculum_tree: { tree: empty_tree_json }
      expect(CurriculumTree.default_tree).to eq(empty_tree)
    end
  end
end
