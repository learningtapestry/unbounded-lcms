require 'rails_helper'

describe Admin::StandardsController do
  let(:standard) { create :standard }
  let(:user) { create :admin }

  before { sign_in user }

  describe '#edit' do
    subject { get :edit, id: standard.to_param }

    it { is_expected.to be_success }

    it { is_expected.to render_template 'edit' }
  end

  describe '#index' do
    subject { get :index }

    it { is_expected.to be_success }

    it { is_expected.to render_template 'index' }

    context 'filters' do
      let(:scope) { double }

      subject { get :index, query: params }

      context 'bilingual' do
        let(:params) { { is_language_progression_standard: 1 } }

        it { expect(Standard).to receive(:bilingual).and_call_original }
      end

      context 'name' do
        let(:name) { 'standard-name' }
        let(:params) { { name: name } }

        it { expect(Standard).to receive(:search_by_name).with(name).and_call_original }
      end

      context 'pagination' do
        let(:page) { '5' }
        let(:params) { { page: page } }
        let(:scope) { double }

        before { allow(Standard).to receive(:order).and_return(scope) }

        subject { get :index, params }

        it { expect(scope).to receive(:paginate).with(page: page) }
      end

      after { subject }
    end
  end

  describe '#update' do
    let(:description) { 's-description' }
    let(:params) { { description: description } }

    subject { post :update, id: standard.to_param, standard: params }

    context 'with valid params' do
      it { is_expected.to redirect_to admin_standards_path }

      it 'passes notice' do
        subject
        expect(flash[:notice]).to be_present
      end

      context 'with language_progression_file' do
        before { params.merge! language_progression_file: '1' }

        it 'set is_language_progression_standard to true' do
          new_params = params.merge is_language_progression_standard: true
          expect_any_instance_of(Standard).to receive(:update).with(new_params).and_call_original
          subject
        end
      end

      context 'with remove_language_progression_file' do
        before { params.merge! remove_language_progression_file: '1' }

        it 'set is_language_progression_standard to false' do
          new_params = params.merge is_language_progression_standard: false
          expect_any_instance_of(Standard).to receive(:update).with(new_params).and_call_original
          subject
        end
      end
    end

    context 'with invalid params' do
      before { allow_any_instance_of(Standard).to receive(:update).and_return(false) }

      it 'renders edit' do
        expect(subject).to render_template :edit
      end
    end
  end
end
