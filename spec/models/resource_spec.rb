# frozen_string_literal: true

require 'rails_helper'

describe Resource do
  it 'has valid factory' do
    expect(create(:resource)).to be_valid
  end

  describe '.tree' do
    before do
      pub = create(:curriculum, name: 'Test', slug: 'test', default: false)
      2.times { create(:resource) }
      3.times { create(:resource, curriculum: pub) }
      2.times { create(:resource, curriculum: nil) }
    end

    it 'selects only resources with a default curriculum assoc' do
      expect(Resource.count).to eq 7
      expect(Resource.tree.count).to eq 2
    end

    it 'selects resources by curriculum name' do
      expect(Resource.tree('Test').count).to eq 3
    end

    it 'selects resources by curriculum slug' do
      expect(Resource.tree('engageny').count).to eq 2
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

  describe 'add author to grades and its descendants' do
    let(:author) { create(:author) }
    let(:dir) { ['math', 'grade 2', 'module 1', 'topic a', 'lesson 1'] }

    before { build_resources_chain(dir) }

    it 'set authorship on grades' do
      grade = Resource.find_by_directory dir[0..2]
      lesson = Resource.find_by_directory dir

      expect(grade.author).to be_nil
      expect(lesson.author).to be_nil

      grade.add_grade_author(author)

      expect(grade.reload.author_id).to eq author.id
      expect(lesson.reload.author_id).to eq author.id
    end

    it 'set authorship on descendants' do
      grade = Resource.find_by_directory dir[0..2]
      lesson = Resource.find_by_directory dir

      expect(grade.author).to be_nil
      expect(lesson.author).to be_nil

      lesson.add_grade_author(author)

      expect(grade.reload.author_id).to eq author.id
      expect(lesson.reload.author_id).to eq author.id
    end
  end

  describe 'update metadata on save' do
    let(:dir) { ['math', 'grade 2', 'module 1', 'topic a'] }

    before { build_resources_chain dir }

    it 'populate metadata on creation' do
      parent = Resource.find_by_directory dir

      res = Resource.create! parent: parent,
                             title: 'Math-G2-M1-TA-Lesson 1',
                             short_title: 'lesson 1',
                             curriculum: Curriculum.default,
                             curriculum_type: 'lesson'
      meta = { 'subject' => 'math',
               'grade' => 'grade 2',
               'module' => 'module 1',
               'unit' => 'topic a',
               'lesson' => 'lesson 1' }
      expect(res.metadata).to_not be_empty
      expect(res.metadata).to eq meta
    end
  end
end
