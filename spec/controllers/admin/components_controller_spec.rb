require 'rails_helper'

describe Admin::ComponentsController do
  let(:user) { create :admin }
  let(:api_resp) { double(:'success?' => true, body: { results: [], total: 0, page: 1, per_page: 10 }.to_json) }

  before do
    sign_in user
    allow(HTTParty).to receive(:get).and_return(api_resp)
  end

  subject { get :index }
  it { is_expected.to be_success }
end
