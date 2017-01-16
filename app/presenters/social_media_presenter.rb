class SocialMediaPresenter
  attr_reader :target, :view

  def initialize(target:, view:)
    @target = target
    @view = view
  end

  def title
    target.title.try(:html_safe)
  end

  def description
    target.teaser.try(:html_safe)
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
    @twitter ||= begin
      twitter_descr = if content_guide?
        subject = target.subject == 'ela'? 'english language' : 'mathematics'
        "These guides are designed to explain what new, high standards for #{subject} "\
        "say about what students should learn in each grade, and what they mean for "\
        "curriculum and instruction"
      elsif
        subject = target.subject == 'ela'? 'ELA' : 'Mathematics'
        "This QRD outlines Elements of Aligned #{subject} Instruction and demonstrates "\
        "relationships between the elements to assist educators."
      else
        description
      end
      byebug
      OpenStruct.new default.to_h.merge(
        image: thumbnails[:twitter],
        description: twitter_descr
      )
    end
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

  def content_guide?
    target.class.name.match /ContentGuide/  # migth be a presenter
  end

  def quick_reference_guide?
    # TODO fixme
    target.is_a?(Resource) && target.quick_reference_guide?
  end
end
