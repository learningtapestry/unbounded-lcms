require 'rails_helper'

describe Material do
  it 'has valid factory' do
    expect(create(:material)).to be_valid
  end

  describe 'validations' do
    it 'has a file_id' do
      material = Material.new
      expect(material.valid?).to be false
      expect(material.errors[:file_id]).to eq ["can't be blank"]
    end
  end

  describe '.where_metadata' do
    before { create(:material, metadata: { type: 'vocabulary_chart' }) }

    it { expect(Material.where_metadata(type: 'vocabulary_chart').count).to eq 1 }
  end
end
