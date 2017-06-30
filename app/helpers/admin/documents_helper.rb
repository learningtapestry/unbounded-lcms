module Admin::DocumentsHelper
  def curriculum_breadcrumbs(lesson)
    return unless lesson.metadata.present?
    breadcrumbs = %w(grade module unit topic lesson).map do |k|
      if lesson.metadata[k]
        if k == 'module' && lesson.metadata[k].include?('strand')
          lesson.metadata[k].gsub(' strand', '')
        elsif k == 'grade'
          grade = lesson.metadata[k]
          (grade && num = grade.match(/grade (\d+)/).try(:[], 1)) ? "G#{num}" : lesson.metadata[k]
        else
          "#{k.first.upcase}#{lesson.metadata[k]}"
        end
      end
    end.compact.join(' | ')
     "#{lesson.metadata['subject'].try(:upcase)} | #{breadcrumbs}".html_safe
  end
end
