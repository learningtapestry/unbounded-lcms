require 'rails_helper'

describe ResourcesController do
  let(:resource) { create(:resource) }

  describe '#show' do
    context 'with slug' do
      before { get :show, slug: resource.slug }

      it { expect(response).to be_success }
      it { expect(assigns(:resource)).to be_present }
      it { expect(assigns(:props)).to_not be_nil }
    end

    context 'with id' do
      before { get :show, id: resource.id }

      it { expect(response).to redirect_to("/#{resource.slug}") }
    end

    context 'grade' do
      let(:resource) { create(:resource, :grade) }
      before { get :show, slug: resource.slug }
      it { expect(response).to redirect_to explore_curriculum_index_path(p: resource.slug, e: 1) }
    end

    context 'module' do
      let(:resource) { create(:resource, :module) }
      before { get :show, slug: resource.slug }
      it { expect(response).to redirect_to explore_curriculum_index_path(p: resource.slug, e: 1) }
    end
  end
end
