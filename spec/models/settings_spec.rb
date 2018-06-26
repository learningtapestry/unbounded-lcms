# frozen_string_literal: true

require 'rails_helper'

describe Settings do
  it 'has valid factory' do
    expect(build :setting).to be_valid
  end

  describe 'storage for settings by keys' do
    let(:key) { :editing_enabled }
    let(:default_value) { true }
    let(:value) { 'value' }

    it 'creates initial settings for specified key' do
      expect(Settings[key]).to eq default_value
    end

    it 'reads the settings by keys' do
      Settings[:test] # to initiate empty settings
      Settings.last.update data: { key => value }
      expect(Settings[key]).to eq value
    end

    it 'writes settings by keys' do
      Settings[key] = value
      expect(Settings[key]).to eq value
    end

    it 'raises an error if unknown method is called' do
      expect{ Settings.fake }.to raise_error NoMethodError
    end
  end
end
