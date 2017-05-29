require 'rails_helper'

describe Resource do
  let(:tree) { create :curriculum_tree }

  it 'has valid factory' do
    expect(create(:resource)).to be_valid
  end

  describe '.tree' do
    before do
      2.times { create(:resource, curriculum_tree: tree) }
      3.times { create(:resource, curriculum_tree: nil) }
    end

    it 'selects only resources from the default curriculum_tree' do
      expect(Resource.tree.count).to eq 2
    end
  end

  describe '.where_curriculum' do
    before do
      # ela|G1 => 1   and ela|G2 => 1
      2.times do |i|
        create(:resource, curriculum_tree: tree, curriculum_directory: ['ela', "grade #{i + 1}"])
      end

      # math|G1 => 1 and math|G2 => 3
      create(:resource, curriculum_tree: tree, curriculum_directory: ['math', 'grade 1'])
      3.times { create(:resource, curriculum_tree: tree, curriculum_directory: ['math', 'grade 2']) }
    end

    it 'selects based on the tags passed' do
      expect(Resource.where_curriculum(:ela).count).to eq 2
      expect(Resource.where_curriculum('grade 2').count).to eq 4
      expect(Resource.where_curriculum('math', 'grade 2').count).to eq 3
    end

    it 'also accepts arrays as param' do
      expect(Resource.where_curriculum(['ela', 'grade 1']).count).to eq 1
    end
  end
end
