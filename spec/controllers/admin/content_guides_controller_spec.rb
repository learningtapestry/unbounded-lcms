require 'rails_helper'

describe Admin::ContentGuidesController do
  let(:user) { create :admin }
  let(:content_guide) { create :content_guide }

  before { sign_in user }

  describe '#index' do
    subject { get :index }
    it { is_expected.to be_success }
  end

  describe '#edit' do
    before { allow_any_instance_of(ContentGuide).to receive(:validate_metadata) }
    subject { get :edit, id: content_guide.id }
    it { is_expected.to be_success }
  end
end
