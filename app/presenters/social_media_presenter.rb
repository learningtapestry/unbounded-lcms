class SocialMediaPresenter
  attr_reader :target, :view

  def initialize(target:, view:)
    @target = target
    @view = view
  end

  def title
    return nil unless target

    title_ = if target.is_a?(ResourcePresenter)
      g = target.grade_avg rescue nil
      if g
        grade_color_code = g.include?('k') ? g : "G#{g}"
        "#{target.subject.try(:upcase)} #{grade_color_code.try(:upcase)}: #{target.title}"
      else
        "#{target.subject.try(:upcase)}: #{target.title}"
      end
    else
      target.title.try(:html_safe)
    end
    view.strip_tags_and_squish(title_) if target
  end

  def description
    return nil unless target

    desc = target.teaser.try(:html_safe)
    view.strip_tags_and_squish(desc)
  end

  def default
    OpenStruct.new(
      image: thumbnails[:all] || view.page_og_image,
      title: title || view.page_og_title,
      description: description || view.page_og_description,
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
          dict[thumb.media] = thumb.image.url
          dict
        end.with_indifferent_access
      else
        {}
      end
    end
  end
end
