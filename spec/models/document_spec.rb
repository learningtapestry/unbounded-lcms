require 'rails_helper'

describe Document do
  it 'has valid factory' do
    object = create(:document)
    expect(object).to be_valid
  end
end
