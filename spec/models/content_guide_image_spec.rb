# frozen_string_literal: true

require 'rails_helper'

describe ContentGuideImage do
  describe '.find_or_create_by_original_url' do
    let(:object) { double }
    let(:url) { 'url' }

    subject { described_class.find_or_create_by_original_url url }

    it 'creates new record with passed in URL value' do
      expect(described_class).to receive(:create_with).with(remote_file_url: url).and_return(object)
      expect(object).to receive(:find_or_create_by!).with(original_url: url)
      subject
    end

    context 'when validation fails' do
      it 'raises an error' do
        expect{ subject }.to raise_exception(ActiveRecord::RecordInvalid)
      end
    end
  end
end
