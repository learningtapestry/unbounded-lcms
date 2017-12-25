# frozen_string_literal: true

require 'rails_helper'

feature 'Admin adds a material' do
  SAMPLE_PATH = 'spec/features/admin/materials/sample-materials'

  given(:downloaded_file) { Struct.new :last_modifying_user, :modified_time, :name, :version }

  given(:samples) do
    {
      gdoc: {
        file_name: 'vocabulary-chart.html',
        url: 'https://docs.google.com/document/d/1YTQxmi2rb405wx00xJY6NKD0VYQ5BhxLdSs4jR8o1a4/edit'
      },
      pdf: {
        file_name: 'vocabulary-chart.pdf',
        url: 'https://docs.google.com/document/d/1YTQxmi2rb405wx00xJY6NKD0VYQ5BhxLdSs4jR8o1a4/edit'
      }
    }
  end

  given(:user) { create :admin }

  background do
    sign_in user
    # stub Google Auth
    allow_any_instance_of(Admin::MaterialsController).to receive(:google_authorization)
  end

  scenario 'GDoc material' do
    data = samples[:gdoc]

    visit new_admin_material_path
    expect(page).to have_field :material_form_link

    # stub GDoc download
    file_content = File.read File.join(SAMPLE_PATH, data[:file_name])
    allow_any_instance_of(DocumentDownloader::Base).to receive(:file)
                                                         .and_return(downloaded_file.new(nil, nil, data[:file_name]))
    allow_any_instance_of(DocumentDownloader::Gdoc).to receive_message_chain(:download, :content)
                                                         .and_return(file_content)

    fill_in :material_form_link, with: data[:url]
    click_button 'Parse'

    expect(Material.last.name).to eql(data[:file_name])
  end

  scenario 'PDF material' do
    data = samples[:pdf]

    visit new_admin_material_path(source_type: 'pdf')
    expect(page).to have_field :material_form_link

    # stub PDF download
    allow_any_instance_of(DocumentDownloader::Base).to receive(:file)
                                                         .and_return(downloaded_file.new(nil, nil, data[:file_name]))

    file_content = File.read File.join(SAMPLE_PATH, data[:file_name])
    allow_any_instance_of(DocumentDownloader::PDF).to receive(:pdf_content).and_return(file_content)
    allow_any_instance_of(DocumentExporter::Thumbnail).to receive(:export)
    allow_any_instance_of(DocumentExporter::Thumbnail).to receive(:orientation)
    allow(S3Service).to receive(:upload)

    fill_in :material_form_link, with: data[:url]
    click_button 'Parse'

    expect(Material.last.name).to eql(data[:file_name])
  end
end
