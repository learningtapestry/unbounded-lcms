# frozen_string_literal: true

SocialMediaPresenter.class_eval do
  def description
    desc = if content_guide?
             subject = target.subject == 'ela' ? 'english language' : 'mathematics'
             "These guides are designed to explain what new, high standards for #{subject} "\
             'say about what students should learn in each grade, and what they mean for '\
             'curriculum and instruction'
             # elsif quick_reference_guide?
             #   subject = target.subject == 'ela'? 'ELA' : 'Mathematics'
             #   "This QRD outlines Elements of Aligned #{subject} Instruction and demonstrates "\
             #   "relationships between the elements to assist educators."
           else
             target.try(:teaser).try(:html_safe)
           end
    clean(desc) || clean(view.content_for(:og_description)) || view.page_description
  end

  def content_guide?
    target.is_a?(ContentGuide) || target.is_a?(ContentGuidePresenter)
  end
end
