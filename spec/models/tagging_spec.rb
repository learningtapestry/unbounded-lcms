# frozen_string_literal: true

require 'rails_helper'

describe Tagging do
  it 'has valid factory' do
    expect(build :tagging).to be_valid
  end
end
