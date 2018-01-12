require 'rails_helper'

describe SearchController do
  describe '#index' do
    before do
      sign_in create(:user)
      get :index
    end

    it { expect(response).to be_success }
    it { expect(response).to render_template(:index) }
    it { expect(assigns(:props)).to be_present }
  end
end
