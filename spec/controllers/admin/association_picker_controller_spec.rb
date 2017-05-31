require 'rails_helper'

describe Admin::AssociationPickerController do
  let(:user) { create :admin }

  before { sign_in user }

  describe '#index' do
    subject { get :index, association: 'tags', format: :json }
    it { is_expected.to be_success }
  end
end
