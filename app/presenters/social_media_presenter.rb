class SocialMediaPresenter
  attr_reader :target, :view

  def initialize(target:, view:)
    @target = target
    @view = view
  end

  def title
    title_ = target.try(:title).try(:html_safe)
    clean(title_) || clean(view.content_for(:og_title)) || view.page_title
  end

  def description
    desc = if content_guide?
      subject = target.subject == 'ela'? 'english language' : 'mathematics'
      "These guides are designed to explain what new, high standards for #{subject} "\
      "say about what students should learn in each grade, and what they mean for "\
      "curriculum and instruction"
    elsif quick_reference_guide?
      subject = target.subject == 'ela'? 'ELA' : 'Mathematics'
      "This QRD outlines Elements of Aligned #{subject} Instruction and demonstrates "\
      "relationships between the elements to assist educators."
    else
      target.try(:teaser).try(:html_safe)
    end
    clean(desc) || clean(view.content_for(:og_description)) || view.page_description
  end

  def default
    OpenStruct.new(
      # use facebook image as default
      image: thumbnails[:facebook] || view.page_og_image,
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
      # use same image as facebook for twitter
      image: thumbnails[:facebook]
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

  def content_guide?
    target.is_a?(ContentGuide) || target.is_a?(ContentGuidePresenter)
  end

  def quick_reference_guide?
    (target.is_a?(Resource) || target.is_a?(ResourcePresenter)) && target.quick_reference_guide?
  end
end
