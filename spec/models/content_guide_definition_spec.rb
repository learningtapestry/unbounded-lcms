# frozen_string_literal: true

require 'rails_helper'

describe ContentGuideDefinition do
  it 'has valid factory' do
    expect(build :content_guide_definition).to be_valid
  end

  context 'cannot be create with the same' do
    let(:keyword) { Faker::Lorem.word }

    before { create :content_guide_definition, keyword: keyword }

    it 'keyword' do
      obj = build :content_guide_definition, keyword: keyword
      expect(obj).to_not be_valid
    end
  end

  context 'cannot be created without' do
    it 'description' do
      obj = build :content_guide_definition, description: nil
      expect(obj).to_not be_valid
    end

    it 'keyword' do
      obj = build :content_guide_definition, keyword: nil
      expect(obj).to_not be_valid
    end
  end
end
