require 'rails_helper'

describe CurriculumForm do
  let(:params) { {} }
  let(:form) { described_class.new params }

  describe '#save' do
    # TODO fix me after the resource tree refactor
    # context 'handles the change_log' do
    #   let(:dir) { ['ela', 'grade 2', 'module 1', 'unit 1'] }
    #   let(:new_dir) { ['ela', 'grade 2', 'module 1', 'unit a'] }
    #   let(:change_log) { [{ op: 'rename', from: dir, to: new_dir }].to_json }
    #   let(:params) { { tree: '[]', change_log: change_log } }
    #
    #   before do
    #     build_resources_chain(dir)
    #     3.times do |i|
    #       lesson = "lesson #{i + 1}"
    #       create(:resource, curriculum_directory: dir + [lesson], title: lesson)
    #     end
    #   end
    #
    #   it 'rename curriuculum tags on the resources' do
    #     expect(Resource.tree.where_curriculum(dir).count).to eq 4 # 3 lesson + the unit itself
    #     expect(form.save).to be_truthy
    #     expect(Resource.tree.where_curriculum(dir).count).to eq 0
    #     expect(Resource.tree.where_curriculum(new_dir).count).to eq 4
    #   end
    # end
  end
end
