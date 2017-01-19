class SocialMediaPresenter
  attr_reader :target, :view

  def initialize(target:, view:)
    @target = target
    @view = view
  end

  def title
    title_ = if target.is_a?(ResourcePresenter)
      g = target.grade_avg rescue nil
      if g
        grade_color_code = g.include?('k') ? g : "G#{g}"
        "#{target.subject.try(:upcase)} #{grade_color_code.try(:upcase)}: #{target.title}"
      else
        "#{target.subject.try(:upcase)}: #{target.title}"
      end
    else
      target.try(:title).try(:html_safe)
    end
    clean(title_) || clean(view.content_for(:og_title)) || view.page_title
  end

  def description
    desc = target.try(:teaser).try(:html_safe)
    clean(desc) || clean(view.content_for(:og_description)) || view.page_description
  end

  def default
    OpenStruct.new(
      image: thumbnails[:all] || view.page_og_image,
      title: title,
      description: description,
    )
  end

  def facebook
    @facebook ||= OpenStruct.new default.to_h.merge(
      image: thumbnails[:facebook]
    )
  end

  def twitter
    @twitter ||= OpenStruct.new default.to_h.merge(
      image: thumbnails[:twitter]
    )
  end

  def pinterest
    @pinterest ||= OpenStruct.new default.to_h.merge(
      image: thumbnails[:pinterest]
    )
  end

  def thumbnails
    @thumbnails ||=  begin
      if target
        target.social_thumbnails.reduce({}) do |dict, thumb|
          dict[thumb.media] = thumb.image.url + "?ts=#{Time.now.to_i}#{Random.rand(1_000_000)}"
          dict
        end.with_indifferent_access
      else
        {}
      end
    end
  end

  def clean(str)
    view.strip_tags_and_squish(str)
  end
end
