# frozen_string_literal: true

require 'rails_helper'

describe CurriculumForm do
  let(:params) { {} }
  let(:form) { described_class.new params }

  def resources_by_directory(dir)
    meta = Resource.metadata_from_dir(dir)
    Resource.tree.where('metadata @> ?', meta.to_json)
  end

  describe '#save' do
    context 'handles the change_log' do
      let(:dir) { ['ela', 'grade 2', 'module 1', 'unit 1'] }
      let(:new_dir) { ['ela', 'grade 2', 'module 1', 'unit a'] }
      let(:from) { 'unit 1' }
      let(:to) { 'unit a' }
      let(:change_log) { [{ op: 'rename', from: from, to: to, curriculum: dir[0...-1] }].to_json }
      let(:params) { { tree: '[]', change_log: change_log } }

      before do
        build_resources_chain(dir)
        parent = Resource.find_by_directory(dir)
        3.times do |i|
          lesson = "lesson #{i + 1}"
          meta = Resource.metadata_from_dir(dir).merge(lesson: lesson)
          create(:resource, parent: parent, metadata: meta, title: lesson)
        end
      end

      it 'rename curriuculum tags on the resources' do
        expect(resources_by_directory(dir).count).to eq 4 # 3 lesson + the unit itself
        expect(form.save).to be_truthy
        expect(resources_by_directory(dir).count).to eq 0
        expect(resources_by_directory(new_dir).count).to eq 4
      end
    end
  end
end
