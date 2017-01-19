class SVGSocialThumbnail
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

  def render
    @rendered ||= ERB.new(template).result(binding)
  end

  def template
    @@template ||= File.read template_path
  end

  def template_path
    Rails.root.join('app', 'views', 'shared', 'social_thumbnail.svg.erb')
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
      if asset =~ /\.ttf$/
        encoded.gsub!('data:application/x-font-ttf;base64,',
                      'data:font/truetype;charset=utf-8;base64,')
      end
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
    {width: 220 * proportion, height: 30 * proportion}
  end

  def footer_size
    case media
    when :twitter then 50
    else               100
    end
  end

  def em
    case media
    when :twitter   then 12
    when :facebook  then 26
    else                 22
    end
  end

  def style
    @style ||= {
      padding: 2*em,
      font_size: em,
      font_size_big: (
        case media
        when :facebook  then 3*em
        when :pinterest then 3.25*em
        else 2.5*em
        end
      ),
    }.with_indifferent_access
  end

  def title_width_threshold
    case media
    when :twitter   then 31
    when :facebook  then 32
    when :pinterest then 16
    else                 21
    end
  end

  def number_of_lines
    case media
    when :facebook  then 4
    when :pinterest then 7
    when :twitter   then 3
    else                 6
    end
  end

  def title_top_margin
    2 * style[:padding]
  end

  def subject_and_grade
    grades = GenericPresenter.new(resource).grades_to_str
    subject = resource.subject == 'ela' ? 'ELA' : 'Math'
    case grades
    when 'Grade PK' then 'Prekindergarten'
    when 'Grade K'  then 'Kindergarten'
    else "#{subject}  #{grades}"
    end
  end

  def resource_type
    resource.class.name.underscore
  end

  def content_type
    if resource.is_a?(ContentGuide)
      'CONTENT GUIDE'
    elsif resource.generic? || resource.media?
      resource.resource_type.humanize.upcase
    else
      curriculum.curriculum_type.name.upcase
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
