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

  describe 'change prereq positioning when type changes' do
    let(:metadata) { { 'type' => 'fs', 'subject' => 'math', 'grade' => '1', 'unit' => '1', 'topic' => 'A' } }

    let!(:documents) do
      build_resources_chain(['math', 'grade 1', 'module 1', 'topic A'])
      3.times.map { |i| create :document, metadata: metadata.merge('lesson' => (i + 1).to_s) }
    end

    let(:document) { documents.last }

    it 're-position prereqs at the begining' do
      expect(document.prereq?).to be false
      expect(document.resource.level_position).to eq 2

      document.metadata['type'] = 'prereq'
      document.save!

      expect(document.reload.prereq?).to be true
      expect(document.resource.short_title).to eq 'lesson 3'
      expect(document.resource.level_position).to eq 0
    end
  end
end
