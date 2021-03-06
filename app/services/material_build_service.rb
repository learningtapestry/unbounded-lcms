# frozen_string_literal: true

class MaterialBuildService
  PDF_EXT_RE = /\.pdf$/

  def initialize(credentials, opts = {})
    @credentials = credentials
    @options = opts
  end

  def build(url)
    @url = url
    pdf? ? build_from_pdf : build_from_gdoc
  end

  private

  attr_reader :credentials, :downloader, :options, :url

  def build_from_pdf
    @downloader = DocumentDownloader::PDF.new(@credentials, url)
    create_material
    title = downloader.file.name.sub(PDF_EXT_RE, '')
    identifier = "#{title.downcase}#{ContentPresenter::PDF_EXT}"

    @material.update!(
      material_params.merge(
        identifier: identifier,
        metadata: DocTemplate::Objects::MaterialMetadata.build_from_pdf(identifier: identifier, title: title)
      )
    )

    @material.material_parts.delete_all

    basename = MaterialPresenter.new(@material).material_filename
    pdf_filename = "#{basename}#{ContentPresenter::PDF_EXT}"
    thumb_filename = "#{basename}#{ContentPresenter::THUMB_EXT}"

    pdf = downloader.pdf_content
    thumb_exporter = DocumentExporter::Thumbnail.new(pdf)
    thumb = thumb_exporter.export
    @material.metadata.orientation = thumb_exporter.orientation
    @material.metadata.pdf_url = S3Service.upload pdf_filename, pdf
    @material.metadata.thumb_url = S3Service.upload thumb_filename, thumb
    @material.save
    @material
  end

  def build_from_gdoc
    @downloader = DocumentDownloader::Gdoc.new(@credentials, url, options)
    create_material
    content = downloader.download.content
    parsed_document = DocTemplate::Template.parse(content, type: :material)

    @material.update!(
      material_params.merge(
        identifier: parsed_document.metadata['identifier'].downcase,
        metadata: parsed_document.meta_options(:default)[:metadata],
        original_content: content
      )
    )

    @material.material_parts.delete_all

    presenter = MaterialPresenter.new(@material, parsed_document: parsed_document)
    DocTemplate::CONTEXT_TYPES.each do |context_type|
      @material.material_parts.create!(
        active: true,
        content: presenter.render_content(context_type),
        context_type: context_type,
        part_type: :layout
      )
    end
    @material
  end

  def create_material
    @material = Material.find_or_initialize_by(file_id: downloader.file_id)
  end

  def material_params
    {
      name: downloader.file.name,
      last_modified_at: downloader.file.modified_time,
      last_author_email: downloader.file.last_modifying_user.try(:email_address),
      last_author_name: downloader.file.last_modifying_user.try(:display_name),
      reimported_at: Time.current,
      version: downloader.file.version
    }
  end

  def pdf?
    return options[:source_type].casecmp('pdf').zero? if options[:source_type].present?
    downloader = DocumentDownloader::Base.new credentials, url
    downloader.file.name.to_s =~ PDF_EXT_RE
  end
end
