require 'rails_helper'

describe CurriculumTree do
  let!(:curriculum) { create(:curriculum_tree) }

  it 'has valid factory' do
    expect(curriculum).to be_valid
  end

  it 'can contain only one default' do
    expect { create :curriculum_tree, name: 'another' }.to \
      raise_error.with_message(/Default has already been taken/)
  end

  describe 'memoize defaults' do
    let(:empty_tree) { [{ 'name' => 'ela', 'children' => [] }] }

    it 'has a .default' do
      expect(CurriculumTree.default).to eq curriculum

      # cache value on a class instance var
      expect(CurriculumTree.instance_variable_get(:@default)).to \
        be_a_kind_of(CurriculumTree)
    end

    it 'has a .default_tree' do
      expect(CurriculumTree.default_tree).to eq curriculum.tree

      # cache value on a class instance var
      expect(CurriculumTree.instance_variable_get(:@default_tree)).to \
        be_a_kind_of(Array)
    end

    it 'expire memoized value when we update' do
      curr = CurriculumTree.default

      expect(CurriculumTree.instance_variable_get(:@default)).to \
        be_a_kind_of(CurriculumTree)

      curr.update tree: empty_tree

      # expire (set to nil) vars
      expect(CurriculumTree.instance_variable_get(:@default)).to be_nil
      expect(CurriculumTree.instance_variable_get(:@default_tree)).to be_nil

      # get new results as expected
      expect(CurriculumTree.default_tree).to eq(empty_tree)
    end
  end
end
