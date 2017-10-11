# frozen_string_literal: true

require 'rails_helper'

feature 'Admin adds a material' do
  SAMPLE_PATH = 'spec/features/admin/materials/sample-materials'

  given(:downloaded_file) { Struct.new :last_modifying_user, :modified_time, :name, :version }

  given(:samples) do
    [
      {
        url: 'https://docs.google.com/document/d/1YTQxmi2rb405wx00xJY6NKD0VYQ5BhxLdSs4jR8o1a4/edit',
        file_name: 'vocabulary-chart.html'
      }
    ]
  end
  given(:user) { create :admin }

  background do
    sign_in user

    # stub Google Auth
    allow_any_instance_of(Admin::MaterialsController).to receive(:obtain_google_credentials)
  end

  # TODO: Need full refactor after #558
  xscenario 'admin adds sample materials', :js do
    samples.each_with_index do |data, idx|
      visit new_admin_material_path
      expect(page).to have_field :material_form_link

      # stub GDoc download
      file_content = File.read File.join(SAMPLE_PATH, data[:file_name])
      allow_any_instance_of(DocumentDownloader::Gdoc).to receive(:file).and_return(downloaded_file.new(nil, nil, idx))
      allow_any_instance_of(DocumentDownloader::Gdoc).to receive(:content).and_return(file_content)

      fill_in :material_form_link, with: data[:url]
      click_button 'Parse'

      expect(Material.last.name).to eql(idx.to_s)
    end
  end
end
