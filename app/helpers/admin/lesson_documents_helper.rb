module Admin::LessonDocumentsHelper
  def metadata_breadcrumbs(lesson)
    breadcrumbs = ['grade', 'module', 'topic', 'unit', 'lesson'].map do |k|
      if lesson.metadata[k]
        if k == 'module' && lesson.metadata[k].include?('strand')
          lesson.metadata[k].gsub(' strand', '')
        else
          "#{k.first.upcase} #{lesson.metadata[k]}"
        end
      end
    end.compact.join(' | ')
     "#{lesson.metadata['subject'].try(:upcase)} | #{breadcrumbs}".html_safe
  end
end
