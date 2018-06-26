# frozen_string_literal: true

require 'rails_helper'

describe ContentGuideStandard do
  it 'has valid factory' do
    expect(build :content_guide_standard).to be_valid
  end
end
