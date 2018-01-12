require 'rails_helper'

describe DocTemplate::Tags::BaseTag do
  describe '.config' do
    subject { described_class.config }

    before { described_class.instance_variable_set :@config, nil }

    it 'loads YAML file' do
      expect(YAML).to receive(:load)
      subject
    end

    it 'caches once loaded file' do
      subject
      expect(YAML).to_not receive(:load)
      subject
    end
  end
end
