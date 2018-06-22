# frozen_string_literal: true

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
    end

    context 'with invalid params' do
      before { allow_any_instance_of(Standard).to receive(:update).and_return(false) }

      it 'renders edit' do
        expect(subject).to render_template :edit
      end
    end
  end
end
