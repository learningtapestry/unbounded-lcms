FactoryGirl.define do
  pilot_tree_file = File.read(Rails.root.join 'db', 'data',
                                              'pilot_curriculum_tree.json')
  pilot_tree_json = JSON.parse(pilot_tree_file)

  factory :curriculum_tree do
    default true
    name 'pilot'
    tree pilot_tree_json
  end
end
