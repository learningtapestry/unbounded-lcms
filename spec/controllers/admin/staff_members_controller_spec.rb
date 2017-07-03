require 'rails_helper'

describe Admin::StaffMembersController do
  let(:user) { create :admin }

  before { sign_in user }

  describe '#index' do
    subject { get :index }
    it { is_expected.to be_success }
  end

  describe '#new' do
    subject { get :new }
    it { is_expected.to be_success }
  end
end
