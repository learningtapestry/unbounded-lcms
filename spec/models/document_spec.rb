# frozen_string_literal: true

require 'rails_helper'

describe Document do
  it 'has valid factory' do
    object = create(:document)
    expect(object).to be_valid
  end

  subject { create :document }

  it { expect(subject).to have_and_belong_to_many(:materials) }

  describe '#foundational?' do
    let(:document) { build :document, metadata: metadata }
    let(:metadata) { { 'type' => 'fs' } }

    it 'returns true for foundational lesson' do
      expect(document.foundational?).to be_truthy
    end

    it 'returns false for others' do
      document.metadata['type'] = 'core'
      expect(document.foundational?).to be_falsey
    end
  end
end
