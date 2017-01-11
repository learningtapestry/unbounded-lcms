require 'fileutils'

class GenerateSVGThumbnailService
  include ERB::Util

  attr_reader :resource, :curriculum, :media

  def initialize(model, media: nil)
    if model.is_a?(ContentGuide)
      @resource = model
    elsif model.is_a?(Curriculum)
      @curriculum = model
      @resource = model.resource
    else
      @curriculum = model.curriculums.last
      @resource = model
    end
    @media = media || :all
  end

  def tmp_dir
    @@tmp_dir ||= begin
      dir = Rails.root.join('tmp', 'svgs')
      FileUtils.mkdir_p dir
      dir
    end
  end

  def file_name
    "#{resource_type}_#{resource.id}_#{media}.svg"
  end

  def rendered
    ERB.new(template).result(binding)
  end

  def run
    File.open(tmp_dir.join(file_name), 'w') { |f| f.write rendered }
  end

  def template
    @@template ||= File.read(Rails.root.join 'app', 'views', 'shared', 'social_thumb.svg.erb')
  end

  # =========================
  # Helper methods

  def asset_path(asset)
    ApplicationController.helpers.asset_path(asset)
  end

  def base64_encoded_asset(asset)
    @@base64_cache = {}
    @@base64_cache.fetch asset do
      encoded = ApplicationController.helpers.base64_encoded_asset(asset)
      @@base64_cache[asset] = encoded
    end
  end

  def size
    @@size_map ||= {
      all:       {width:  600, height: 600},
      facebook:  {width: 1200, height: 627},
      pinterest: {width:  600, height: 800},
      twitter:   {width:  440, height: 220},
    }.with_indifferent_access

    @@size_map[media]
  end

  def logo_size
    proportion = footer_size / 100.0
    {width: 280 * proportion, height: 50 * proportion}
  end

  def footer_size
    case media
    when :twitter then 50
    else               100
    end
  end

  def em
    case media
    when :twitter  then 14
    when :facebook then 26
    else                22
    end
  end

  def style
    @style ||= {
      padding:       (
        case media
        when :twitter then em
        else 1.5 * em
        end
      ),
      font_size:     em,
      font_size_big: 2.5 * em,
    }.with_indifferent_access
  end

  def number_of_lines
    case media
    when :pinterest then 7
    when :twitter   then 3
    else                 5
    end
  end

  def subject_and_grade
    grades = GenericPresenter.new(resource).grades_to_str
    if grades == 'Grade PK'
      grades = 'Prekindergarten'
    elsif grades == 'Grade K'
      grades = 'Kindergarten'
    end
    "#{resource.subject.upcase}  #{grades}"
  end

  def resource_type
    resource.class.name.underscore
  end

  def content_type
    if resource.is_a?(ContentGuide)
      'CONTENT GUIDE'
    elsif resource.generic?
      'OTHER RESOURCE'
    elsif resource.video?
      'VIDEO'
    elsif resource.podcast?
      'PODCAST'
    else
      curriculum.curriculum_type.name.upcase
    end
  end

  def title_width_threshold
    case media
    when :twitter  then 25
    when :facebook then 39
    else                21
    end
  end

  def title_sentences
    buffer = ''
    sentences = []
    resource.title.gsub('-', '- ').split.each do |word|
      if (buffer + word).size < title_width_threshold
        buffer = [buffer, word].select(&:present?).join(' ')
        buffer = buffer.gsub('- ', '-')
      else
        sentences << buffer
        buffer = word
      end
    end
    sentences << buffer if buffer.size > 0
  end

  def title_top_margin
    case media
    when :pinterest then 3   * style[:padding]
    when :facebook  then 2.5 * style[:padding]
    else                 2   * style[:padding]
    end
  end

  def color_code
    grade = resource.grade_avg rescue :base
    color_codes[:"#{resource.subject}_#{grade}"]
  end

  def color_codes
    @@color_codes ||= {
      ela_base: '#f75b28',
      ela_pk:   '#fda43a',
      ela_k:    '#fc9837',
      ela_1:    '#fb8d32',
      ela_2:    '#f7802c',
      ela_3:    '#f97529',
      ela_4:    '#f96924',
      ela_5:    '#f85e20',
      ela_6:    '#f0501a',
      ela_7:    '#e94d1a',
      ela_8:    '#e14b19',
      ela_9:    '#da4818',
      ela_10:   '#d34617',
      ela_11:   '#cc4417',
      ela_12:   '#c54116',

      math_base: '#00a699',
      math_pk:   '#69d59d',
      math_k:    '#5bcf9d',
      math_1:    '#4cc89c',
      math_2:    '#3cc19b',
      math_3:    '#2ebb9b',
      math_4:    '#1eb49a',
      math_5:    '#0fad9a',
      math_6:    '#009d90',
      math_7:    '#009488',
      math_8:    '#008b7f',
      math_9:    '#008277',
      math_10:   '#00796e',
      math_11:   '#007066',
      math_12:   '#00675d',
    }
  end
end
