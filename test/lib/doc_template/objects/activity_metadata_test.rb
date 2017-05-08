require 'test_helper'
require 'doc_template/objects/activity_metadata'

describe DocTemplate::ActivityMetadata do
  describe '.build_from' do
    subject { DocTemplate::ActivityMetadata.build_from(activity_table) }

    describe 'empty data' do
      let(:activity_table)  { [] }

      it 'returns empty object' do
        expect(subject.groups.size).must_equal 0
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
          expect(subject.groups.size).must_equal 1
          expect(subject.groups[0].title).must_equal 'Opening'
          expect(subject.groups[0].time).must_equal 5
          expect(subject.groups[0].children.size).must_equal 3
          expect(subject.groups[0].children[1].activity_time).must_equal 0
          expect(subject.groups[0].children[2].activity_time).must_equal 3
          expect(subject.groups[0].children[2].time).must_equal 3
        end
      end
      describe 'with multiple section' do
        let(:activity_table) do
          [{"section-title"=>"Opening", "activity-type"=>"Fluency Activity", "activity-title"=>"Skip-Count by Tens: Up and Down Crossing 100", "activity-source"=>"ENY-G2-M3-L1-F#4", "activity-materials"=>"", "activity-standard"=>"2.NBT.A.2", "activity-mathematical-practice"=>"", "activity-time"=>"2 min", "activity-priority"=>"2", "activity-metacognition"=>"", "activity-guidance"=>"", "activity-content-development-notes"=>""},
          {"section-title"=>"Opening", "activity-type"=>"Fluency Activity", "activity-title"=>"Unit Form Counting from 398 to 405", "activity-source"=>"ENY-G2-M3-L6-F#2", "activity-materials"=>"ENY-G2-M3-L4-T#1", "activity-standard"=>"2.NBT.A.3", "activity-mathematical-practice"=>"6", "activity-time"=>"", "activity-priority"=>"1", "activity-metacognition"=>"", "activity-guidance"=>"", "activity-content-development-notes"=>""},
          {"section-title"=>"Opening 2", "activity-type"=>"Fluency Activity", "activity-title"=>"Unit Form Counting from 398 to 405", "activity-source"=>"ENY-G2-M3-L6-F#2", "activity-materials"=>"ENY-G2-M3-L4-T#1", "activity-standard"=>"2.NBT.A.3", "activity-mathematical-practice"=>"6", "activity-time"=>"3 min", "activity-priority"=>"1", "activity-metacognition"=>"", "activity-guidance"=>"", "activity-content-development-notes"=>""}]
        end

        it 'returns valid object' do
          expect(subject.groups.size).must_equal 2
          expect(subject.groups[0].title).must_equal 'Opening'
          expect(subject.groups[1].title).must_equal 'Opening 2'
          expect(subject.groups[0].time).must_equal 2
          expect(subject.groups[1].time).must_equal 3
          expect(subject.groups[0].children.size).must_equal 2
          expect(subject.groups[1].children.size).must_equal 1
        end
      end
    end
  end
end
