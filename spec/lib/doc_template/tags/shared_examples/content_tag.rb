# frozen_string_literal: true

require 'rails_helper'

shared_examples 'content_tag' do
  context 'with soft return after start tag' do
    let(:original_content) do
      <<-HTML
        <p><span>[</span>#{described_class::TAG_NAME}]some content</p>
        <p>some content</p>
      HTML
    end

    it { expect { subject }.to raise_error(DocumentError) }
  end

  context 'with soft return before start tag' do
    let(:original_content) do
      <<-HTML
        <p><span>[</span>#{described_class::TAG_NAME}]some content</p>
        <p>some content</p>
      HTML
    end

    it { expect { subject }.to raise_error(DocumentError) }
  end

  context 'with soft return before stop tag' do
    let(:original_content) do
      <<-HTML
        <p><span>[</span>#{described_class::TAG_NAME}]</p>
        <p>some content</p>
        <p><span>[</span>#{stop_tag}<span>]</span>some content</p>
      HTML
    end

    it { expect { subject }.to raise_error(DocumentError) }
  end

  context 'with soft return after stop tag' do
    let(:original_content) do
      <<-HTML
        <p><span>[</span>#{described_class::TAG_NAME}]</p>
        <p>some content</p>
        <p>some content<br><span>[</span>#{stop_tag}<span>]</span></p>
      HTML
    end

    it { expect { subject }.to raise_error(DocumentError) }
  end
end
