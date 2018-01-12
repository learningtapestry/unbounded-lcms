require 'rails_helper'

describe Resource do
  it 'has valid factory' do
    expect(create(:resource)).to be_valid
  end

  describe '.tree' do
    before do
      2.times { create(:resource) }
      3.times { create(:resource, tree: false) }
    end

    it 'selects only resources from the default curriculum_tree' do
      expect(Resource.tree.count).to eq 2
    end
  end

  describe '.where_curriculum' do
    before { resources_sample_collection }

    it 'selects based on the tags passed' do
      expect(Resource.where_curriculum(:ela).count).to eq 8
      expect(Resource.where_curriculum('grade 2').count).to eq 2
      expect(Resource.where_curriculum('math', 'grade 7').count).to eq 7
    end

    it 'also accepts arrays as param' do
      expect(Resource.where_curriculum(['ela', 'grade 6']).count).to eq 6
    end
  end

  describe '.where_subject' do
    before { resources_sample_collection }

    it 'select by subject' do
      expect(Resource.where_subject('ela').count).to eq 8
    end

    it 'accepts multiple entries' do
      expect(Resource.where_subject(%w(ela math)).count).to eq 19
    end
  end

  describe '.where_grade' do
    before { resources_sample_collection }

    it 'select by subject' do
      expect(Resource.where_grade('grade 4').count).to eq 4
    end

    it 'accepts multiple entries' do
      expect(Resource.where_grade(['grade 2', 'grade 7']).count).to eq 9
    end
  end

  describe '#curriculum_tags_for' do
    def resource_for(dir)
      create(:resource, curriculum_directory: dir)
    end

    it 'get tags for subject' do
      res = resource_for ['ela', 'grade 1', 'module 2']
      expect(res.curriculum_tags_for(:subject)).to eq ['ela']

      res = resource_for ['math', 'prekindergarten', 'module 3']
      expect(res.curriculum_tags_for(:subject)).to eq ['math']
    end

    it 'get tags for grade' do
      res = resource_for ['grade 2', 'bla', 'module 2']
      expect(res.curriculum_tags_for(:grade)).to eq ['grade 2']

      res = resource_for ['grade 2', 'grade 3', 'prekindergarten']
      expect(res.curriculum_tags_for(:grade)).to eq ['grade 2', 'grade 3', 'prekindergarten']
    end

    it 'get tags for module' do
      res = resource_for ['grade 2', 'ela', 'module 2']
      expect(res.curriculum_tags_for(:module)).to eq ['module 2']
    end

    it 'get tags for unit' do
      res = resource_for ['grade 2', 'ela', 'module 2', 'unit 5']
      expect(res.curriculum_tags_for(:unit)).to eq ['unit 5']

      res = resource_for ['grade 2', 'math', 'module 2', 'topic c']
      expect(res.curriculum_tags_for(:unit)).to eq ['topic c']
    end

    it 'get tags for lesson' do
      res = resource_for ['grade 2', 'ela', 'module 2', 'unit 5', 'lesson 1']
      expect(res.curriculum_tags_for(:lesson)).to eq ['lesson 1']

      res = resource_for ['grade 2', 'math', 'module 2', 'topic c', 'part 2']
      expect(res.curriculum_tags_for(:lesson)).to eq ['part 2']
    end
  end
end
