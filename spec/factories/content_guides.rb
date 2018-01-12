FactoryGirl.define do
  file = File.read(Rails.root.join 'spec', 'support', 'fixtures', 'content_guide.json')
  fixture = JSON.parse(file)

  factory :content_guide do
    name 'Test ContentGuide'
    title 'Test ContentGuide'
    teaser 'UnboundEd Mathematics Guide'
    description 'This guide gives an illustrated “tour” of new state standards in mathematics, including a range of ideas for lessons and classroom activities.' # rubocop:disable Metrics/LineLength
    permalink '1'
    version 307_400
    subject 'math'
    file_id '1tjZJiYTHsevYIXoqhcM0ZHbaU0LxRDhqKcxhTakbes4'
    slug 'counting-cardinality-unbound-a-guide-to-kindergarten-mathematics-standards'

    content fixture['content']
    original_content fixture['original_content']

    after(:build) do |cg|
      cg.update_metadata = true
      cg.instance_variable_set(:@non_existent_podcasts, [])
      cg.instance_variable_set(:@non_existent_videos, [])
      cg.instance_variable_set(:@broken_links, [])
    end
  end
end
