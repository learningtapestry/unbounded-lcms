# frozen_string_literal: true

require 'rails_helper'

describe Material do
  it 'has valid factory' do
    expect(create(:material)).to be_valid
  end

  subject { create :material }

  it { expect(subject).to have_and_belong_to_many(:documents) }

  describe 'validations' do
    it 'has a file_id' do
      material = build :material, file_id: nil
      expect(material).to_not be_valid
    end
  end

  describe '.where_metadata' do
    before { create(:material, metadata: { type: 'vocabulary_chart' }) }

    it { expect(Material.where_metadata(type: 'vocabulary_chart').count).to eq 1 }
  end
end
