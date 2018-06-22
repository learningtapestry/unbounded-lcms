# frozen_string_literal: true

require 'rails_helper'

describe Admin::AssociationPickerController do
  ASSOCIATIONS = %w(content_sources tags grades topics reading_assignment_authors
                    reading_assignment_texts standards).freeze

  let(:user) { create :admin }

  before { sign_in user }

  describe '#index' do
    ASSOCIATIONS.each do |assoc|
      it "list #{assoc} association items" do
        get :index, association: assoc, format: :json
        expect(response).to be_success
      end
    end
  end
end
