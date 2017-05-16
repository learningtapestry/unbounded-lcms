require 'rails_helper'

describe LessonDocument do
  it 'has valid factory' do
    object = create(:lesson_document)
    expect(object).to be_valid
  end
end
