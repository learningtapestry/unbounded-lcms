module Admin::LessonDocumentsHelper
  def curriculum_breadcrumbs(lesson)
    return unless lesson.metadata.present?
    breadcrumbs = %w(grade module topic unit lesson).map do |k|
      if lesson.metadata[k]
        if k == 'module' && lesson.metadata[k].include?('strand')
          lesson.metadata[k].gsub(' strand', '')
        else
          "#{k.first.upcase}#{lesson.metadata[k]}"
        end
      end
    end.compact.join(' | ')
     "#{lesson.metadata['subject'].try(:upcase)} | #{breadcrumbs}".html_safe
  end
end
