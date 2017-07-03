require 'rails_helper'
require 'doc_template/objects/activity_metadata'

describe DocTemplate::Objects::ActivityMetadata do
  describe '.build_from' do
    subject { DocTemplate::Objects::ActivityMetadata.build_from(activity_table) }

    describe 'empty data' do
      let(:activity_table) { [] }

      it 'returns empty object' do
        expect(subject.children.size).to eq 0
      end
    end

    describe 'correct data' do
      describe 'with single section' do
        let(:activity_table) do
          [{"section-title"=>"Opening", "activity-type"=>"Fluency Activity", "activity-title"=>"Skip-Count by Tens: Up and Down Crossing 100", "activity-source"=>"ENY-G2-M3-L1-F#4", "activity-materials"=>"", "activity-standard"=>"2.NBT.A.2", "activity-mathematical-practice"=>"", "activity-time"=>"2 min", "activity-priority"=>"2", "activity-metacognition"=>"", "activity-guidance"=>"", "activity-content-development-notes"=>""},
          {"section-title"=>"Opening", "activity-type"=>"Fluency Activity", "activity-title"=>"Unit Form Counting from 398 to 405", "activity-source"=>"ENY-G2-M3-L6-F#2", "activity-materials"=>"ENY-G2-M3-L4-T#1", "activity-standard"=>"2.NBT.A.3", "activity-mathematical-practice"=>"6", "activity-time"=>"", "activity-priority"=>"1", "activity-metacognition"=>"", "activity-guidance"=>"", "activity-content-development-notes"=>""},
          {"section-title"=>"Opening", "activity-type"=>"Fluency Activity", "activity-title"=>"Unit Form Counting from 398 to 405", "activity-source"=>"ENY-G2-M3-L6-F#2", "activity-materials"=>"ENY-G2-M3-L4-T#1", "activity-standard"=>"2.NBT.A.3", "activity-mathematical-practice"=>"6", "activity-time"=>"3 min", "activity-priority"=>"1", "activity-metacognition"=>"", "activity-guidance"=>"", "activity-content-development-notes"=>""}]
        end

        it 'returns valid object' do
          expect(subject.children.size).to eq 1
          expect(subject.children[0].title).to eq 'Opening'
          expect(subject.children[0].time).to eq 5
          expect(subject.children[0].children.size).to eq 3
          expect(subject.children[0].children[1].activity_time).to eq 0
          expect(subject.children[0].children[2].activity_time).to eq 3
          expect(subject.children[0].children[2].time).to eq 3
        end
      end
      describe 'with multiple section' do
        let(:activity_table) do
          [{"section-title"=>"Opening", "activity-type"=>"Fluency Activity", "activity-title"=>"Skip-Count by Tens: Up and Down Crossing 100", "activity-source"=>"ENY-G2-M3-L1-F#4", "activity-materials"=>"", "activity-standard"=>"2.NBT.A.2", "activity-mathematical-practice"=>"", "activity-time"=>"2 min", "activity-priority"=>"2", "activity-metacognition"=>"", "activity-guidance"=>"", "activity-content-development-notes"=>""},
          {"section-title"=>"Opening", "activity-type"=>"Fluency Activity", "activity-title"=>"Unit Form Counting from 398 to 405", "activity-source"=>"ENY-G2-M3-L6-F#2", "activity-materials"=>"ENY-G2-M3-L4-T#1", "activity-standard"=>"2.NBT.A.3", "activity-mathematical-practice"=>"6", "activity-time"=>"", "activity-priority"=>"1", "activity-metacognition"=>"", "activity-guidance"=>"", "activity-content-development-notes"=>""},
          {"section-title"=>"Opening 2", "activity-type"=>"Fluency Activity", "activity-title"=>"Unit Form Counting from 398 to 405", "activity-source"=>"ENY-G2-M3-L6-F#2", "activity-materials"=>"ENY-G2-M3-L4-T#1", "activity-standard"=>"2.NBT.A.3", "activity-mathematical-practice"=>"6", "activity-time"=>"3 min", "activity-priority"=>"1", "activity-metacognition"=>"", "activity-guidance"=>"", "activity-content-development-notes"=>""}]
        end

        it 'returns valid object' do
          expect(subject.children.size).to eq 2
          expect(subject.children[0].title).to eq 'Opening'
          expect(subject.children[1].title).to eq 'Opening 2'
          expect(subject.children[0].time).to eq 2
          expect(subject.children[1].time).to eq 3
          expect(subject.children[0].children.size).to eq 2
          expect(subject.children[1].children.size).to eq 1
        end
      end
    end
  end
end
