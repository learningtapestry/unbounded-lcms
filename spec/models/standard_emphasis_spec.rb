require 'rails_helper'

describe StandardEmphasis do
  it 'has valid factory' do
    obj = create :standard_emphasis
    expect(obj).to be_valid
  end

  context 'relations' do
    it { is_expected.to belong_to(:standard) }
  end
end
