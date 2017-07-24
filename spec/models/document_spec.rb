# frozen_string_literal: true

require 'rails_helper'

describe Document do
  it 'has valid factory' do
    object = create(:document)
    expect(object).to be_valid
  end

  subject { create :document }

  it { expect(subject).to have_and_belong_to_many(:materials) }
end
