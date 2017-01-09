class GenerateSVGThumbnailService
  include ERB::Util

  attr_reader :resource

  def initialize(resource)
    @resource = resource
  end

  def run
    ERB.new(template).result(binding)
  end

  def template
    # @@template ||=
    File.read template_path
  end

  def template_path
    @@template_path ||= Rails.root.join('app', 'views', 'shared', 'social_thumb.svg.erb')
  end

  def asset_path(asset)
    ActionController::Base.helpers.asset_path(asset)
  end

  def title_sentences
    buffer = ''
    sentences = []
    threshold = 20
    resource.title.split.each do |word|
      if (buffer + word).size < threshold
        buffer = [buffer, word].select(&:present?).join(' ')
      else
        sentences << buffer
        buffer = word
      end
    end
    sentences << buffer if buffer.size > 0
    sentences
  end

  def color_code
    color_codes[:"#{resource.subject}_#{resource.grade_avg}"]
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
