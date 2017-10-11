# frozen_string_literal: true

class DocumentBuildService
  GOOGLE_DRAWING_RE = %r{https?://docs\.google\.com/?[^"]*/drawings/[^"]*}i

  def initialize(credentials)
    @credentials = credentials
  end

  #
  # @return Document Builded ActiveRecord::Model
  #
  def build_for(url, expand: false)
    @content = download url
    @expand_document = expand

    parse_template
    create_document

    content_key = template.foundational? ? :foundational_content : :original_content
    @document.update! content_key => content

    build
    create_parts

    document.activate!
    document
  end

  private

  attr_reader :credentials, :content, :document, :downloader, :expand_document, :template

  # Building the document. Handles workflows:
  # Core-frist FS-second and FS-first Core-second.
  def build
    if expand_document
      combine_layout
      combine_activity_metadata
      document.update! build_params.merge(toc: combine_toc)
    else
      document.document_parts.delete_all
      document.update! document_params.merge(toc: template.toc)
    end
  end

  def build_params
    params =
      if template.foundational?
        {
          foundational_metadata: template.foundational_metadata,
          fs_name: downloader.file.name
        }
      else
        document_params.merge(
          foundational_metadata: document.foundational_metadata,
          fs_name: document.name,
          name: downloader.file.name
        )
      end

    params[:material_ids] =
      if expand_document
        # if document is being expanded - we have to concat materials
        @document.material_ids.concat collect_materials
      else
        collect_materials
      end
    params
  end

  def collect_materials
    activity_ids = template
                     .activity_metadata
                     .flat_map { |a| a['material_ids'] }
                     .compact

    meta_ids = [].tap do |res|
      template.agenda.each do |x|
        x[:children].each { |a| res << a[:metadata]['material_ids'] }
      end
    end.compact.flatten

    activity_ids.concat(meta_ids).uniq
  end

  def combine_activity_metadata
    old_data = document.activity_metadata
    new_data =
      if template.foundational?
        old_data.concat template.activity_metadata
        old_data
      else
        template.activity_metadata.concat old_data
        template.activity_metadata
      end
    document.activity_metadata = new_data
  end

  def combine_layout
    DocumentPart.context_types.keys.each do |context_type|
      existing_layout = document.layout(context_type)
      new_layout = template.remove_part :layout, context_type
      new_layout_content =
        if template.foundational?
          "#{existing_layout.content}#{new_layout[:content]}"
        else
          "#{new_layout[:content]}#{existing_layout.content}"
        end
      existing_layout.update content: new_layout_content
    end
  end

  def combine_toc
    modifier = template.foundational? ? :append : :prepend
    toc = document.toc
    toc.send modifier, template.toc
    toc
  end

  # Initiate or update existing document:
  # - fills in original or fs contents
  # - stores specific file_id for each type of a lesson
  def create_document
    if template.metadata['subject'].casecmp('ela').zero?
      @document = Document.actives.find_or_initialize_by(file_id: downloader.file_id)
    elsif template.foundational?
      @document = find_core_document
      @expand_document ||= @document.present?
      @document.foundational_file_id = downloader.file_id if @document.present?
      @document ||= Document.actives.find_or_initialize_by(foundational_file_id: downloader.file_id)
    else
      @document = find_fs_document
      @expand_document ||= @document.present?
      @document.file_id = downloader.file_id if @document.present?
      @document ||= Document.actives.find_or_initialize_by(file_id: downloader.file_id)
    end
  end

  def create_parts
    template.parts.each do |part|
      document.document_parts.create!(
        active: true,
        anchor: part[:anchor],
        content: part[:content],
        context_type: part[:context_type],
        materials: part[:materials],
        part_type: part[:part_type],
        placeholder: part[:placeholder]
      )
    end
  end

  def document_params
    {
      activity_metadata: template.activity_metadata,
      agenda_metadata: template.agenda,
      css_styles: template.css_styles,
      foundational_metadata: template.foundational_metadata,
      name: downloader.file.name,
      last_modified_at: downloader.file.modified_time,
      last_author_email: downloader.file.last_modifying_user.try(:email_address),
      last_author_name: downloader.file.last_modifying_user.try(:display_name),
      material_ids: collect_materials,
      metadata: template.metadata,
      version: downloader.file.version
    }
  end

  def download(url)
    @downloader = DocumentDownloader::Gdoc.new(credentials, url).download
    @downloader.content
  end

  #
  # If there is existing lesson with Core-type - return it. Nil otherwise.
  #
  def find_core_document
    return unless (core_doc = find_resource)
    return if core_doc.foundational?
    core_doc
  end

  #
  # If there is existing lesson with FS-type - return it. Nil otherwise.
  #
  def find_fs_document
    return unless (fs_doc = find_resource)
    return unless fs_doc.foundational?
    fs_doc
  end

  def find_resource
    curriculum = MetadataContext.new(template.metadata.with_indifferent_access).curriculum
    Resource.find_by_curriculum(curriculum)&.document
  end

  def handle_google_drawings
    return content unless (match = content.scan(GOOGLE_DRAWING_RE))

    headers = { 'Authorization' => "Bearer #{credentials.access_token}" }

    match.to_a.uniq.each do |url|
      response = HTTParty.get CGI.unescapeHTML(url), headers: headers
      new_src = "data:#{response.content_type};base64, #{Base64.encode64(response)}\" drawing_url=\"#{url}"
      @content = content.gsub(url, new_src)
    end
  end

  def parse_template
    handle_google_drawings
    @template = DocTemplate::Template.parse(content)
  end
end
